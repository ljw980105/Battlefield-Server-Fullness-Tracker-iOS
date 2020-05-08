//
//  Game.swift
//  ServerFullnessChecker
//
//  Created by Jing Wei Li on 5/3/20.
//  Copyright © 2020 Jing Wei Li. All rights reserved.
//

import UIKit

enum Game: String {
    case bf3 = "bf3"
    case bf4 = "bf4"
    
    func image() -> UIImage? {
        switch self {
        case .bf3:
            return UIImage(named: "bf3")
        case .bf4:
            return UIImage(named: "bf4")
        }
    }
}
