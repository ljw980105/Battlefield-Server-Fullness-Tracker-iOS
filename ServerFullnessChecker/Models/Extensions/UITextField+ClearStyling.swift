//
//  UITextField+ClearStyling.swift
//  ServerFullnessChecker
//
//  Created by Jing Wei Li on 5/1/20.
//  Copyright © 2020 Jing Wei Li. All rights reserved.
//

import UIKit

extension UITextField {

    func clearStyling() {
        borderStyle = .none
        if #available(iOS 13.0, *) {
            layer.backgroundColor = UIColor.systemBackground.cgColor
        } else {
            layer.backgroundColor = UIColor.white.cgColor
        }
    }
}
