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
        var debugging = true
        while debugging {
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
                self.breakPointsEnabled = false
            case "enbk" :
                self.breakPointsEnabled = true
            case "pbk" :
                printBreakPoints()
            case "preg" :
                printRegisters()
            case "wreg" :
                writeToRegister(vars[0], value: vars[1])
            case "wpc" :
                writeTorPC(value: vars[0])
            case "pmem" :
                printMemoryRange(start: vars[0], end: vars[1])
            case "deas" :
                break
            case "wmem" :
                writeToMemory(location: vars[0], value: vars[1])
            case "pst" :
                printLabelFile()
            case "g" :
                setStatusFlag(to: .G)
                debugging = false
            case "s" :
                setStatusFlag(to: .S)
                debugging = false
            case "exit" :
                setStatusFlag(to: .Exit)
                debugging = false
            case "help" :
                printSdbCommands()
            //never going to be executed
            default : return
            }
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
        print("\n")
        print("----<address> refers to either a label or a memory location")
    }
    func writeToMemory(location: Int, value: Int) {
        self.pvm.changeMemoryValue(at: location, to: value)
    }
    func writeTorPC(value: Int) {
        self.pvm.setrPC(to: value)
    }
    func printRegisters() {
        for register in 0...9 {
            print("    r\(register): \(self.pvm.getRegisterValue(at: register))")
        }
    }
    func writeToRegister(_ register: Int, value: Int) {
        self.pvm.setRegister(register, to: value)
    }
    func printMemoryRange(start: Int, end: Int) {
        guard start <= end else {
            print("Invalid range")
            return
        }
        self.pvm.printMemoryRangeFrom(start, to: end)
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
