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
    private var labels: [String : Int?] = [:]
    private var start = ""
    //actual assembler code
    public func assemble() throws -> [String] {
        return splitStringIntoLines(try getFileContents()).map{String($0)}
    }
    public func getChunks(_ lines: [String]) -> [[String]] {
        var programInChunks: [[String]] = []
        for line in lines {
            programInChunks.append(getChunksForLine(line))
        }
        return programInChunks
    }
    public func getChunksForLine(_ line: String) -> [String] {
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
    //other supporting functions
    public func setPath(_ path: String) {
        self.filePath = path
    }
    public func setProgramName(_ name: String) {
        self.programName = name
    }
    private func getFileContents() throws -> String {
        let text = try readTextFile(filePath + programName)
        return text
    }
}

//pass 1 - makes symbol table and tests for errors
//pass 2 - assembles everything else
