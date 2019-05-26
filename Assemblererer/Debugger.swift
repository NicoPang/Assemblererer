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
        guard let vars = checkSdbParameters(parameters: parameters, inputVars: inputChunks) else {
            print("Invalid parameters for command \(command)")
            return
        }
    }
    func checkSdbParameters(parameters: String, inputVars: [String]) -> [Int]? {
        let parameters = parameters
        var inputVars = inputVars
        var outputVars: [Int] = []
        guard parameters.count == inputVars.count else {
            return nil
        }
        for p in parameters {
            let inputVar = inputVars.removeFirst()
            switch (p) {
            case "i" :
                guard let integer = Int(inputVar) else {
                    return nil
                }
                outputVars.append(integer)
            case "r" :
                if !isValidRegister(inputVar) {
                    return nil
                }
                outputVars.append(Int(inputVar)!)
            case "m" :
                if !isValidMemoryLocation(inputVar) {
                    return nil
                }
                outputVars.append(Int(inputVar)!)
            case "a" :
                if !isValidAddress(inputVar) {
                    return nil
                }
                outputVars.append(parseAddress(inputVar))
            default : return nil
            }
        }
        return outputVars
    }
    func isValidRegister(_ r: String) -> Bool {
        guard let r = Int(r) else {
            return false
        }
        return self.pvm.validRegister(r)
    }
    func isValidMemoryLocation(_ l: String) -> Bool {
        guard let l = Int(l) else {
            return false
        }
        return self.pvm.validMemoryLocation(l)
    }
    func isValidAddress(_ a: String) -> Bool {
        return isValidMemoryLocation(a) || isValidLabel(a)
    }
    func isValidLabel(_ l: String) -> Bool {
        return self.symbolTable[l] != nil
    }
    func parseAddress(_ a: String) -> Int {
        if let integer = Int(a) {
            return integer
        }
        return self.symbolTable[a]!!
    }
}
//a = address
//r = register
//i = any integer
//m = memory location as an integer
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
