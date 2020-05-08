//
//  MutedResponse.swift
//  ServerFullnessChecker
//
//  Created by Jing Wei Li on 5/3/20.
//  Copyright © 2020 Jing Wei Li. All rights reserved.
//

import Foundation

struct MutedResponse: Codable {
    let muted: Bool
    let message: String
}
