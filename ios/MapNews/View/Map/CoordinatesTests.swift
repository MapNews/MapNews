//
//  CoordinatesTests.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 16/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import XCTest

class CoordinatesTests: XCTestCase {
    let invalidLat: Double = 91
    let invalidLong: Double = -181
    let validLat: Double = -90
    let validLong: Double = 179

    func testInvalidLatInvalidLong_returnNil() {
        let invalidCoordinates = Coordinates(lat: invalidLat, long: invalidLong)
        XCTAssertNil(invalidCoordinates)
    }

    func testInvalidLatValidLong_returnNil() {
        let invalidCoordinates = Coordinates(lat: invalidLat, long: validLong)
        XCTAssertNil(invalidCoordinates)
    }

    func testValidLatInvalidLong_returnNil() {
        let invalidCoordinates = Coordinates(lat: validLat, long: invalidLong)
        XCTAssertNil(invalidCoordinates)
    }

    func testValidLatValidLong_returnNotNil() {
        let validCoordinates = Coordinates(lat: validLat, long: validLong)
        XCTAssertEqual(validCoordinates?.lat, validLat)
        XCTAssertEqual(validCoordinates?.long, validLong)
    }
}
