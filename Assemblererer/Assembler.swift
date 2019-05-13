//
//  Assembler.swift
//  Assemblererer
//
//  Created by Nick Pang on 4/11/19.
//  Copyright © 2019 Nick's Projects. All rights reserved.
//

import Foundation

class Assembler {
    private var pvm = FullVM()
    private var filePath = ""
    private var programName = ""
    private var counter = 0
    private var binaryFile = ""
    private var labelFile = ""
    private var listingFile = ""
    private var symbols: [String : Int?] = [:]
    private var start = ""
    //actual assembler code
    public func getLines() throws -> [String] {
        return splitStringIntoLines(try getFileContents()).map{String($0)}
    }
    public func lineToChunks(_ line: String) -> [String] {
        var chunk = ""
        var chunks: [String] = []
        var space = true
        var string = false
        var tuple = false
        var start = true
        for character in line {
            if start {
                if character == ";" {
                    return chunks
                }
                if character == " " {
                    continue
                }
                else if character == "\\" {
                    tuple = true
                    space = false
                }
                else if character == "\"" {
                    string = true
                    space = false
                }
                chunk += String(character)
                start = false
            }
            else {
                if character == " " && space {
                    chunks.append(chunk)
                    chunk = ""
                    start = true
                    continue
                }
                else if character == "\\" && tuple {
                    tuple = false
                    space = true
                }
                else if character == "\"" && string {
                    string = false
                    space = true
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
        let tokens = getTokens(line)
        for token in tokens {
            print(token.type, terminator: "")
        }
        print()
        return true
    }
    func firstPass() throws -> Bool {
        let lines = try getLines()
        for line in lines {
            print(line)
            parseLine(line)
        }
        return true
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
    //func addLabel()
}

//pass 1 - makes symbol table and tests for errors
//pass 2 - assembles everything else
