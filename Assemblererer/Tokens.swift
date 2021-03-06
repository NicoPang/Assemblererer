//
//  Tokens.swift
//  Assemblererer
//
//  Created by Nick Pang on 4/22/19.
//  Copyright © 2019 Nick's Projects. All rights reserved.
//

import Foundation

enum TokenType {
    case Register, LabelDefinition, Label, ImmediateString, ImmediateInteger, ImmediateTuple, Instruction, Directive, BadToken
}
struct Token {
    public let type: TokenType
    public let intValue: Int?
    public let stringValue: String?
    public let tupleValue: Tuple?
    public let directive: Directive?
    init (_ type: TokenType, int: Int? = nil, string: String? = nil, tuple: Tuple? = nil, directive: Directive? = nil) {
        self.type = type
        self.intValue = int
        self.stringValue = string
        self.tupleValue = tuple
        self.directive = directive
    }
}
