//
//  PartialVM.swift
//  Assemblererer
//
//  Created by Nick Pang on 3/27/19.
//  Copyright © 2019 Nick's Projects. All rights reserved.
//

import Foundation

class PartialVM {
    var registers: [Int] = Array<Int>(repeatElement(0, count: 10))
    var memory: [Int] = []
    var running = false
    var rPC = 0
    var rCP = false
    
    func inputMemory(_ memory: [Int]) {
        self.memory = memory
    }
    
    func run() {
        guard self.memory.count >= 3 else {
            print("Not enough memory to run.")
            return
        }
        self.rPC = self.memory[1] + 2
        self.running = true
        while self.running {
            self.executeInstruction()
        }
    }
    
    func executeInstruction() {
        guard self.rPC < self.memory.count else {
            print("No more functions found. Program terminated.")
            self.running = false
            return
        }
        switch self.memory[self.rPC] {
        case 0 :
            self.halt()
        case 6 :
            self.movrr()
        case 8 :
            self.movmr()
        case 12 :
            self.addir()
        case 13 :
            self.addrr()
        case 34 :
            self.cmprr()
        case 45 :
            self.outcr()
        case 49 :
            self.printi()
        case 55 :
            self.outs()
        case 57 :
            self.jmpne()
        default :
            print("\(self.memory[self.rPC]) is not a valid command.")
        }
    }
    
    //list of functions needed for partialVM
    func halt() {
        self.running = false
    }
    func movrr() {
        guard self.rPC + 2 < self.memory.count else {
            print("Not enough to complete function. Program terminated.")
            self.running = false
            return
        }
        guard validRegister(self.memory[self.rPC + 1]) && validRegister(self.memory[self.rPC + 2]) else {
            print("Invalid registers. Function could not be completed.")
            self.rPC += 3
            return
        }
        let registerValue = self.registers[self.memory[self.rPC + 1]]
        self.registers[self.memory[self.rPC + 2]] = registerValue
        self.rPC += 3
    }
    func movmr() {
        guard self.rPC + 2 < self.memory.count else {
            print("Not enough to complete function. Program terminated.")
            self.running = false
            return
        }
        guard validRegister(self.memory[self.rPC + 1]) && validRegister(self.memory[self.rPC + 2]) else {
            print("Invalid registers. Function could not be completed.")
            self.rPC += 3
            return
        }
        let memoryLocation = self.memory[self.rPC + 1] + 2
        self.registers[self.memory[self.rPC + 2]] = self.memory[memoryLocation]
        self.rPC += 3
    }
    func addir() {
        guard self.rPC + 2 < self.memory.count else {
            print("Not enough to complete function. Program terminated.")
            self.running = false
            return
        }
        guard validRegister(self.memory[self.rPC + 2]) else {
            print("Invalid registers. Function could not be completed.")
            self.rPC += 3
            return
        }
        self.registers[self.memory[self.rPC + 2]] += self.memory[self.rPC + 1]
        self.rPC += 3
    }
    func addrr() {
        guard self.rPC + 2 < self.memory.count else {
            print("Not enough to complete function. Program terminated.")
            self.running = false
            return
        }
        guard validRegister(self.memory[self.rPC + 1]) && validRegister(self.memory[self.rPC + 2]) else {
            print("Invalid registers. Function could not be completed.")
            self.rPC += 3
            return
        }
        let registerValue = self.registers[self.memory[self.rPC + 1]]
        self.registers[self.memory[self.rPC + 2]] += registerValue
        self.rPC += 3
    }
    func cmprr() {
        guard self.rPC + 2 < self.memory.count else {
            print("Not enough to complete function. Program terminated.")
            self.running = false
            return
        }
        guard validRegister(self.memory[self.rPC + 1]) && validRegister(self.memory[self.rPC + 2]) else {
            print("Invalid registers. Function could not be completed.")
            self.rPC += 3
            return
        }
        let r1value = self.registers[self.memory[self.rPC + 1]]
        let r2value = self.registers[self.memory[self.rPC + 2]]
        self.rCP = r1value == r2value
        self.rPC += 3
    }
    func outcr() {
        guard self.rPC + 1 < self.memory.count else {
            print("Not enough to complete function. Program terminated.")
            self.running = false
            return
        }
        guard validRegister(self.memory[self.rPC + 1]) else {
            print("Invalid register. Function could not be completed.")
            self.rPC += 2
            return
        }
        print(unicodeValueToCharacter(self.registers[self.memory[self.rPC + 1]]), terminator: "")
        self.rPC += 2
    }
    func printi() {
        guard self.rPC + 1 < self.memory.count else {
            print("Not enough to complete function. Program terminated.")
            self.running = false
            return
        }
        guard validRegister(self.memory[self.rPC + 1]) else {
            print("Invalid register. Function could not be completed.")
            self.rPC += 2
            return
        }
        print(self.registers[self.memory[self.rPC + 1]], terminator: "")
        self.rPC += 2
    }
    func outs() {
        guard self.rPC + 1 < self.memory.count else {
            print("Not enough to complete function. Program terminated.")
            self.running = false
            return
        }
        let memoryLocation = self.memory[self.rPC + 1] + 2
        guard validMemoryLocation(memoryLocation) else {
            print("Invalid memory location \(memoryLocation). String could not be printed.")
            self.rPC += 2
            return
        }
        print(makeString(memoryLocation: memoryLocation), terminator: "")
        self.rPC += 2
    }
    func jmpne() {
        guard self.rPC + 1 < self.memory.count else {
            print("Not enough to complete function. Program terminated.")
            self.running = false
            return
        }
        let memoryLocation = self.memory[self.rPC + 1] + 2
        guard validMemoryLocation(memoryLocation) else {
            print("Invalid memory location \(memoryLocation). Jump could not be completed.")
            self.rPC += 2
            return
        }
        if self.rCP {
            self.rPC += 2
            return
        }
        self.rPC = memoryLocation
    }
    
    func validRegister(_ r: Int) -> Bool {
        return r >= 0 && r <= 9
    }
    
    func validMemoryLocation(_ m: Int) -> Bool {
        return m >= 2 && m < self.memory.count
    }
    func makeString(memoryLocation: Int) -> String {
        var returnString = ""
        for e in (memoryLocation + 1)...(memoryLocation + self.memory[memoryLocation]) {
            returnString += String(unicodeValueToCharacter(self.memory[e]))
        }
        return returnString
    }
}

