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

    func charAt(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
