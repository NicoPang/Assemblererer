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
                    self.assembler.assemble()
                }
                else {
                    print("No program specified/excess parameters")
                }
            case "run" :
                if inputChunks.count == 1 {
                    self.assembler.setProgramName(inputChunks[0])
                    self.assembler.runProgram()
                }
                else {
                    print("No program specified/excess parameters")
                }
            case "path" :
                if inputChunks.count == 1 {
                    self.assembler.setPath(inputChunks[0])
                }
                else {
                    print("No path specified/excess parameters")
                }
            case "printlst" :
                if inputChunks.count == 1 {
                    self.assembler.setProgramName(inputChunks[0])
                    self.assembler.printListingFile()
                }
                else {
                    print("No program specified/excess parameters")
                }
            case "printbin" :
                if inputChunks.count == 1 {
                    self.assembler.setProgramName(inputChunks[0])
                    self.assembler.printBinaryFile()
                }
                else {
                    print("No program specified/excess parameters")
                }
            case "printsym" :
                if inputChunks.count == 1 {
                    self.assembler.setProgramName(inputChunks[0])
                    self.assembler.printLabelFile()
                }
                else {
                    print("No program specified/excess parameters")
                }
            case "quit" :
                running = false
            case "help" :
                printHelp()
            default :
                print("Invalid command")
            }
        }
    }
    private func printHelp() {
        print("\n")
        print("HELP MENU")
        print("\tasm <program name> - assemble the specified program")
        print("\trun <program name> - run the specified program")
        print("\tpath <path specification> - set the path for the SAP program directory\n\t\tinclude final / but not name of file. SAP file must have an extension of .txt")
        print("\tprintlst <program name> - print listing file for the specified program")
        print("\tprintbin <program name> - print binary file for the specified program")
        print("\tprintsym <program name> - print symbol table for the specified program")
        print("\tquit  - terminate SAP program")
        print("\thelp  - print help table")
        print("\n")
    }
}
