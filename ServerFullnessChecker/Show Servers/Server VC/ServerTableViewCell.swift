//
//  ServerTableViewCell.swift
//  ServerFullnessChecker
//
//  Created by Jing Wei Li on 5/3/20.
//  Copyright © 2020 Jing Wei Li. All rights reserved.
//

import UIKit

class ServerTableViewCell: UITableViewCell {
    static let identifier = "serversCell"
    
    func setupWithServer(_ server: BattlefieldServer) {
        textLabel?.text = server.name
        detailTextLabel?.text = server.game
        imageView?.image = Game(rawValue: server.game)?.image()
        
    }
    
}
