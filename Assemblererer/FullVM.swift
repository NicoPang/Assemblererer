//
//  FullVM.swift
//  Assemblererer
//
//  Created by Nick Pang on 3/27/19.
//  Copyright © 2019 Nick's Projects. All rights reserved.
//

import Foundation

class FullVM {
    var registers: [Int] = Array<Int>(repeatElement(0, count: 10))
    var memory: [Int] = []
    var running = false
    var pointer = 0
    var compare = false
    
    func inputMemory(_ memory: [Int]) {
        self.memory = memory
    }
    
    func run() {
        guard self.memory.count >= 3 else {
            print("Not enough memory to run.")
            return
        }
        self.pointer = self.memory[1] + 2
        self.running = true
        while self.running {
            self.executeInstruction()
        }
    }
    
    func executeInstruction() {
        guard self.pointer < self.memory.count else {
            print("No more functions found. Program terminated.")
            self.running = false
            return
        }
        switch self.memory[self.pointer] {
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
            print("\(self.memory[self.pointer]) is not a valid command.")
        }
    }
    
    //list of functions needed for partialVM
    func halt() {
        self.running = false
    }
    func movrr() {
        guard self.pointer + 2 < self.memory.count else {
            print("Not enough to complete function. Program terminated.")
            self.running = false
            return
        }
        guard validRegister(self.memory[self.pointer + 1]) && validRegister(self.memory[self.pointer + 2]) else {
            print("Invalid registers. Function could not be completed.")
            self.pointer += 3
            return
        }
        let registerValue = self.registers[self.memory[self.pointer + 1]]
        self.registers[self.memory[self.pointer + 2]] = registerValue
        self.pointer += 3
    }
    func movmr() {
        guard self.pointer + 2 < self.memory.count else {
            print("Not enough to complete function. Program terminated.")
            self.running = false
            return
        }
        guard validRegister(self.memory[self.pointer + 1]) && validRegister(self.memory[self.pointer + 2]) else {
            print("Invalid registers. Function could not be completed.")
            self.pointer += 3
            return
        }
        let memoryLocation = self.memory[self.pointer + 1] + 2
        self.registers[self.memory[self.pointer + 2]] = self.memory[memoryLocation]
        self.pointer += 3
    }
    func addir() {
        guard self.pointer + 2 < self.memory.count else {
            print("Not enough to complete function. Program terminated.")
            self.running = false
            return
        }
        guard validRegister(self.memory[self.pointer + 2]) else {
            print("Invalid registers. Function could not be completed.")
            self.pointer += 3
            return
        }
        self.registers[self.memory[self.pointer + 2]] += self.memory[self.pointer + 1]
        self.pointer += 3
    }
    func addrr() {
        guard self.pointer + 2 < self.memory.count else {
            print("Not enough to complete function. Program terminated.")
            self.running = false
            return
        }
        guard validRegister(self.memory[self.pointer + 1]) && validRegister(self.memory[self.pointer + 2]) else {
            print("Invalid registers. Function could not be completed.")
            self.pointer += 3
            return
        }
        let registerValue = self.registers[self.memory[self.pointer + 1]]
        self.registers[self.memory[self.pointer + 2]] += registerValue
        self.pointer += 3
    }
    func cmprr() {
        guard self.pointer + 2 < self.memory.count else {
            print("Not enough to complete function. Program terminated.")
            self.running = false
            return
        }
        guard validRegister(self.memory[self.pointer + 1]) && validRegister(self.memory[self.pointer + 2]) else {
            print("Invalid registers. Function could not be completed.")
            self.pointer += 3
            return
        }
        let r1value = self.registers[self.memory[self.pointer + 1]]
        let r2value = self.registers[self.memory[self.pointer + 2]]
        self.compare = r1value == r2value
        self.pointer += 3
    }
    func outcr() {
        guard self.pointer + 1 < self.memory.count else {
            print("Not enough to complete function. Program terminated.")
            self.running = false
            return
        }
        guard validRegister(self.memory[self.pointer + 1]) else {
            print("Invalid register. Function could not be completed.")
            self.pointer += 2
            return
        }
        print(unicodeValueToCharacter(self.registers[self.memory[self.pointer + 1]]), terminator: "")
        self.pointer += 2
    }
    func printi() {
        guard self.pointer + 1 < self.memory.count else {
            print("Not enough to complete function. Program terminated.")
            self.running = false
            return
        }
        guard validRegister(self.memory[self.pointer + 1]) else {
            print("Invalid register. Function could not be completed.")
            self.pointer += 2
            return
        }
        print(self.registers[self.memory[self.pointer + 1]], terminator: "")
        self.pointer += 2
    }
    func outs() {
        guard self.pointer + 1 < self.memory.count else {
            print("Not enough to complete function. Program terminated.")
            self.running = false
            return
        }
        let memoryLocation = self.memory[self.pointer + 1] + 2
        guard validMemoryLocation(memoryLocation) else {
            print("Invalid memory location \(memoryLocation). String could not be printed.")
            self.pointer += 2
            return
        }
        print(makeString(memoryLocation: memoryLocation), terminator: "")
        self.pointer += 2
    }
    func jmpne() {
        guard self.pointer + 1 < self.memory.count else {
            print("Not enough to complete function. Program terminated.")
            self.running = false
            return
        }
        let memoryLocation = self.memory[self.pointer + 1] + 2
        guard validMemoryLocation(memoryLocation) else {
            print("Invalid memory location \(memoryLocation). Jump could not be completed.")
            self.pointer += 2
            return
        }
        if self.compare {
            self.pointer += 2
            return
        }
        self.pointer = memoryLocation
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

