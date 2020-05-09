//
//  ServerDetailsViewController.swift
//  ServerFullnessChecker
//
//  Created by Jing Wei Li on 5/8/20.
//  Copyright © 2020 Jing Wei Li. All rights reserved.
//

import UIKit
import Combine
import Kingfisher

class ServerDetailsViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var serverName: UILabel!
    @IBOutlet weak var serverDetails: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playerCount: UILabel!
    
    let server: BattlefieldServer
    var disposeBag = CombineDisposeBag()
    var players = [BattlelogPlayerDetail]()
    
    init(server: BattlefieldServer) {
        self.server = server
        super.init(nibName: "ServerDetailsViewController", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ServerDetailsTableViewCell", bundle: .main),
                           forCellReuseIdentifier: ServerDetailsTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        Publishers.Zip(
            ServerTrackerAPI.getDetailForServerWithId(server.id, game: server.game),
            ServerTrackerAPI.getPlayersOnServer(server)
        )
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] data, players in
                guard let strongSelf = self else { fatalError() }
                strongSelf.serverName.text = data.server.name
                strongSelf.serverDetails.text = data.server.extendedInfo.desc
                self?.playerCount.text = "\(players.players.count) players"
                self?.players = players.players
                self?.tableView.reloadData()
                self?.refreshLayout()
                if let imageURL = data.server.imageURLFor(game: strongSelf.server.game) {
                    self?.imageView.kf.setImage(with: imageURL)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func refreshLayout() {
        let screenWidth = UIScreen.main.bounds.width
        let imageWidth = UIScreen.main.bounds.width - 32
        let otherHeights = imageWidth * 0.5 + 50 + serverName.bounds.height + serverDetails.bounds.height + 250
        let tableViewHeightValue = 50.0 * CGFloat(players.count)
        tableViewHeight.constant = tableViewHeightValue
        tableView.contentSize = CGSize(width: screenWidth, height: tableViewHeightValue)
        scrollView.contentSize = CGSize(width: screenWidth, height: tableViewHeightValue + otherHeights)
        view.layoutIfNeeded()
    }
}

extension ServerDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ServerDetailsTableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = players[indexPath.row].persona.personaName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}
