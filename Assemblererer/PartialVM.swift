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
    var symbols: [String: Int] = [:]
    var memory: [Int] = []
    var running = false
    var pointer = 0
    var compare = false
    
    func run() {
        self.running = true
        while self.running {
            self.executeInstruction()
        }
    }
    
    func executeInstruction() {
        guard self.pointer >= self.memory.count else {
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
        self.pointer += 1
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
        let registerValue = self.registers[self.pointer + 1]
        self.registers[self.pointer + 2] = registerValue
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
        let memoryLocation = self.memory[self.pointer + 1]
        self.registers[self.pointer + 2] = self.memory[memoryLocation]
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
        self.registers[self.pointer + 2] += self.memory[self.pointer + 1]
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
        let registerValue = self.registers[self.pointer + 1]
        self.registers[self.pointer + 2] += registerValue
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
        //incomplete, ID 45
    }
    func printi() {
        //incomplete, ID 49
    }
    func outs() {
        //incomplete, ID 55
    }
    func jmpne() {
        guard self.pointer + 1 < self.memory.count else {
            print("Not enough to complete function. Program terminated.")
            self.running = false
            return
        }
        if self.compare {
            self.pointer = self.memory[self.pointer + 1]
        }
        self.pointer += 2
    }
    
    func validRegister(_ r: Int) -> Bool {
        return r >= 0 && r <= 9
    }
}

