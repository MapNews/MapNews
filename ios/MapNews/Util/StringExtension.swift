//
//  StringExtension.swift
//  MapNews
//
//  Created by Hol Yin Ho on 27/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

extension String {
    func startsWith(substring: String) -> Bool {
        if substring.count > self.count {
            return false
        }
        for i in 0..<substring.count {
            if substring.charAt(offset: i) != self.charAt(offset: i) {
                return false
            }
        }
        return true
    }

    func charAt(offset: Int) -> Character? {
        if offset < 0 || offset >= count {
            return nil
        }
        return self[index(startIndex, offsetBy: offset)]
    }

    func substring(_ start: Int, _ end: Int) -> Substring? {
        if start < 0 || end >= count || start >= end {
            return nil
        }
        let substringStart = self.index(startIndex, offsetBy: start)
        let substringEnd = self.index(startIndex, offsetBy: end)
        return self[substringStart..<substringEnd]
    }
}
