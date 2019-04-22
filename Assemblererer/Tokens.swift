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
