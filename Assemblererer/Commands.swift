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
//i - integer - not meant to do anything
//r - register
//x - memory location in r
//m - memory location (label or not, doesn't matter for binary)
//b - count - needs to go first, all proceeding characters are guaranteed memory locations in some respect and will take count into effect

/*
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
    .movar : "ar",
    .movb : "xxb", //unsure what to do here
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
    .divir : "ir",
    .divrr : "rr",
    .divmr : "mr",
    .divxr : "xr",
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
    .jsr : "m",
    .ret : "",
    .push : "r",
    .pop : "r",
    .stackc : "r",
    .outci : "i",
    .outcr : "r",
    .outcx : "x",
    .outcb : "xb",
    .readi : "rr",
    .printi : "r",
    .readc : "r",
    .readln : "mb",
    .brk : "",
    .movrx : "rx",
    .movxx : "xx",
    .outs : "m",
    .nop : "",
    .jmpne : "m"
    
]
*/
