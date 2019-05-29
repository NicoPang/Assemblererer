//
//  main.swift
//  Assemblererer
//
//  Created by Nick Pang on 3/27/19.
//  Copyright © 2019 Nick's Projects. All rights reserved.
//

import Foundation
let doublesProgram = [79,43,0,20,10,26,65,32,80,114,111,103,114,97,109,32,84,111,32,80,114,105,110,116,32,68,111,117,98,108,101,115,12,32,68,111,117,98,108,101,100,32,105,115,32,8,0,8,8,1,9,8,2,0,55,3,45,0,6,8,1,13,8,1,49,8,55,30,49,1,45,0,34,8,9,12,1,8,57,56,0]

let sumProgram = [135, 11, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 1, 10, 1, 2, 5, 100, 3, 39, 42, 8, 0, 1, 10, 1, 2, 39, 55, 6, 0, 1, 10, 1, 2, 8, 0, 3, 39, 111, 0, 53, 3, 2, 12, 1, 2, 12, 1, 3, 30, 1, 42, 40, 1, 0, 15, 2, 0, 12, 1, 2, 30, 1, 57, 40, 31, 84, 104, 101, 32, 115, 117, 109, 32, 111, 102, 32, 116,104, 101, 32, 100, 97, 116, 97, 32, 97, 114, 114, 97, 121, 32, 105, 115, 46, 46, 46, 10, 84, 104, 101, 32, 65,114, 114, 97, 121, 58, 10, 55, 67, 49, 1, 44, 10, 55, 99, 44, 10, 9, 2, 4, 49, 4, 44, 10, 12, 1, 2, 30, 3, 121, 40]

let factorialProgram = [56, 2, 3, 10, 8, 0, 5, 8, 1, 6, 6, 5, 1, 39, 22, 39, 47, 12, 1, 5, 30, 6, 8, 0, 5, 1, 0, 21, 1, 0, 30, 1, 25, 40, 14, 32, 102, 97, 99, 116, 111, 114, 105, 97, 108, 32, 105, 115, 32, 49, 5, 55, 32, 49, 0, 44, 10, 40]
let tupleProgram = [119, 114, 0,
    95,
    0,
    95,
    1,
    0,
    49,
    1,
    48,
    1,
    0,
    48,
    1,
    49,
    1,
    1,
    48,
    1,
    49,
    1,
    1,
    49,
    1,
    48,
    1,
    0,
    18,
    87,
    101,
    108,
    99,
    111,
    109,
    101,
    32,
    116,
    111,
    32,
    84,
    117,
    114,
    105,
    110,
    103,
    33,
    7,
    84,
    117,
    112,
    108,
    101,
    115,
    58,
    55,
    45,
    10,
    0,
    0,
    10,
    25,
    1,
    39,
    69,
    34,
    0,
    1,
    57,
    61,
    40,
    9,
    0,
    5,
    49,
    5,
    44,
    32,
    12,
    1,
    0,
    46,
    0,
    44,
    32,
    12,
    1,
    0,
    9,
    0,
    5,
    49,
    5,
    44,
    32,
    12,
    1,
    0,
    46,
    0,
    44,
    32,
    12,
    1,
    0,
    9,
    0,
    5,
    49,
    5,
    12,
    1,
    0,
    44,
    10,
    40,
    55,
    26,
    39,
    53,
    0]
var asm = Assembler()
asm.setPath("/Users/nick/Desktop/")
do {
}
/*var pvm = FullVM()
pvm.inputBinaryFromFile(path: "/Users/nick/Desktop/turing.bin")
pvm.run()*/

