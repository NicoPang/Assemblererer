//
//  Support.swift
//  Assemblererer
//
//  Created by Nick Pang on 3/27/19.
//  Copyright © 2019 Nick's Projects. All rights reserved.
//

import Foundation

public func fit(s: String, size: Int, replacement: Character, right: Bool) -> String {
    let sSize = s.count
    if sSize == size {
        return s
    }
    if (size < sSize) {
        let index = s.index(s.startIndex, offsetBy: size)
        return String(s[...index])
    }
    var addon = ""
    let emptySpace = size - sSize;
    for _ in 0..<emptySpace {
        addon += String(replacement)
    }
    return right ? s + addon : addon + s
}


public func characterToUnivodeValue(_ c: Character) -> Int {
    return Int(c.unicodeScalars[c.unicodeScalars.startIndex].value)
}

public func unicodeValueToCharacter(_ n: Int) -> Character {
    return Character(UnicodeScalar(n)!)
}

public func stringToUnicodeValues(_ s: String) -> [Int] {
    let characters = Array(s)
    return characters.map{Int($0.unicodeScalars[$0.unicodeScalars.startIndex].value)}
}

public func splitStringIntoParts(_ expression: String) -> [String] {
    return expression.components(separatedBy: " ")
}
public func splitStringIntoLines(_ expression: String) -> [String] {
    return expression.components(separatedBy: "\n")
}
public func splitBinaryFile(_ s: String) throws -> [Int] {
    return s.split(separator: "\n").map{Int($0)!}
}

public func readTextFile(_ path: String) throws -> String {
    let text = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
    return text
}
public func writeTextFile(_ path: String, data: String) throws {
    try data.write(to: NSURL.fileURL(withPath: path), atomically: true, encoding: String.Encoding.utf8)
}

func stringToCommand(_ s: String) -> Command? {
    for command in Command.allCases {
        if String(describing: command) == s {
            return command
        }
    }
    return nil
}

func stringToDirective(_ s: String) -> Directive? {
    for directive in Directive.allCases {
        if String(describing: directive) == s {
            return directive
        }
    }
    return nil
}

enum Directive: CaseIterable {
    case String, Integer, Allocate, Tuple, Start, End
}
//m - memory location
//i - integer
//s - string
//t - tuple
let getParameterForDirective: [Directive : String] = [
    .Start : "m",
    .End : "",
    .String : "s",
    .Integer : "i",
    .Allocate : "i",
    .Tuple : "t"
]
