//
//  StringExtensionTests.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 27/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import XCTest

class StringExtensionTests: XCTestCase {
    let sampleString = "abcde123"
    func testStartsWith() {
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

    func testCharAt_offsetWithinRange() {
        XCTAssertEqual(sampleString.charAt(offset: 0), "a")
        XCTAssertEqual(sampleString.charAt(offset: 1), "b")
        XCTAssertEqual(sampleString.charAt(offset: 2), "c")
        XCTAssertEqual(sampleString.charAt(offset: 3), "d")
        XCTAssertEqual(sampleString.charAt(offset: 4), "e")
        XCTAssertEqual(sampleString.charAt(offset: 5), "1")
        XCTAssertEqual(sampleString.charAt(offset: 6), "2")
        XCTAssertEqual(sampleString.charAt(offset: 7), "3")

    }

    func testCharAt_offsetOutOfRange() {
        XCTAssertNil(sampleString.charAt(offset: -1))
        XCTAssertNil(sampleString.charAt(offset: 8))
    }

    func testSubstring_validStartAndEndIndex() {
        XCTAssertEqual(sampleString.substring(1, 4), "bcd")
        XCTAssertEqual(sampleString.substring(2, 7), "cde12")
    }

    func testSubstring_startOrEndOutOfRange_returnNil() {
        XCTAssertNil(sampleString.substring(-1, 4))
        XCTAssertNil(sampleString.substring(1, 10))
    }

    func testSubstring_EndLessThanStart() {
        XCTAssertNil(sampleString.substring(4, 3))
    }

}
