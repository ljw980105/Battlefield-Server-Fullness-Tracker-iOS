//
//  BattlelogPlayer.swift
//  ServerFullnessChecker
//
//  Created by Jing Wei Li on 5/8/20.
//  Copyright © 2020 Jing Wei Li. All rights reserved.
//

import Foundation

struct BattlelogPlayer: Codable {
    let players: [BattlelogPlayerDetail]
}

struct BattlelogPlayerDetail: Codable {
    let persona: BattlelogPlayerPersona
    let guid: String
}

struct BattlelogPlayerPersona: Codable {
    let personaName: String
    let clanTag: String
}
