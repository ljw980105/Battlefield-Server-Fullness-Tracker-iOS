//
//  Combine+DisposeBag.swift
//  ServerFullnessChecker
//
//  Created by Jing Wei Li on 5/8/20.
//  Copyright © 2020 Jing Wei Li. All rights reserved.
//

import Foundation
import Combine

extension AnyCancellable {
    func disposed(by disposeBag: CombineDisposeBag) {
        store(in: &disposeBag.bags)
    }
}

class CombineDisposeBag {
    var bags: [AnyCancellable]
    
    init() {
        bags = []
    }
}
