//
//  CLLocationCoordinate2DExtensionTests.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 16/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import XCTest
import GoogleMaps

class CLLocationCoordinate2DExtensionTests: XCTestCase {
    let validLat: Double = -90
    let validLong: Double = 179

    func testValidLatValidLong_returnCoordinates() {
        guard let validCoordinates = Coordinates(lat: validLat, long: validLong) else {
            XCTFail("Coordinate initializer should not return nil for valid lat and long")
            return
        }
        let resultantCoordinate = CLLocationCoordinate2D.from(validCoordinates)
        XCTAssertEqual(resultantCoordinate?.latitude, CLLocationDegrees(exactly: validLat))
        XCTAssertEqual(resultantCoordinate?.longitude, CLLocationDegrees(exactly: validLong))
    }
}
