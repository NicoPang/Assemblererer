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

class FullVM {
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
        let command = Command.init(rawValue: self.memory[self.rPC])
        guard let args = processErrorsAndVariables() else {
            self.running = false
            return
        }
        switch command! {
        case .halt :
            self.halt()
        case .clrr :
            self.clrr(args)
        case .clrm, .clrx :
            self.clrm(args)
        case .clrb :
            self.clrb(args)
        case .movir :
            self.movir(args)
        case .movrr :
            self.movrr(args)
        case .movrm :
            self.movrm(args)
        case .movmr, .movxr :
            self.movmr(args)
        case .movar :
            self.movar(args)
        case .movb :
            self.movb(args)
        case .addir :
            self.addir(args)
        case .addrr :
            self.addrr(args)
        case .addmr, .addxr :
            self.addmr(args)
        case .subir :
            self.subir(args)
        case .subrr :
            self.subrr(args)
        case .submr, .subxr :
            self.submr(args)
        case .mulir :
            self.mulir(args)
        case .mulrr :
            self.mulrr(args)
        case .mulmr, .mulxr :
            self.mulmr(args)
        case .divir :
            self.divir(args)
        case .divrr :
            self.divrr(args)
        case .divmr, .divxr :
            self.divmr(args)
        case .jmp :
            self.jmp(args)
        case .sojz :
            self.sojz(args)
        case .sojnz :
            self.sojnz(args)
        case .aojz :
            self.aojz(args)
        case .aojnz :
            self.aojnz(args)
        case .cmpir :
            self.cmpir(args)
        case .cmprr :
            self.cmprr(args)
        case .cmpmr :
            self.cmpmr(args)
        case .jmpn :
            self.jmpn(args)
        case .jmpz :
            self.jmpz(args)
        case .jmpp :
            self.jmpp(args)
        case .jsr :
            self.jsr(args)
        case .ret :
            self.ret()
        case .push :
            self.push(args)
        case .pop :
            self.pop(args)
        case .stackc :
            self.stackc(args)
        case .outci :
            self.outci(args)
        case .outcr :
            self.outcr(args)
        case .outcx :
            self.outcx(args)
        case .outcb :
            self.outcb(args)
        case .readi :
            self.readi(args)
        case .printi :
            self.printi(args)
        case .readc :
            self.readc(args)
        case .readln :
            self.readln(args)
        case .brk :
            self.brk()
        case .movrx :
            self.movrx(args)
        case .movxx :
            self.movxx(args)
        case .outs :
            self.outs(args)
        case .nop :
            self.nop()
        case .jmpne :
            self.jmpne(args)
        default :
            print("Invalid command at \(self.rPC). Program terminated.")
            self.running = false
        }
    }
    //list of functions needed for partialVM
    func halt() {
        self.running = false
    }
    func clrr(_ args: [Int]) {
        self.registers[args[0]] = 0
        self.rPC += 1
    }
    func clrm(_ args: [Int]) {
        self.memory[args[0]] = 0
        self.rPC += 1
    }
    func clrb(_ args: [Int]) {
        for m in args[0]..<(args[0] + args[1]) {
            self.memory[m] = 0
        }
        self.rPC += 1
    }
    func movir(_ args: [Int]) {
        self.registers[args[1]] = args[0]
        self.rPC += 1
    }
    func movrr(_ args: [Int]) {
        self.registers[args[1]] = self.registers[args[0]]
        self.rPC += 1
    }
    func movrm(_ args: [Int]) {
        self.memory[args[1]] = self.registers[args[0]]
        self.rPC += 1
    }
    func movmr(_ args: [Int]) {
        self.registers[args[1]] = self.memory[args[0]]
        self.rPC += 1
    }
    func movar(_ args: [Int]) {
        self.registers[args[1]] = args[0]
        self.rPC += 1
    }
    func movb(_ args: [Int]) {
        for m in 0..<(args[2]) {
            self.memory[args[1] + m] = self.memory[args[0] + m]
        }
        self.rPC += 1
    }
    func addir(_ args: [Int]) {
        self.registers[args[1]] += args[0]
        self.rPC += 1
    }
    func addrr(_ args: [Int]) {
        self.registers[args[1]] += self.registers[args[0]]
        self.rPC += 1
    }
    func addmr(_ args: [Int]) {
        self.registers[args[1]] += self.memory[args[0]]
        self.rPC += 1
    }
    func subir(_ args: [Int]) {
        self.registers[args[1]] -= args[0]
        self.rPC += 1
    }
    func subrr(_ args: [Int]) {
        self.registers[args[1]] -= self.registers[args[0]]
        self.rPC += 1
    }
    func submr(_ args: [Int]) {
        self.registers[args[1]] -= self.memory[args[0]]
        self.rPC += 1
    }
    func mulir(_ args: [Int]) {
        self.registers[args[1]] *= args[0]
        self.rPC += 1
    }
    func mulrr(_ args: [Int]) {
        self.registers[args[1]] *= self.registers[args[0]]
        self.rPC += 1
    }
    func mulmr(_ args: [Int]) {
        self.registers[args[1]] *= self.memory[args[0]]
        self.rPC += 1
    }
    func divir(_ args: [Int]) {
        if args[0] == 0 {
            print("Divide by 0 error. Program termianted.")
            self.running = false
            return
        }
        
        self.registers[args[1]] /= args[0]
        self.rPC += 1
    }
    func divrr(_ args: [Int]) {
        if self.registers[args[0]] == 0 {
            print("Divide by 0 error. Program termianted.")
            self.running = false
            return
        }
        
        self.registers[args[1]] /= self.registers[args[0]]
        self.rPC += 1
    }
    func divmr(_ args: [Int]) {
        if self.memory[args[0]] == 0 {
            print("Divide by 0 error. Program termianted.")
            self.running = false
            return
        }
        
        self.registers[args[1]] /= self.memory[args[0]]
        self.rPC += 1
    }
    func jmp(_ args: [Int]) {
        self.rPC = args[0]
    }
    func sojz(_ args: [Int]) {
        self.registers[args[0]] -= 1
        
        if self.registers[args[0]] == 0 {
            self.rPC = args[1]
            return
        }
        self.rPC += 1
    }
    func sojnz(_ args: [Int]) {
        self.registers[args[0]] -= 1
        
        if self.registers[args[0]] != 0 {
            self.rPC = args[1]
            return
        }
        self.rPC += 1
    }
    func aojz(_ args: [Int]) {
        self.registers[args[0]] += 1
        
        if self.registers[args[0]] == 0 {
            self.rPC = args[1]
            return
        }
        self.rPC += 1
    }
    func aojnz(_ args: [Int]) {
        self.registers[args[0]] += 1
        
        if self.registers[args[0]] != 0 {
            self.rPC = args[1]
            return
        }
        self.rPC += 1
    }
    func cmpir(_ args: [Int]) {
        self.rCP = args[0] - self.registers[args[1]]
        self.rPC += 1
    }
    func cmprr(_ args: [Int]) {
        self.rCP = self.registers[args[0]] - self.registers[args[1]]
        self.rPC += 1
    }
    func cmpmr(_ args: [Int]) {
        self.rCP = self.memory[args[0]] - self.registers[args[1]]
        self.rPC += 1
    }
    func jmpn(_ args: [Int]) {
        if self.rCP < 0 {
            self.rPC += 1
            return
        }
        self.rPC = args[0]
    }
    func jmpz(_ args: [Int]) {
        
        if self.rCP == 0 {
            self.rPC += 1
            return
        }
        self.rPC = args[0]
    }
    func jmpp(_ args: [Int]) {
        if self.rCP > 0 {
            self.rPC += 1
            return
        }
        self.rPC = args[0]
    }
    func jsr(_ args: [Int]) {
        self.stack.push(element: self.rPC)
        for i in 5...9 {
            guard getStackCondition() != 1 else {
                print("Stack is full. Program terminated.")
                self.running = false
                return
            }
            self.stack.push(element: self.registers[i])
        }
        self.rPC = args[0]
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
        self.rPC += 1
    }
    func push(_ args: [Int]) {
        guard getStackCondition() != 1 else {
            print("Stack is full. Program terminated.")
            self.running = false
            return
        }
        
        self.stack.push(element: self.registers[args[0]])
        self.rPC += 1
    }
    func pop(_ args: [Int]) {
        guard getStackCondition() != 2 else {
            print("Stack is empty. Program terminated.")
            self.running = false
            return
        }
        
        self.registers[args[0]] = self.stack.pop()!
        self.rPC += 1
    }
    func stackc(_ args: [Int]) {
        self.registers[args[0]] = getStackCondition()
        self.rPC += 1
    }
    func outci(_ args: [Int]) {
        print(unicodeValueToCharacter(args[0]), terminator: "")
        self.rPC += 1
    }
    func outcr(_ args: [Int]) {
        print(unicodeValueToCharacter(self.registers[args[0]]), terminator: "")
        self.rPC += 1
    }
    func outcx(_ args: [Int]) {
        print(unicodeValueToCharacter(self.memory[args[0]]), terminator: "")
        self.rPC += 1
    }
    func outcb(_ args: [Int]) {
        for count in 0..<(args[1]) {
            print(unicodeValueToCharacter(self.memory[args[0] + count]), terminator: "")
        }
        self.rPC += 1
    }
    func readi(_ args: [Int]) {
        var input = ""
        print("Input an integer: ", terminator: "")
        input = readLine()!
        
        guard let integer = Int(input) else {
            self.registers[args[1]] = 1
            return
        }
        
        self.registers[args[0]] = integer
        self.registers[args[1]] = 0
        self.rPC += 1
    }
    func printi(_ args: [Int]) {
        print(self.registers[args[0]], terminator: "")
        self.rPC += 1
    }
    func readc(_ args: [Int]) {
        var inputCharacter = ""
        while inputCharacter == "" {
            print("Input a character (the first will be taken if multiple are submitted): ", terminator: "")
            inputCharacter = readLine()!
        }
        
        self.registers[args[0]] = characterToUnivodeValue(inputCharacter.removeFirst())
        self.rPC += 1
    }
    func readln(_ args: [Int]) {
        var input = ""
        while input == "" {
            print("Input a line: ", terminator: "")
            input = readLine()!
        }
        
        let characters = Array(input)
        let count = characters.count
        
        guard validMemoryLocation(args[0] + characters.count) else {
            print("Invalid memory location \(self.memorySize). Program terminated.")
            self.running = false
            return
        }
        
        for i in 0..<count {
            self.memory[args[0] + i] = characterToUnivodeValue(characters[i])
        }
        
        self.registers[args[1]] = count
        self.rPC += 1
    }
    func brk() {
        //incomplete
    }
    func movrx(_ args: [Int]) {
        self.memory[args[1]] = self.registers[args[0]]
        self.rPC += 1
    }
    func movxx(_ args: [Int]) {
        self.memory[args[1]] = self.memory[args[0]]
        self.rPC += 1
    }
    func outs(_ args: [Int]) {
        print(makeString(memoryLocation: args[0]), terminator: "")
        self.rPC += 1
    }
    func nop () {
        self.rPC += 1
    }
    func jmpne(_ args: [Int]) {
        if self.rCP == 0 {
            self.rPC += 1
            return
        }
        self.rPC = args[0]
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

