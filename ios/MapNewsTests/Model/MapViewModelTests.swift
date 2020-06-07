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
        XCTAssertEqual(model.allCountryCoordinateDTOs.count, 3)
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
        XCTAssertEqual(model.allCountryNames?.count ?? 0, 3)
    }

    func testAllCountriesAndCoordinatesDTOListener_withDatabase() {
        model.database = MockDatabaseOneEntry()
        XCTAssertEqual(model.allCountryCoordinateDTOs.count, 1)
    }

    func testCurrentBounds_countryInBounds() {
        let newBounds = GMSCoordinateBounds(
            coordinate: CLLocationCoordinate2D.from(Coordinates(lat: 1.352083, long: 103.819836)),
            coordinate: CLLocationCoordinate2D.from(Coordinates(lat: 35.86166, long: 104.195397))
        )
        model.currentBounds = newBounds
        XCTAssertTrue(model.allCountriesInBounds.contains(
            CountryCoordinateDTO(name: "Montreal", coordinates: Coordinates(lat: 20.22, long: 103.988))
        ))
    }

    func testCurrentBounds_countryOutOfBounds() {
        let withoutChina = GMSCoordinateBounds(
            coordinate: CLLocationCoordinate2D.from(Coordinates(lat: 1.352083, long: 103.819836)),
            coordinate: CLLocationCoordinate2D.from(Coordinates(lat: 20.22, long: 103.988))
        )
        model.currentBounds = withoutChina
        XCTAssertFalse(model.allCountriesInBounds.contains(
            CountryCoordinateDTO(name: "China", coordinates: Coordinates(lat: 35.86166, long: 104.195397))
        ))
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
        if name == "Montreal" {
            return Coordinates(lat: 20.22, long: 103.988)
        }
        return nil
    }

    func queryAllCountries() -> [String]? {
        return ["Singapore", "China", "Montreal"]
    }

    func queryAllCountriesAndCoordinates() -> [CountryCoordinateDTO]? {
        return [
            CountryCoordinateDTO(name: "Singapore", coordinates: Coordinates(lat: 1.352083, long: 103.819836)),
            CountryCoordinateDTO(name: "China", coordinates: Coordinates(lat: 35.86166, long: 104.195397)),
            CountryCoordinateDTO(name: "Montreal", coordinates: Coordinates(lat: 20.22, long: 103.988))
        ]
    }

    func populateDatabaseWithCountries() {
    }

    func clearTable() {
    }
}

class MockDatabaseOneEntry: Database {
    func queryAllCountriesAndCoordinates() -> [CountryCoordinateDTO]? {
        return [
            CountryCoordinateDTO(name: "Hogwarts", coordinates: Coordinates(lat: 1.1, long: 102.78))
        ]
    }

    func queryLatLong(name: String) -> Coordinates? {
        if name == "Hogwarts" {
            return Coordinates(lat: 1.1, long: 102.78)
        }
        return nil
    }

    func queryAllCountries() -> [String]? {
        return ["Hogwarts"]
    }

    func populateDatabaseWithCountries() {
    }

    func clearTable() {
    }
}
