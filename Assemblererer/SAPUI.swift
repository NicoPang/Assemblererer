//
//  SAPUI.swift
//  Assemblererer
//
//  Created by Nick Pang on 4/22/19.
//  Copyright © 2019 Nick's Projects. All rights reserved.
//

import Foundation

class SAPUI {
    var assembler = Assembler()
    func run() {
        var running = true
        while running {
            print("Enter option...", terminator: "")
            let input = readLine()!
            var inputChunks = splitStringIntoParts(input)
            let command = inputChunks.removeFirst()
            switch command {
            case "asm" :
                if inputChunks.count == 1 {
                    self.assembler.setProgramName(inputChunks[0])
                }
            case "run" :
                if inputChunks.count == 1 {
                    self.assembler.setProgramName(inputChunks[0])
                }
                //finish
            case "path" :
                if inputChunks.count == 1 {
                    self.assembler.setPath(inputChunks[0])
                }
            case "printlst" :
                break
            case "printbin" :
                break
            case "printsym" :
                break
            case "quit" :
                running = false
            case "help" :
                break
            default :
                print("Invalid command")
            }
        }
    }
}
