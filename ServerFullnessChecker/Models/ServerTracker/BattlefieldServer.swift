//
//  BattlefieldServer.swift
//  ServerFullnessChecker
//
//  Created by Jing Wei Li on 5/1/20.
//  Copyright © 2020 Jing Wei Li. All rights reserved.
//

import Foundation

struct BattlefieldServer: Codable {
    let id: String
    let name: String
    let game: String // bf3 or bf4
}
