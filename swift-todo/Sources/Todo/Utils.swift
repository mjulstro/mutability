//
//  Utils.swift
//  Todo
//
//  Created by Paul on 2018/4/4.
//

import Foundation

extension CharacterSet {
    static let nonWhitespace = CharacterSet.whitespacesAndNewlines.inverted
}

extension String {
    func isBlank() -> Bool {
        return rangeOfCharacter(from: .nonWhitespace) == nil
    }
}

extension Array {
    mutating func remove(where predicate: (Element) -> Bool) {
        var dst = startIndex
        for src in indices {
            let elem = self[src]
            if !predicate(elem) {
                self[dst] = elem
                dst += 1
            }
        }
        removeSubrange(dst ..< endIndex)
    }
}
