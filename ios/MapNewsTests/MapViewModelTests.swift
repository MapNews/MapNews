//
//  MapViewModelTests.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 1/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//


import XCTest
import GoogleMaps
@testable import MapNews

class MapViewModelTests: XCTestCase {
    var model: MapViewModel!

    override func setUp() {
        model = MapViewModel()
    }

    func testGetAllCountryCoordinateDTO_onInit() {
        XCTAssertEqual(model.allCountryCoordinateDTOs.count, 244)
    }

    func testGetLatLong_CountryExists() {
        guard let singaporeCoordinates = model.getLatLong(for: "Singapore") else {
            return
        }
        XCTAssertEqual(Coordinates.from(singaporeCoordinates), Coordinates(lat: 1.352083, long: 103.819836))
        guard let chinaCoordinates = model.getLatLong(for: "China") else {
            return
        }
        XCTAssertEqual(Coordinates.from(chinaCoordinates), Coordinates(lat: 35.86166, long: 104.195397))
    }

    func testGetLatLong_CountryDoesNotExist() {
        XCTAssertNil(model.getLatLong(for: "Hogwarts"))
        XCTAssertNil(model.getLatLong(for: "🐌"))
    }

    func testAllCountries() {
        XCTAssertEqual(model.allCountryNames?.count ?? 0, 244)
    }
}
