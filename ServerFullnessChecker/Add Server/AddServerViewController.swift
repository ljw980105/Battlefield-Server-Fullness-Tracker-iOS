//
//  AddServerViewController.swift
//  ServerFullnessChecker
//
//  Created by Jing Wei Li on 5/1/20.
//  Copyright © 2020 Jing Wei Li. All rights reserved.
//

import UIKit
import Combine

class AddServerViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var selectGameButton: UIButton!
    var selectedGame: String = ""
    var disposeBag: [AnyCancellable] = []
    
    init() {
        super.init(nibName: "AddServerViewController", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Server"
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissAddServer))
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addServer))
        
        idTextField.clearStyling()
        nameTextField.clearStyling()
    }
    
    @objc func dismissAddServer() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addServer() {
        if let id = idTextField.text, let name = nameTextField.text, selectedGame != "" {
            let server = BattlefieldServer(id: id, name: name, game: selectedGame)
            ServerTrackerAPI
                .serverExistsForId(server)
                .filter { !$0.success }
                .flatMap { _ in ServerTrackerAPI.addServerWithId(server) }
                .sink(receiveCompletion: { _ in }) { [weak self] _ in
                    self?.dismissAddServer()
                }
                .store(in: &disposeBag)
        }
    }

    @IBAction func selectGame(_ sender: UIButton) {
        let pickerView = GenericPickerViewController<AddServerViewController>(pickerViewData: ["bf3", "bf4"], title: "Pick Game", startIndex: 0)
        pickerView.delegate = self
        present(pickerView, animated: true, completion: nil)
    }
}

extension AddServerViewController: GenericPickerViewDelegate {
    typealias SelectedValueType = String
    
    func convertStringToCustomType(from string: String) -> String {
        return string
    }
    
    func didCompleteWithSelection(selection: String, at index: Int) {
        selectGameButton.setTitle(selection, for: .normal)
        selectedGame = selection
    }
    
    func didCancelSelection() {
        
    }
    
}
