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
        case 1 :
            self.clrr()
        case 2 :
            self.clrx()
        case 3 :
            self.clrm()
        case 4 :
            self.clrb()
        case 5 :
            self.movir()
        case 6 :
            self.movrr()
        case 7 :
            self.movrm()
        case 8 :
            self.movmr()
        case 9 :
            self.movxr()
        case 10 :
            self.movar()
        case 11 :
            self.movb()
        case 12 :
            self.addir()
        case 13 :
            self.addrr()
        case 14 :
            self.addmr()
        case 15 :
            self.addxr()
        case 16 :
            self.subir()
        case 17 :
            self.subrr()
        case 18 :
            self.submr()
        case 19 :
            self.subxr()
        case 20 :
            self.mulir()
        case 21 :
            self.mulrr()
        case 22 :
            self.mulmr()
        case 23 :
            self.mulxr()
        case 24 :
            self.divir()
        case 25 :
            self.divrr()
        case 26 :
            self.divmr()
        case 27 :
            self.divxr()
        case 28 :
            self.jmp()
        case 29 :
            self.sojz()
        case 30 :
            self.sojnz()
        case 31 :
            self.aojz()
        case 32 :
            self.aojnz()
        case 33 :
            self.cmpir()
        case 34 :
            self.cmprr()
        case 35 :
            self.cmpmr()
        case 36 :
            self.jmpn()
        case 37 :
            self.jmpz()
        case 38 :
            self.jmpp()
        case 39 :
            self.jsr()
        case 40 :
            self.ret()
        case 41 :
            self.push()
        case 42 :
            self.pop()
        case 43 :
            self.stackc()
        case 44 :
            self.outci()
        case 45 :
            self.outcr()
        case 46 :
            self.outcx()
        case 47 :
            self.outcb()
        case 48 :
            self.readi()
        case 49 :
            self.printi()
        case 50 :
            self.readc()
        case 51 :
            self.readln()
        case 52 :
            self.brk()
        case 53 :
            self.movrx()
        case 54 :
            self.movxx()
        case 55 :
            self.outs()
        case 56 :
            self.nop()
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
    func clrr() {
        guard self.rPC + 1 < self.memory.count else {
            print("Not enough to complete function. Program terminated.")
            self.running = false
            return
        }
        guard validRegister(self.memory[self.rPC + 1])  else {
            print("Invalid registers. Function could not be completed.")
            self.rPC += 3
            return
        }
        self.registers[self.memory[self.rPC + 1 + 2]] = 0
    }
    func clrx() {
        //incomplete
    }
    func clrm() {
        //incomplete
    }
    func clrb() {
        //incomplete
    }
    func movir() {
        //incomplete
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
    func movrm() {
        //incomplete
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
    func movxr() {
        //incomplete
    }
    func movar() {
        //incomplete
    }
    func movb() {
        //incomplete
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
    func addmr() {
        //incomplete
    }
    func addxr() {
        //incomplete
    }
    func subir() {
        //incomplete
    }
    func subrr() {
        //incomplete
    }
    func submr() {
        //incomplete
    }
    func subxr() {
        //incomplete
    }
    func mulir() {
        //incomplete
    }
    func mulrr() {
        //incomplete
    }
    func mulmr() {
        //incomplete
    }
    func mulxr() {
        //incomplete
    }
    func divir() {
        //incomplete
    }
    func divrr() {
        //incomplete
    }
    func divmr() {
        //incomplete
    }
    func divxr() {
        //incomplete
    }
    func jmp() {
        //incomplete
    }
    func sojz() {
        //incomplete
    }
    func sojnz() {
        //incomplete
    }
    func aojz() {
        //incomplete
    }
    func aojnz() {
        //incomplete
    }
    func cmpir() {
        //incomplete
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
    func cmpmr() {
        //incomplete
    }
    func jmpn() {
        //incomplete
    }
    func jmpz() {
        //incomplete
    }
    func jmpp() {
        //incomplete
    }
    func jsr() {
        //incomplete
    }
    func ret() {
        //incomplete
    }
    func push() {
        //incomplete
    }
    func pop() {
        //incomplete
    }
    func stackc() {
        //incomplete
    }
    func outci() {
        //incomplete
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
    func outcx() {
        //incomplete
    }
    func outcb() {
        //incomplete
    }
    func readi() {
        //incomplete
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
    func readc() {
        //incomplete
    }
    func readln() {
        //incomplete
    }
    func brk() {
        //incomplete
    }
    func movrx() {
        //incomplete
    }
    func movxx() {
        //incomplete
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
    func nop () {
        //incomplete
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

