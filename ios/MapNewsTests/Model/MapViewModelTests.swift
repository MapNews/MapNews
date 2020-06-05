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
        model.database = MockDatabase()
    }

    func testGetAllCountryCoordinateDTO_onInit() {
        XCTAssertEqual(model.allCountryCoordinateDTOs.count, 2)
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
        XCTAssertEqual(model.allCountryNames?.count ?? 0, 2)
    }
}

class MockDatabase: Database {
    func queryLatLong(name: String) -> Coordinates? {
        if name == "Singapore" {
            return Coordinates(lat: 1.352083, long: 103.819836)
        }
        if name == "China" {
            return Coordinates(lat: 35.86166, long: 104.195397)
        }
        return nil
    }

    func queryAllCountries() -> [String]? {
        return ["Singapore", "China"]
    }

    func queryAllCountriesAndCoordinates() -> [CountryCoordinateDTO]? {
        return [
            CountryCoordinateDTO(name: "Singapore", coordinates: Coordinates(lat: 1.352083, long: 103.819836)),
            CountryCoordinateDTO(name: "China", coordinates: Coordinates(lat: 35.86166, long: 104.195397))
        ]
    }
}
