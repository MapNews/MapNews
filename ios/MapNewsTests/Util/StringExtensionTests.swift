//
//  StringExtensionTests.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 27/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import XCTest

class StringExtensionTests: XCTestCase {
    func testStartsWith() {
        let sampleString = "abcde123"
        XCTAssertFalse(sampleString.startsWith(substring: "abcde1234"))
        XCTAssertFalse(sampleString.startsWith(substring: "abdce"))

        XCTAssertTrue(sampleString.startsWith(substring: "ab"))
        XCTAssertTrue(sampleString.startsWith(substring: "abcde123"))
        XCTAssertTrue(sampleString.startsWith(substring: ""))

        let emojiString = "Koala 🐨, Snail 🐌, Penguin 🐧, Dromedary 🐪"
        XCTAssertTrue(emojiString.startsWith(substring: "Koala 🐨, Sn"))
        XCTAssertFalse(emojiString.startsWith(substring: "Koal 🐨, Sn"))
        XCTAssertTrue(emojiString.startsWith(substring: ""))
    }
}
