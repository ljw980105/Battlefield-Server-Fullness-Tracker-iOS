//
//  BattlelogServer.swift
//  ServerFullnessChecker
//
//  Created by Jing Wei Li on 5/8/20.
//  Copyright © 2020 Jing Wei Li. All rights reserved.
//

import Foundation

struct BattlelogServer: Codable {
    let server: BattlelogServerDetails
}

struct BattlelogServerDetails: Codable {
    let map: String
    let gameId: String
    let gameExpansions: [Int]
    let mapMode: String
    let ip: String
    let matchId: String
    let protocolVersionString: String
    let extendedInfo: BattlelogExtendedInfo
    let game: Int
    let ranked: Int
    let online: Int
    let platform: Int
    let tickRateMax: Int
    // skipped slots
    let guid: String
    let port: Int
    let punkbuster: Int
    let name: String
    // skipped settings
    let country: String
}

struct BattlelogExtendedInfo: Codable {
    let message: String
    let bannerUrl: String
    let desc: String
}
