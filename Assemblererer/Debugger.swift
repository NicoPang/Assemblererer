//
//  Debugger.swift
//  Assemblererer
//
//  Created by Nick Pang on 5/20/19.
//  Copyright © 2019 Nick's Projects. All rights reserved.
//

import Foundation

enum StatusFlag {
    case S, G, Exit
}
 

extension Assembler {
    func debug() {
        print("Sdb (\(self.pvm.rPC))")
    }
}
