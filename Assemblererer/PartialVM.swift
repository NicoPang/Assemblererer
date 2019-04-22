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
    var rCP = 0
    var memorySize = 0
    var start = 0
    var stack = Stack<Int>(size: 10000, initial: 0)
    /////////////actual vm code
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
        case 2, 3 :
            self.clrm()
        case 4 :
            self.clrb()
        case 5 :
            self.movir()
        case 6 :
            self.movrr()
        case 7 :
            self.movrm()
        case 8, 9 :
            self.movmr()
        case 10 :
            self.movar()
        case 11 :
            self.movb()
        case 12 :
            self.addir()
        case 13 :
            self.addrr()
        case 14, 15 :
            self.addmr()
        case 16 :
            self.subir()
        case 17 :
            self.subrr()
        case 18, 19 :
            self.submr()
        case 20 :
            self.mulir()
        case 21 :
            self.mulrr()
        case 22, 23 :
            self.mulmr()
        case 24 :
            self.divir()
        case 25 :
            self.divrr()
        case 26, 27 :
            self.divmr()
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
        
        self.registers[vars[1]] = vars[0]
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
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.registers[vars[1]] += self.memory[vars[0]]
        self.rPC += 1
    }
    func subir() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.registers[vars[1]] -= vars[0]
        self.rPC += 1
    }
    func subrr() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.registers[vars[1]] -= self.registers[vars[0]]
        self.rPC += 1
    }
    func submr() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.registers[vars[1]] -= self.memory[vars[0]]
        self.rPC += 1
    }
    func mulir() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.registers[vars[1]] *= vars[0]
        self.rPC += 1
    }
    func mulrr() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.registers[vars[1]] *= self.registers[vars[0]]
        self.rPC += 1
    }
    func mulmr() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.registers[vars[1]] *= self.memory[vars[0]]
        self.rPC += 1
    }
    func divir() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        if vars[0] == 0 {
            print("Divide by 0 error. Program termianted.")
            self.running = false
            return
        }
        
        self.registers[vars[1]] /= vars[0]
        self.rPC += 1
    }
    func divrr() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        if self.registers[vars[0]] == 0 {
            print("Divide by 0 error. Program termianted.")
            self.running = false
            return
        }
        
        self.registers[vars[1]] /= self.registers[vars[0]]
        self.rPC += 1
    }
    func divmr() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        if self.memory[vars[0]] == 0 {
            print("Divide by 0 error. Program termianted.")
            self.running = false
            return
        }
        
        self.registers[vars[1]] /= self.memory[vars[0]]
        self.rPC += 1
    }
    func jmp() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.rPC = vars[0]
    }
    func sojz() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.registers[vars[0]] -= 1
        
        if self.registers[vars[0]] == 0 {
            self.rPC = vars[1]
            return
        }
        self.rPC += 1
    }
    func sojnz() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.registers[vars[0]] -= 1
        
        if self.registers[vars[0]] != 0 {
            self.rPC = vars[1]
            return
        }
        self.rPC += 1
    }
    func aojz() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.registers[vars[0]] += 1
        
        if self.registers[vars[0]] == 0 {
            self.rPC = vars[1]
            return
        }
        self.rPC += 1
    }
    func aojnz() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.registers[vars[0]] += 1
        
        if self.registers[vars[0]] != 0 {
            self.rPC = vars[1]
            return
        }
        self.rPC += 1
    }
    func cmpir() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.rCP = vars[0] - self.registers[vars[1]]
        self.rPC += 1
    }
    func cmprr() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.rCP = self.registers[vars[0]] - self.registers[vars[1]]
        self.rPC += 1
    }
    func cmpmr() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.rCP = self.memory[vars[0]] - self.registers[vars[1]]
        self.rPC += 1
    }
    func jmpn() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        if self.rCP < 0 {
            self.rPC += 1
            return
        }
        self.rPC = vars[0]
    }
    func jmpz() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        if self.rCP == 0 {
            self.rPC += 1
            return
        }
        self.rPC = vars[0]
    }
    func jmpp() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        if self.rCP > 0 {
            self.rPC += 1
            return
        }
        self.rPC = vars[0]
    }
    func jsr() {
        self.stack.push(element: self.rPC)
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        for i in 5...9 {
            guard getStackCondition() != 1 else {
                print("Stack is full. Program terminated.")
                self.running = false
                return
            }
            self.stack.push(element: self.registers[i])
        }
        self.rPC = vars[0]
    }
    func ret() {
        var count = 0
        for i in 5...9 {
            guard getStackCondition() != 2 else {
                print("Stack is empty. Program terminated.")
                self.running = false
                return
            }
            //they go in from 9 to 5
            self.registers[5 + 9 - i] = self.stack.pop()!
            count += 1
        }
        guard getStackCondition() != 2 else {
            print("Stack is empty. Program terminated.")
            self.running = false
            return
        }
        self.rPC = self.stack.pop()!
        self.rPC += 2
    }
    func push() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        guard getStackCondition() != 1 else {
            print("Stack is full. Program terminated.")
            self.running = false
            return
        }
        
        self.stack.push(element: self.registers[vars[0]])
        self.rPC += 1
    }
    func pop() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        guard getStackCondition() != 2 else {
            print("Stack is empty. Program terminated.")
            self.running = false
            return
        }
        
        self.registers[vars[0]] = self.stack.pop()!
        self.rPC += 1
    }
    func stackc() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.registers[vars[0]] = getStackCondition()
        self.rPC += 1
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
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        print(unicodeValueToCharacter(self.memory[vars[0]]), terminator: "")
        self.rPC += 1
    }
    func outcb() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        for count in 0..<(vars[1]) {
            print(unicodeValueToCharacter(self.memory[vars[0] + count]), terminator: "")
        }
        self.rPC += 1
    }
    func readi() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        var input = ""
        print("Input an integer: ", terminator: "")
        input = readLine()!
        
        guard let integer = Int(input) else {
            self.registers[vars[1]] = 1
            return
        }
        
        self.registers[vars[0]] = integer
        self.registers[vars[1]] = 0
        self.rPC += 1
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
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        var inputCharacter = ""
        while inputCharacter == "" {
            print("Input a character (the first will be taken if multiple are submitted): ", terminator: "")
            inputCharacter = readLine()!
        }
        
        self.registers[vars[0]] = characterToUnivodeValue(inputCharacter.removeFirst())
        self.rPC += 1
    }
    func readln() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        var input = ""
        while input == "" {
            print("Input a line: ", terminator: "")
            input = readLine()!
        }
        
        let characters = Array(input)
        let count = characters.count
        
        guard validMemoryLocation(vars[0] + characters.count) else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
            self.running = false
            return
        }
        
        for i in 0..<count {
            self.memory[vars[0] + i] = characterToUnivodeValue(characters[i])
        }
        
        self.registers[vars[1]] = count
        self.rPC += 1
    }
    func brk() {
        //incomplete
    }
    func movrx() {
         guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.memory[vars[1]] = self.registers[vars[0]]
        self.rPC += 1
    }
    func movxx() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        self.memory[vars[1]] = self.memory[vars[0]]
        self.rPC += 1
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
        self.rPC += 1
    }
    func jmpne() {
        guard let vars = processErrorsAndVariables() else {
            self.running = false
            return
        }
        
        if self.rCP != 0 {
            self.rPC += 1
            return
        }
        self.rPC = vars[0]
    }
    ///////////// Other helper functions
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
    //returns a register number
    func processRegister(_ location: Int) -> Int? {
        let r = self.memory[location]
        if validRegister(r) {
            return r
        }
        print("Invalid register \(r) specified in memory location \(location). Program terminated.")
        return nil
    }
    //returns a memory location
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
    //returns a memory location
    func processMemoryLocation(_ location: Int) -> Int? {
        let m = self.memory[location]
        if validMemoryLocation(m) {
            return m
        }
        print("Invalid memory location \(m) specified in memory location \(location). Program termianted.")
        return nil
    }
    //returns the count
    func processCount(_ location: Int, memoryLocations: [Int]) -> Int? {
        let count = self.memory[location]
        for memoryLocation in memoryLocations {
            let newMemoryLocation = memoryLocation + count
            if !validMemoryLocation(newMemoryLocation) {
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
        for count in (memoryLocation + 1)...(memoryLocation + self.memory[memoryLocation]) {
            returnString += String(unicodeValueToCharacter(self.memory[count]))
        }
        return returnString
    }
    //0 is ok, 1 is full, 2 is empty
    func getStackCondition() -> Int {
        if self.stack.isFull() {
            return 1
        }
        else if self.stack.isEmpty() {
            return 2
        }
        return 0
    }
}

