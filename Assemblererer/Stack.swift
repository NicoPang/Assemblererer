//
//  Stack.swift
//  Assemblererer
//
//  Created by Nick Pang on 4/9/19.
//  Copyright © 2019 Nick's Projects. All rights reserved.
//

import Foundation

struct Stack<Element>: CustomStringConvertible, Sequence, IteratorProtocol {
    var elements: [Element] = []
    let capacity: Int
    var count: Int = 0
    init (size: Int, initial: Element) {
        self.capacity = size
        self.elements = Array(repeatElement(initial, count: size))
    }
    func isEmpty() -> Bool {
        if self.count == 0 {
            return true
        }
        return false
    }
    func isFull() -> Bool {
        if self.count == self.capacity {
            return true
        }
        return false
    }
    mutating func next() -> Element? {
        return self.pop()
    }
    mutating func push(element: Element) {
        if !isFull() {
            self.elements[self.count] = element
            self.count += 1
        }
    }
    mutating func pop() -> Element? {
        if !isEmpty() {
            self.count -= 1
            let element = self.elements[self.count]
            return element
        }
        return nil
    }
    var description: String {
        return self.reduce("H", {$0 + " \($1)"})
    }
}
