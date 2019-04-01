//
//  Support.swift
//  Assemblererer
//
//  Created by Nick Pang on 3/27/19.
//  Copyright © 2019 Nick's Projects. All rights reserved.
//

import Foundation

func fit(s: String, size: Int, replacement: Character, right: Bool) -> String {
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


func characterToUnivodeValue(_ c: Character) -> Int{
    return Int(c.unicodeScalars[c.unicodeScalars.startIndex].value)
}

func unicodeValueToCharacter(_ n: Int) -> Character{
    return Character(UnicodeScalar(n)!)
}

func stringToUnicodeValues(_ s: String) -> [Int] {
    let characters = Array(s)
    return characters.map{Int($0.unicodeScalars[$0.unicodeScalars.startIndex].value)}
}

func splitStringIntoParts(_ expression: String) -> [String] {
    return expression.components(separatedBy: " ")
}
func splitStringIntoLines(_ expression: String) -> [String] {
    return expression.components(separatedBy: "\n")
}

func splitBinaryFile(_ s: String) throws -> [Int] {
    return s.components(separatedBy: CharacterSet(charactersIn: "\n ,")).map{Int($0)!}
}
