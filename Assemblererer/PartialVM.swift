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
    var memorySize = 0
    var start = 0
    
    func inputBinary(_ binary: [Int]) {
        guard binary.count > 3 else {
            print("No memory found.")
            return
        }
        self.memorySize = binary[0]
        self.start = binary[1]
        self.memory = Array(binary[2...])
    }
    
    func inputBinaryFromFile(path: String) {
        do {
            let contents = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            try inputBinary(splitBinaryFile(contents))
            
        }
        catch {
            print("File unreadable. Please try a different file.")
        }
    }
    
    func run() {
        guard self.memorySize > 0 else {
            print("No memory found.")
            return
        }
        self.rPC = self.start
        self.running = true
        while self.running {
            self.executeInstruction()
        }
    }
    
    func executeInstruction() {
        guard self.rPC < self.memorySize else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
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
            print("Invalid command at \(self.rPC). Program terminated.")
            self.running = false
        }
    }
    //list of functions needed for partialVM
    func halt() {
        self.running = false
    }
    func clrr() {
        guard self.rPC + 1 < self.memorySize else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
            self.running = false
            return
        }
        let register = self.memory[self.rPC + 1]
        guard validRegister(register)  else {
            print("Invalid register specified at \(self.rPC + 1). Program terminated.")
            self.running = false
            return
        }
        
        self.registers[register] = 0
        self.rPC += 2
    }
    func clrx() {
        guard self.rPC + 1 < self.memorySize else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
            self.running = false
            return
        }
        let register = self.memory[self.rPC + 1]
        guard validRegister(register)  else {
            print("Invalid register specified at \(self.rPC + 1). Program terminated.")
            self.running = false
            return
        }
        let memoryLocation = self.registers[register]
        guard validMemoryLocation(self.memory[memoryLocation]) else {
            print("Invalid memory location specified by register \(register). Program terminated.")
            self.running = false
            return
        }
        
        self.memory[memoryLocation] = 0
        self.rPC += 2
    }
    func clrm() {
        guard self.rPC + 1 < self.memorySize else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
            self.running = false
            return
        }
        let memoryLocation = self.memory[self.rPC + 1]
        guard validMemoryLocation(memoryLocation)  else {
            print("Invalid memory location specified at \(self.rPC + 1). Program terminated.")
            self.running = false
            return
        }
        
        self.memory[self.memory[memoryLocation]] = 0
        self.rPC += 2
    }
    func clrb() {
        guard self.rPC + 1 < self.memorySize else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
            self.running = false
            return
        }
        let memoryLocation = self.memory[self.rPC + 1]
        let count = self.memory[self.rPC + 2]
        guard count >= 0 else {
            print("Invalid count number specified at \(self.rPC + 2). Program terminated.")
            self.running = false
            return
        }
        if count == 0 {
            self.rPC += 3
            return
        }
        //A count of 1 would cause two blocks of memory to be erased without the - 1
        guard validMemoryLocation(memoryLocation) && validMemoryLocation(memoryLocation + count - 1)  else {
            print("Invalid block of memory (\(memoryLocation)...\(memoryLocation + count - 1)). Program terminated.")
            self.running = false
            return
        }
        
        for m in memoryLocation...(memoryLocation + count - 1) {
            self.memory[m] = 0
        }
        self.rPC += 3
    }
    func movir() {
        guard self.rPC + 2 < self.memorySize else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
            self.running = false
            return
        }
        let register = self.memory[self.rPC + 2]
        guard validRegister(register) else {
            print("Invalid register speficied at \(self.rPC + 2). Program terminated.")
            self.running = false
            return
        }
        
        self.registers[register] = self.memory[self.rPC + 1]
        self.rPC += 3
    }
    func movrr() {
        guard self.rPC + 2 < self.memorySize else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
            self.running = false
            return
        }
        let register1 = self.memory[self.rPC + 1]
        let register2 = self.memory[self.rPC + 2]
        guard validRegister(register1) else {
            print("Invalid register specified at \(self.rPC + 1). Program terminated.")
            self.running = false
            return
        }
        guard validRegister(register2) else {
            print("Invalid register specified at \(self.rPC + 2). Program terminated.")
            self.running = false
            return
        }
        
        self.registers[register2] = self.registers[register1]
        self.rPC += 3
    }
    func movrm() {
        guard self.rPC + 2 < self.memorySize else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
            self.running = false
            return
        }
        let register = self.memory[self.rPC + 1]
        let memoryLocation = self.memory[self.rPC + 2]
        guard validRegister(register) else {
            print("Invalid register specified at \(self.rPC + 1). Program terminated.")
            self.running = false
            return
        }
        guard validMemoryLocation(memoryLocation) else {
            print("Invalid memory location specified at \(self.rPC + 2). Program terminated.")
            self.running = false
            return
        }
        
        self.memory[memoryLocation] = self.registers[register]
        self.rPC += 3
    }
    func movmr() {
        guard self.rPC + 2 < self.memorySize else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
            self.running = false
            return
        }
        let memoryLocation = self.memory[self.rPC + 1]
        let register = self.memory[self.rPC + 2]
        guard validMemoryLocation(memoryLocation) else {
            print("Invalid memory location specified at \(self.rPC + 1). Program terminated.")
            self.running = false
            return
        }
        guard validRegister(register) else {
            print("Invalid register specified at \(self.rPC + 2). Program terminated.")
            self.running = false
            return
        }
        
        self.registers[self.memory[self.rPC + 2]] = self.memory[memoryLocation]
        self.rPC += 3
    }
    func movxr() {
        guard self.rPC + 2 < self.memorySize else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
            self.running = false
            return
        }
        let register1 = self.memory[self.rPC + 1]
        let register2 = self.memory[self.rPC + 2]
        guard validRegister(register1) else {
            print("Invalid register specified at \(self.rPC + 1). Program terminated.")
            self.running = false
            return
        }
        guard validRegister(register2) else {
            print("Invalid register specified at \(self.rPC + 2). Program terminated.")
            self.running = false
            return
        }
        let memoryLocation = self.registers[register1]
        guard validMemoryLocation(memoryLocation) else {
            print("Invalid memory location in register \(register1). Program terminated.")
            self.running = false
            return
        }
        
        self.registers[register2] = self.memory[memoryLocation]
        self.rPC += 3
    }
    func movar() {
        guard self.rPC + 2 < self.memorySize else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
            self.running = false
            return
        }
        let memoryLocation = self.memory[self.rPC + 1]
        let register = self.memory[self.rPC + 2]
        guard validMemoryLocation(memoryLocation) else {
            print("Invalid memory location specified at \(self.rPC + 1). Program terminated.")
            self.running = false
            return
        }
        guard validRegister(register) else {
            print("Invalid register specified at \(self.rPC + 2). Program terminated.")
            self.running = false
            return
        }
        
        self.registers[self.memory[self.rPC + 2]] = memoryLocation
        self.rPC += 3
    }
    func movb() {
        guard self.rPC + 3 < self.memorySize else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
            self.running = false
            return
        }
        let register1 = self.memory[self.rPC + 1]
        let register2 = self.memory[self.rPC + 2]
        let register3 = self.memory[self.rPC + 3]
        guard validRegister(register1) else {
            print("Invalid register specified at \(self.rPC + 1). Program terminated.")
            self.running = false
            return
        }
        guard validRegister(register2) else {
            print("Invalid register specified at \(self.rPC + 2). Program terminated.")
            self.running = false
            return
        }
        guard validRegister(register3) else {
            print("Invalid register specified at \(self.rPC + 3). Program terminated.")
            self.running = false
            return
        }
        let memoryLocation1 = self.registers[register1]
        let memoryLocation2 = self.registers[register2]
        let count = self.registers[register3]
        guard validMemoryLocation(memoryLocation1) else {
            print("Invalid memory location in register \(register1). Program terminated.")
            self.running = false
            return
        }
        guard validMemoryLocation(memoryLocation2) else {
            print("Invalid memory location in register \(register2). Program terminated.")
            self.running = false
            return
        }
        guard count >= 0 else {
            print("Invalid count number in register \(register3). Program terminated.")
            self.running = false
            return
        }
        if count == 0 {
            self.rPC += 4
            return
        }
        
        for m in 0...(count - 1) {
            self.memory[memoryLocation2 + m] = self.memory[memoryLocation1 + m]
        }
        self.rPC += 4
    }
    func addir() {
        guard self.rPC + 2 < self.memorySize else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
            self.running = false
            return
        }
        let register = self.memory[self.rPC + 2]
        guard validRegister(register) else {
            print("Invalid register specified at \(self.rPC + 2). Program terminated.")
            self.running = false
            return
        }
        
        self.registers[register] += self.memory[self.rPC + 1]
        self.rPC += 3
    }
    func addrr() {
        guard self.rPC + 2 < self.memorySize else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
            self.running = false
            return
        }
        let register1 = self.memory[self.rPC + 1]
        let register2 = self.memory[self.rPC + 2]
        guard validRegister(register1) else {
            print("Invalid register specified at \(self.rPC + 1). Program terminated.")
            self.running = false
            return
        }
        guard validRegister(register2) else {
            print("Invalid register specified at \(self.rPC + 2). Program terminated.")
            self.running = false
            return
        }
        
        self.registers[register2] += self.registers[register1]
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
        guard self.rPC + 2 < self.memorySize else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
            self.running = false
            return
        }
        let register1 = self.memory[self.rPC + 1]
        let register2 = self.memory[self.rPC + 2]
        guard validRegister(register1) else {
            print("Invalid register specified at \(self.rPC + 1). Program terminated.")
            self.running = false
            return
        }
        guard validRegister(register2) else {
            print("Invalid register specified at \(self.rPC + 2). Program terminated.")
            self.running = false
            return
        }
        
        self.rCP = self.registers[register1] == self.registers[register2]
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
        guard self.rPC + 1 < self.memorySize else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
            self.running = false
            return
        }
        let register = self.memory[self.rPC + 1]
        guard validRegister(register) else {
            print("Invalid register specified at \(self.rPC + 1). Program terminated.")
            self.running = false
            return
        }
        
        print(unicodeValueToCharacter(self.registers[register]), terminator: "")
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
        guard self.rPC + 1 < self.memorySize else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
            self.running = false
            return
        }
        let register = self.memory[self.rPC + 1]
        guard validRegister(register) else {
            print("Invalid register specified at \(self.rPC + 1). Program terminated.")
            self.running = false
            return
        }
        
        print(self.registers[register], terminator: "")
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
        guard self.rPC + 1 < self.memorySize else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
            self.running = false
            return
        }
        let memoryLocation = self.memory[self.rPC + 1]
        guard validMemoryLocation(memoryLocation) else {
            print("Invalid memory location spcified at \(self.rPC + 1). String could not be printed.")
            self.running = false
            return
        }
        
        print(makeString(memoryLocation: memoryLocation), terminator: "")
        self.rPC += 2
    }
    func nop () {
        //incomplete
    }
    func jmpne() {
        guard self.rPC + 1 < self.memorySize else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
            self.running = false
            return
        }
        let memoryLocation = self.memory[self.rPC + 1]
        guard validMemoryLocation(memoryLocation) else {
            print("Invalid memory location spcified at \(self.rPC + 1). String could not be printed.")
            self.running = false
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
        return m >= 2 && m < self.memorySize
    }
    func makeString(memoryLocation: Int) -> String {
        var returnString = ""
        for e in (memoryLocation + 1)...(memoryLocation + self.memory[memoryLocation]) {
            returnString += String(unicodeValueToCharacter(self.memory[e]))
        }
        return returnString
    }
}

