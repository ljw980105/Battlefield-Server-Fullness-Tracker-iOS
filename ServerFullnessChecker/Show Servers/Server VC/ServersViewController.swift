//
//  ServersViewController.swift
//  ServerFullnessChecker
//
//  Created by Jing Wei Li on 4/30/20.
//  Copyright © 2020 Jing Wei Li. All rights reserved.
//

import UIKit
import Combine

class ServersViewController: UIViewController {
    @IBOutlet weak var muteUnmuteButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var disposeBag = [AnyCancellable]()
    var notificationMuted = false
    var subject = PassthroughSubject<Bool, Error>()
    var servers = [BattlefieldServer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        setupRx()
        getServers()

        tableView.register(UINib(nibName: "ServerTableViewCell", bundle: .main),
                           forCellReuseIdentifier: ServerTableViewCell.identifier)
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    // MARK: - IBAction
    
    @IBAction func muteUnmuteButtonTapped(_ sender: Any) {
        subject.send(notificationMuted)
    }
    
    @IBAction func addServer(_ sender: UIBarButtonItem) {
        let nav = UINavigationController(rootViewController: AddServerViewController())
        present(nav, animated: true, completion: nil)
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        getServers {
            sender.endRefreshing()
        }
    }
    
    // MARK: - Combine
    func getServers(done: @escaping () -> Void = {}) {
        ServerTrackerAPI.getServers()
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] servers in
                self?.servers = servers
                self?.tableView.reloadData()
                done()
            })
            .store(in: &disposeBag)
    }
    
    func setupRx() {
        ServerTrackerAPI.isNotificationsMuted()
            .map { $0.muted }
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] resp in
                self?.navigationItem.title = "Notification \(resp ? "Muted" : "Unmuted")"
                self?.notificationMuted = resp
            })
            .store(in: &disposeBag)
        
        subject.filter { $0 }
            .flatMap { _ in ServerTrackerAPI.unmuteNotifications() }
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in
                self?.navigationItem.title = "Notification Unmuted"
                self?.notificationMuted = false
            })
            .store(in: &disposeBag)
        
        subject.filter { !$0 }
            .flatMap { _ in ServerTrackerAPI.muteNotifications() }
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in
                self?.navigationItem.title = "Notification Muted"
                self?.notificationMuted = true
            })
            .store(in: &disposeBag)
    }
    
}

extension ServersViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: -  Table View Delegate x Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ServerTableViewCell.identifier, for: indexPath)
        
        if let cell = cell as? ServerTableViewCell {
            cell.setupWithServer(servers[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ServerDetailsViewController(server: servers[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

