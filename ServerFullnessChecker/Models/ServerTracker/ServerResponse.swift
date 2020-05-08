//
//  ServerResponse.swift
//  ServerFullnessChecker
//
//  Created by Jing Wei Li on 5/1/20.
//  Copyright © 2020 Jing Wei Li. All rights reserved.
//

import Foundation

struct ServerResponse: Codable {
    let success: Bool
    let message: String
}
