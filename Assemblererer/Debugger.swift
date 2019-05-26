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
        print("Sdb (\(self.pvm.getrPC()))> ", terminator: "")
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
        switch command {
        case "setbk" :
            setBreakPoint(at: vars[0])
        case "rmbk" :
            removeBreakPoint(at: vars[0])
        case "clrbk" :
            clearBreakPoints()
        case "disbk" :
            break
        case "enbk" :
            break
        case "pbk" :
            printBreakPoints()
        case "preg" :
            break
        case "wreg" :
            break
        case "wpc" :
            break
        case "pmem" :
            break
        case "deas" :
            break
        case "wmem" :
            break
        case "pst" :
            printLabelFile()
        case "g" :
            setStatusFlag(to: .G)
        case "s" :
            setStatusFlag(to: .S)
        case "exit" :
            setStatusFlag(to: .Exit)
        case "help" :
            printSdbCommands()
        //never going to be executed
        default : return
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
    func printSdbCommands() {
        print("    setbk <address>                      set breakpoint at <address>")
        print("    rmbk <address>                       remove breakpoint at <address>")
        print("    clrbk                                clear all breakpoints")
        print("    disbk                                disable breakpoints")
        print("    enbk                                 enable breakpoints")
        print("    pbk                                  print the breakpoints")
        print("    preg                                 print the registers")
        print("    wreg <register> <value>              write value <value> to register <register>")
        print("    wpc <value>                          write value <value> to the rPC")
        print("    pmem <start address> <end address>   print memory locations from <start address> to <end address>>")
        print("    deas <start address> <end address>   deassemble memory locations from <start address> to <end address>")
        print("    wmem <address> <value>               write value <value> at address <address>")
        print("    pst                                  print the symbol table")
        print("    g                                    continue program execution")
        print("    s                                    do a single step")
        print("    exit                                 terminate virtual machine")
        print("    help                                 print this help table (again)")
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
