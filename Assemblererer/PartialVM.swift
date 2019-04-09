//
//  PartialVM.swift
//  Assemblererer
//
//  Created by Nick Pang on 3/27/19.
//  Copyright © 2019 Nick's Projects. All rights reserved.
//


//Illegal register
//Illegal memory address
//Illegal instruction
//Divide by zero
//Stack overflow
//Bad stack operation
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
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.registers[vars[0]] = 0
        self.rPC += 1
    }
    func clrx() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.memory[vars[0]] = 0
        self.rPC += 1
    }
    func clrm() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.memory[vars[0]] = 0
        self.rPC += 1
    }
    func clrb() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        for m in vars[0]..<(vars[0] + vars[1]) {
            self.memory[m] = 0
        }
        self.rPC += 1
    }
    func movir() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.registers[vars[1]] = self.memory[vars[0]]
        self.rPC += 1
    }
    func movrr() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.registers[vars[1]] = self.registers[vars[0]]
        self.rPC += 1
    }
    func movrm() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.memory[vars[1]] = self.registers[vars[0]]
        self.rPC += 1
    }
    func movmr() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.registers[vars[1]] = self.memory[vars[0]]
        self.rPC += 1
    }
    func movxr() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.registers[vars[1]] = self.memory[vars[0]]
        self.rPC += 1
    }
    func movar() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.registers[vars[1]] = vars[0]
        self.rPC += 1
    }
    func movb() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        for m in 0..<(vars[2]) {
            self.memory[vars[1] + m] = self.memory[vars[0] + m]
        }
        self.rPC += 1
    }
    func addir() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.registers[vars[1]] += vars[0]
        self.rPC += 1
    }
    func addrr() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.registers[vars[1]] += self.registers[vars[0]]
        self.rPC += 1
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
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.rCP = self.registers[vars[1]] == self.registers[vars[0]]
        self.rPC += 1
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
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        print(unicodeValueToCharacter(vars[0]), terminator: "")
        self.rPC += 1
    }
    func outcr() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        print(unicodeValueToCharacter(self.registers[vars[0]]), terminator: "")
        self.rPC += 1
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
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        print(self.registers[vars[0]], terminator: "")
        self.rPC += 1
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
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        print(makeString(memoryLocation: vars[0]), terminator: "")
        self.rPC += 1
    }
    func nop () {
        //incomplete
    }
    func jmpne() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        if self.rCP {
            self.rPC += 1
            return
        }
        self.rPC = vars[0]
    }
    
    //true for no errors
    //function will return the exact values needed
    func processErrorsAndVariables() -> [Int]? {
        var processedVariables: [Int] = []
        
        let commandID = self.memory[self.rPC]
        let command = Command(rawValue: commandID)!
        let parameters = commands[command]!
        
        guard validMemoryLocation(self.rPC + parameters.count) else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
            return nil
        }
        
        for parameter in parameters {
            self.rPC += 1
            var tempVar: Int?
            switch parameter {
            case "r" :
                tempVar = processRegister(self.rPC)
            case "x" :
                tempVar = processMemoryLocationInRegister(self.rPC)
            case "m" :
                tempVar = processMemoryLocation(self.rPC)
            case "b" :
                tempVar = processCount(self.rPC, memoryLocations: processedVariables)
            default :
                tempVar = processInteger(self.rPC)
            }
            if tempVar == nil {
                return nil
            } else {
                processedVariables.append(tempVar!)
            }
        }
        return processedVariables
    }
    //returns the integer
    func processInteger(_ location: Int) -> Int {
        return self.memory[location]
    }
    //returns register number
    func processRegister(_ location: Int) -> Int? {
        let r = self.memory[location]
        if validRegister(r) {
            return r
        }
        print("Invalid register \(r) specified in memory location \(location). Program terminated.")
        return nil
    }
    //returns memory location in register
    func processMemoryLocationInRegister(_ location: Int) -> Int? {
        guard let r = processRegister(location) else {
            return nil
        }
        let m = self.registers[r]
        if validMemoryLocation(m) {
            return m
        }
        print("Invalid memory location \(m) specified in register \(r). Program termianted.")
        return nil
    }
    //returns memory location
    func processMemoryLocation(_ location: Int) -> Int? {
        let m = self.memory[location]
        if validMemoryLocation(m) {
            return m
        }
        print("Invalid memory location \(m) specified in memory location \(location). Program termianted.")
        return nil
    }
    //returns count
    func processCount(_ location: Int, memoryLocations: [Int]) -> Int? {
        let count = self.memory[location]
        for memoryLocation in memoryLocations {
            let newMemoryLocation = memoryLocation + count
            if !validMemoryLocation(memoryLocation + count) {
                print("Invalid memory location \(self.memorySize). Program terminated.")
                return nil
            }
        }
        if count < 1 {
            print("Count cannot be \(count). Program terminated.")
            return nil
        }
        return count
    }
    
    func validRegister(_ r: Int) -> Bool {
        return r >= 0 && r <= 9
    }
    
    func validMemoryLocation(_ m: Int) -> Bool {
        return m >= 0 && m < self.memorySize
    }
    
    func makeString(memoryLocation: Int) -> String {
        var returnString = ""
        for e in (memoryLocation + 1)...(memoryLocation + self.memory[memoryLocation]) {
            returnString += String(unicodeValueToCharacter(self.memory[e]))
        }
        return returnString
    }
}

