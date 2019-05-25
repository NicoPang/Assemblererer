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
        print("Sdb (\(self.pvm.rPC))> ", terminator: "")
        let input = readLine()!
        var inputChunks = splitStringIntoParts(input)
        let command = inputChunks.removeFirst()
        guard let parameters = getVarsforSdbCommand[command] else {
            print("Invalid command")
            return
        }
        guard let vars = checkSdbParameters(vars: parameters, input: inputChunks) else {
            print("Invalid parameters for command \(command)")
            return
        }
    }
    func checkSdbParameters(vars: String, inputVars: [String]) -> [Int]? {
        var vars = vars
        guard vars.count == inputVars.count else {
            self.listingFile += "----------Illegal parameters for \(token.type) \(token.type == .Directive ? String(describing: token.directive!) : String(describing: Command(rawValue: token.intValue!)!))\n"
            return false
        }
        for v in vars {
            let tokenz = tokens.removeFirst()
            switch (v, tokenz.type) {
            case ("i", .ImmediateInteger) : break
            case ("r", .Register) : break
            case ("x", .Register) : break
            case ("m", .Label) : addLabelFirstPass(tokenz.stringValue!)
            case ("b", .ImmediateInteger) : break
            case ("s", .ImmediateString) : break
            case ("t", .ImmediateTuple) : break
            default : return false
            }
        }
        return true
    }
}
//a = address
//r = register
//i = any integer
//m = memory location (int)
let getVarsforSdbCommand = [
    "setbk" : "a",
    "rmbk" : "a",
    "clrbk" : "",
    "disbk" : "",
    "enbk" : "",
    "pbk" : "",
    "preg" : "",
    "wreg" : "ri",
    "wpc" : "m",
    "pmem" : "aa",
    "deas" : "aa",
    "wmem" : "ai",
    "pst" : "",
    "s" : "",
    "g" : "",
    "exit" : "",
    "help" : ""
]
