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
    private var lines: [[Character]] = []
    private var start = ""
    //actual assembler code
    public func assemble() throws {
        //unfinished, fix line below
        self.lines = splitStringIntoLines(try getFileContents()).map{Array($0)}
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
