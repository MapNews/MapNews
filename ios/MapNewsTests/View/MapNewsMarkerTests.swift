//
//  MapNewsMarkerTests.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 7/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import XCTest
import GoogleMaps

class MapNewsMarkerTests: XCTestCase {
    func testInit() {
        let locationName = "Hogwarts"
        let marker = MapNewsMarker(at: CountryCoordinateDTO(name: "Hogwarts",
                                                            countryCode: "HW",
                                                            coordinates: Coordinates(lat: 1.03, long: 2.04)))
        XCTAssertEqual(marker.location.countryName, locationName)
        XCTAssertEqual(Coordinates.from(marker.position), Coordinates(lat: 1.03, long: 2.04))
    }
}
