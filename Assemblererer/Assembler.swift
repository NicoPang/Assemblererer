//
//  Assembler.swift
//  Assemblererer
//
//  Created by Nick Pang on 4/11/19.
//  Copyright © 2019 Nick's Projects. All rights reserved.
//

import Foundation

class Assembler {
    var pvm = FullVM()
    private var filePath = ""
    private var programName = ""
    private var counter = 0
    private var binaryFile = ""
    private var labelFile = ""
    private var listingFile = ""
    private var errors = 0
    private var start = 0
    private var binaryCount = 0
    var symbolTable: [String : Int?] = [:]
    private var breakPoints: Set<Int> = []
    private var statusFlag: StatusFlag = .G
    var breakPointsEnabled = true
    //actual assembler code
    public func getLines() throws -> [String] {
        return splitStringIntoLines(try getFileContents()).map{String($0)}
    }
    public func lineToChunks(_ line: String) -> [String] {
        var chunk = ""
        var chunks: [String] = []
        var normalChunk = true
        var stringChunk = false
        var tupleChunk = false
        var startOfChunk = true
        for character in line {
            if startOfChunk {
                if character == ";" {
                    return chunks
                }
                if character == " " {
                    continue
                }
                else if character == "\\" {
                    tupleChunk = true
                    normalChunk = false
                }
                else if character == "\"" {
                    stringChunk = true
                    normalChunk = false
                }
                chunk += String(character)
                startOfChunk = false
            }
            else {
                if character == " " && normalChunk {
                    chunks.append(chunk)
                    chunk = ""
                    startOfChunk = true
                    continue
                }
                else if character == "\\" && tupleChunk {
                    tupleChunk = false
                    normalChunk = true
                }
                else if character == "\"" && stringChunk {
                    stringChunk = false
                    normalChunk = true
                }
                chunk += String(character)
            }
        }
        if chunk != "" {
            chunks.append(chunk)
        }
        return chunks
    }
    func chunkToToken(_ chunk: String) -> Token {
        switch (chunk.first, chunk.last) {
        case (".", _) :
            //directive
            return getDirective(chunk)
        case ("\\", "\\") :
            return getTuple(chunk)
        case ("\\", _) :
            return getTuple(chunk)
        case ("\"", "\"") :
            return getString(chunk)
        case ("\"", _) :
            return getString(chunk + "\"")
        case (_, ":") :
            return getLabelDefinition(chunk)
        case ("#", _) :
            return getInteger(chunk)
        case ("r", _) :
            return getRegister(chunk)
        default :
            return getLabel(chunk)
        }
    }
    func getTokens(_ line: String) -> [Token] {
        let chunks = lineToChunks(line)
        return chunks.map{chunkToToken($0)}
    }
    //returns false for
    func parseLine(_ line: String) -> Bool {
        var tokens = getTokens(line)
        guard tokens.count >= 1 else {
            return true
        }
        if tokens[0].type == .LabelDefinition {
            if self.symbolTable[tokens[0].stringValue!] != nil {
                self.listingFile += "----------Cannot have repeated label definitions\n"
                self.errors += 1
                return false
            }
            symbolTable[tokens[0].stringValue!] = 1
            tokens.removeFirst()
        }
        if tokens[0].type == .Directive {
            let vars = getParameterForDirective[tokens[0].directive!]!
            let firstToken = tokens.removeFirst()
            return checkAsmParameters(vars: vars, tokens: tokens, token: firstToken)
        }
        else if tokens[0].type == .Instruction {
            let vars = getVariablesforVMCommand[Command(rawValue: tokens[0].intValue!)!]!
            let firstToken = tokens.removeFirst()
            return checkAsmParameters(vars: vars, tokens: tokens, token: firstToken)
        }
        self.listingFile += "----------Expected directive or instruction\n"
        self.errors += 1
        return false
    }
    func firstPass(lines: [String]) -> Bool {
        var noErrors = true
        var rPC = 0
        for line in lines {
            self.listingFile += line + "\n"
            if !parseLine(line) {
                noErrors = false
            }
            parseLineWithoutLabel(line, &rPC)
        }
        for (label, labelLocation) in symbolTable {
            if labelLocation == nil {
                self.listingFile += "----------Label \(label) not defined\n"
                self.errors += 1
            }
            noErrors = false
        }
        do {
            if noErrors {
                try writeTextFile(self.filePath + self.programName + ".lst", data: self.listingFile)
            }
        }
        catch {
            print("Unable to write file")
        }
        return noErrors
    }
    func secondPass(lines: [String]) {
        var rPC = 0
        self.listingFile = ""
        for line in lines {
            parseLineTwice(line, &rPC)
        }
        self.listingFile += "\n\n\(self.labelFile)"
        self.binaryCount = rPC
        do {
            try writeTextFile(self.filePath + self.programName + ".lst", data: self.listingFile)
            try writeTextFile(self.filePath + self.programName + ".bin", data: self.binaryFile)
            try writeTextFile(self.filePath + self.programName + ".sym", data: self.labelFile)
        }
        catch {
            print("Unable to write files")
        }
    }
    func assemble() {
        self.errors = 0
        do {
            print("Assembling file \(self.filePath)\(self.programName).txt")
            let lines = try getLines()
            if firstPass(lines: lines) {
                print("Assembly found \(self.errors) errors")
                print("No binary file written")
                print("See .lst file for errors")
                return
            }
            secondPass(lines: lines)
            print("Assembly was successful.")
        }
        catch {
            print("Cannot read file \(self.filePath)\(self.programName).txt")
            return
        }
    }
    func parseLineWithoutLabel(_ line: String, _ rPC: inout Int) {
        let tokens = getTokens(line)
        var isAllocate = false
        for token in tokens {
            switch token.type {
            case .LabelDefinition :
                self.symbolTable[token.stringValue!] = rPC
            case .ImmediateString :
                rPC += token.stringValue!.count + 1
            case .Directive :
                isAllocate = token.directive! == .Allocate
            case .ImmediateInteger :
                rPC += isAllocate ? token.intValue! : 1
            case .ImmediateTuple :
                rPC += 5
            case .Instruction, .Register, .Label :
                rPC += 1
            default :
                break
            }
        }
    }
    func parseLineTwice(_ line: String, _ rPC: inout Int) {
        let tokens = getTokens(line)
        var listingLine = ""
        var binary: [Int] = []
        var isAllocate = false
        var isStart = false
        listingLine += "\(rPC):"
        for token in tokens {
            switch token.type {
            case .LabelDefinition :
                labelFile += "\(token.stringValue!) \(rPC)\n"
            case .ImmediateString :
                binary.append(token.stringValue!.count)
                for character in token.stringValue! {
                    binary.append(characterToUnivodeValue(character))
                }
            case .Directive :
                if token.directive! == .Allocate {
                    isAllocate = true
                }
                else if token.directive! == .Start {
                    isStart = true
                }
            case .ImmediateInteger :
                if isAllocate {
                    for _ in 1...token.intValue! {
                        binary.append(0)
                    }
                }
                else {
                    binary.append(token.intValue!)
                }
            case .ImmediateTuple :
                let tuple = token.tupleValue!
                binary.append(tuple.currentState)
                binary.append(tuple.inputCharacter)
                binary.append(tuple.newState)
                binary.append(tuple.outputCharacter)
                binary.append(tuple.direction)
            case .Instruction :
                binary.append(token.intValue!)
                if Command(rawValue: token.intValue!) == .brk {
                    self.breakPoints.insert(rPC)
                }
            case .Register :
                binary.append(token.intValue!)
            case .Label :
                if isStart {
                    self.start = self.symbolTable[token.stringValue!]!!
                    isStart = false
                }
                else {
                    binary.append(self.symbolTable[token.stringValue!]!!)
                }
            default :
                break
            }
        }
        if binary.count > 4 {
            for i in 0...3 {
                listingLine += " \(binary[i])"
            }
        }
        else {
            for b in binary {
                listingLine += " \(b)"
            }
        }
        self.listingFile += fit(s: listingLine, size: 30, replacement: " ", right: true) + line + "\n"
        for b in binary {
            self.binaryFile += String(b) + "\n"
        }
        rPC += binary.count
    }
    //other supporting functions
    public func setPath(_ path: String) {
        self.filePath = path
    }
    public func setProgramName(_ name: String) {
        self.programName = name
    }
    private func getFileContents() throws -> String {
        let text = try readTextFile(filePath + programName + ".txt")
        return text
    }
    func getLabel(_ label: String) -> Token {
        if let directive = stringToDirective(label) {
            return Token(.Directive, directive: directive)
        }
        if let command = stringToCommand(label) {
            return Token(.Instruction, int: command.rawValue)
        }
        if CharacterSet.letters.contains(label.first!.unicodeScalars.first!) && CharacterSet.alphanumerics.isSuperset(of: CharacterSet(charactersIn: label)) {
            return Token(.Label, string: label)
        }
        return Token(.BadToken)
    }
    func getLabelDefinition(_ label: String) -> Token {
        var label = label
        label.removeLast()
        let token = getLabel(label)
        if token.type != .Label {
            return Token(.BadToken)
        }
        let newToken = Token(.LabelDefinition, string: token.stringValue!)
        return newToken
    }
    func getString(_ string: String) -> Token {
        guard string.count > 3 else {
            return Token(.BadToken)
        }
        var string = string
        string.removeFirst()
        string.removeLast()
        return Token(.ImmediateString, int: string.count, string: string)
    }
    func getInteger(_ int: String) -> Token {
        var integer = int
        integer.removeFirst()
        guard let int = Int(integer) else {
            return Token(.BadToken)
        }
        return Token(.ImmediateInteger, int: int)
    }
    func getRegister(_ register: String) -> Token {
        guard register.count == 2 else {
            return getLabel(register)
        }
        guard let registerNumber = Int(String(register.last!)) else {
            return getLabel(register)
        }
        return Token(.Register, int: registerNumber)
    }
    func getDirective(_ directive: String) -> Token {
        var directive = directive
        directive.removeFirst()
        if let directive = stringToDirective(directive) {
            return Token(.Directive, directive: directive)
        }
        return Token(.BadToken)
    }
    func getTuple(_ tuple: String) -> Token{
        guard tuple.count > 3 else {
            return Token(.BadToken)
        }
        var tuple = tuple
        tuple.removeFirst()
        tuple.removeLast()
        let values = splitStringIntoParts(tuple)
        guard values.count == 5 else {
            return Token(.BadToken)
        }
        guard let currentState = Int(values[0]) else {
            return Token(.BadToken)
        }
        guard values[1].count == 1 else {
            return Token(.BadToken)
        }
        guard let newState = Int(values[2]) else {
            return Token(.BadToken)
        }
        guard values[3].count == 1 else {
            return Token(.BadToken)
        }
        guard values[4] == "l" || values[4] == "r" else {
            return Token(.BadToken)
        }
        return Token(.ImmediateTuple, tuple: Tuple(currentState: currentState, inputCharacter: characterToUnivodeValue(Character(values[1])), newState: newState, outputCharacter: characterToUnivodeValue(Character(values[3])), direction: values[4] == "l" ? -1 : 1))
    }
    //i - integer - not meant to do anything
    //r - content of register
    //x - content of memory location in r
    //m - content of memory location (label or not, doesn't matter for binary)
    //b - count - needs to go last, all proceeding characters are guaranteed memory locations in some respect and will take count into effect
    //s - string
    //t - tuple
    func checkAsmParameters(vars: String, tokens: [Token], token: Token) -> Bool {
        var tokens = tokens
        guard vars.count == tokens.count else {
            self.listingFile += "----------Illegal parameters for \(token.type) \(token.type == .Directive ? String(describing: token.directive!) : String(describing: Command(rawValue: token.intValue!)!))\n"
            return false
        }
        for v in vars {
            let associatedTokenType = tokens.removeFirst()
            switch (v, associatedTokenType.type) {
            case ("i", .ImmediateInteger) : break
            case ("r", .Register) : break
            case ("x", .Register) : break
            case ("m", .Label) : addLabelFirstPass(associatedTokenType.stringValue!)
            case ("b", .ImmediateInteger) : break
            case ("s", .ImmediateString) : break
            case ("t", .ImmediateTuple) : break
            default : return false
            }
        }
        return true
    }
    func addLabelFirstPass(_ label: String) {
        if symbolTable[label] == nil {
            symbolTable[label] = nil
        }
    }
    func printLabelFile() {
        print(self.labelFile)
    }
    func setStatusFlag(to flag: StatusFlag) {
        self.statusFlag = flag
    }
    func setBreakPoint(at address: Int) {
        self.breakPoints.insert(address)
    }
    func removeBreakPoint(at address: Int) {
        self.breakPoints.remove(address)
    }
    func clearBreakPoints() {
        self.breakPoints = []
    }
    func findLabelAtMemoryLocation(_ location: Int) -> String? {
        for (label, address) in self.symbolTable {
            if address! == location {
                return label
            }
        }
        return nil
    }
    func printBreakPoints() {
        for breakPoint in self.breakPoints {
            print(breakPoint, terminator: "")
            if let label = findLabelAtMemoryLocation(breakPoint) {
                print("(\(label))")
            }
            else {
                print("\n")
            }
        }
    }
}

//pass 1 - makes symbol table and tests for errors
//pass 2 - assembles everything else
