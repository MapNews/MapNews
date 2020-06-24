//
//  JsonParserTests.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 24/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import XCTest

class JsonParserTests: XCTestCase {
    func testCreateJsonObject_dataInvalid_returnNil() {
        let string = ""
        guard let invalidData = Data(base64Encoded: string) else {
            XCTFail("Should be able to cast to data")
            return
        }
        let result = JSONParser.createJsonObject(from: invalidData)
        XCTAssertNil(result)
    }

    func testGetObject_objectNotDictionary_returnNil() {
        let jsonObject: Any = "Test"
        let result = JSONParser.getObject(from: jsonObject, key: "Test")
        XCTAssertNil(result)
    }

    func testGetObject_objectIsDictionary_invalidKey_returnNil() {
        let jsonObject: Any = ["Test": "value"]
        let result = JSONParser.getObject(from: jsonObject, key: "test")
        XCTAssertNil(result)
    }

    func testGetObject_objectIsDictionary_validKey_returnValue() {
        let jsonObject: Any = ["Test": "value"]
        let result = JSONParser.getObject(from: jsonObject, key: "Test")
        XCTAssertEqual(result as? String, "value")
    }

    func testGetArray_objectNotDictionary_returnNil() {
        let jsonObject: Any = "Test"
        let result = JSONParser.getArray(from: jsonObject, key: "Test")
        XCTAssertNil(result)
    }

    func testGetArray_objectIsDictionary_invalidKey_returnNil() {
        let jsonObject: Any = ["Test": ["1", "2", "3"]]
        let result = JSONParser.getArray(from: jsonObject, key: "test")
        XCTAssertNil(result)
    }

    func testGetArray_objectIsDictionary_validKey_valueNotArray_returnNil() {
        let jsonObject: Any = ["Test": "2"]
        let result = JSONParser.getArray(from: jsonObject, key: "Test")
        XCTAssertNil(result)
    }

    func testGetArray_objectIsDictionary_validKey_returnArray() {
        let jsonObject: Any = ["Test": ["1", "2", "3"]]
        guard let result = JSONParser.getArray(from: jsonObject, key: "Test") as? [String] else {
            XCTFail("Should be able to cast to array")
            return
        }
        XCTAssertEqual(result, ["1", "2", "3"])
    }
}
