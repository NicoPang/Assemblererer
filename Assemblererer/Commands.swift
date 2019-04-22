//
//  Commands.swift
//  Assemblererer
//
//  Created by Nick Pang on 3/27/19.
//  Copyright © 2019 Nick's Projects. All rights reserved.
//

import Foundation

enum Command: Int {
    case halt = 0, clrr, clrx, clrm, clrb, movir, movrr, movrm, movmr, movxr, movar, movb, addir, addrr, addmr, addxr, subir, subrr, submr, subxr, mulir, mulrr, mulmr, mulxr, divir, divrr, divmr, divxr, jmp, sojz, sojnz, aojz, aojnz, cmpir, cmprr, cmpmr, jmpn, jmpz, jmpp, jsr, ret, push, pop, stackc, outci, outcr, outcx, outcb, readi, printi, readc, readln, brk, movrx, movxx, outs, nop, jmpne
}
/*
 The following dictionary returns the necessary variables for each command; this makes error checking a whole lot smoother
 */

//i - integer - not meant to do anything
//r - content of register
//x - content of memory location in r
//m - content of memory location (label or not, doesn't matter for binary)
//b - count - needs to go last, all proceeding characters are guaranteed memory locations in some respect and will take count into effect

let commands: [Command : String] = [
    .halt : "",
    .clrr : "r",
    .clrx : "x",
    .clrm : "m",
    .clrb : "xb",
    .movir : "ir",
    .movrr : "rr",
    .movrm : "rm",
    .movmr : "mr",
    .movxr : "xr",
    .movar : "mr",
    .movb : "xxb",
    .addir : "ir",
    .addrr : "rr",
    .addmr : "mr",
    .addxr : "xr",
    .subir : "ir",
    .subrr : "rr",
    .submr : "mr",
    .subxr : "xr",
    .mulir : "ir",
    .mulrr : "rr",
    .mulmr : "mr",
    .mulxr : "xr",
    .divir : "ir", //needs to check for div by 0
    .divrr : "rr", //needs to check for div by 0
    .divmr : "mr", //needs to check for div by 0
    .divxr : "xr", //needs to check for div by 0
    .jmp : "m",
    .sojz : "rm",
    .sojnz : "rm",
    .aojz : "rm",
    .aojnz : "rm",
    .cmpir : "ir",
    .cmprr : "rr",
    .cmpmr : "mr",
    .jmpn : "m",
    .jmpz : "m",
    .jmpp : "m",
    .jsr : "m", //stack error
    .ret : "", //stack error
    .push : "r", //stack error
    .pop : "r", //stack error
    .stackc : "r",
    .outci : "i",
    .outcr : "r",
    .outcx : "x",
    .outcb : "xb",
    .readi : "rr",
    .printi : "r",
    .readc : "r",
    .readln : "mr",
    .brk : "",
    .movrx : "rx",
    .movxx : "xx",
    .outs : "m",
    .nop : "",
    .jmpne : "m"
]
