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
            CountryCoordinateDTO(
                name: "Montreal",
                countryCode: "MN",
                coordinates: Coordinates(lat: 20.22, long: 103.988))
        ))
    }

    func testCurrentBounds_countryOutOfBounds() {
        let withoutChina = GMSCoordinateBounds(
            coordinate: CLLocationCoordinate2D.from(Coordinates(lat: 1.352083, long: 103.819836)),
            coordinate: CLLocationCoordinate2D.from(Coordinates(lat: 20.22, long: 103.988))
        )
        model.currentBounds = withoutChina
        XCTAssertFalse(model.allCountriesInBounds.contains(
            CountryCoordinateDTO(
                name: "China",
                countryCode: "CN",
                coordinates: Coordinates(lat: 35.86166, long: 104.195397))
        ))
    }
}

class MockDatabase: Database {
    let singaporeDTO = CountryCoordinateDTO(
        name: "Singapore",
        countryCode: "SG",
        coordinates: Coordinates(lat: 1.352083, long: 103.819836))
    let chinaDTO = CountryCoordinateDTO(
        name: "China",
        countryCode: "CN",
        coordinates: Coordinates(lat: 35.86166, long: 104.195397))
    let montrealDTO = CountryCoordinateDTO(
        name: "Montreal",
        countryCode: "MN",
        coordinates: Coordinates(lat: 20.22, long: 103.988))

    func queryLatLong(name: String) -> Coordinates? {
        if name == "Singapore" {
            return singaporeDTO.coordinates
        }
        if name == "China" {
            return chinaDTO.coordinates
        }
        if name == "Montreal" {
            return montrealDTO.coordinates
        }
        return nil
    }

    func queryAllCountries() -> [String]? {
        return ["Singapore", "China", "Montreal"]
    }

    func queryAllCountriesAndCoordinates() -> [CountryCoordinateDTO]? {
        return [singaporeDTO, chinaDTO, montrealDTO]
    }

    func populateDatabaseWithCountries() {
    }

    func clearTable() {
    }

    func queryCountryDTO(name: String) -> CountryCoordinateDTO? {
        if name == "Singapore" {
            return singaporeDTO
        }
        if name == "China" {
            return chinaDTO
        }
        if name == "Montreal" {
            return montrealDTO
        }
        return nil
    }
}

class MockDatabaseOneEntry: Database {
    let hogwartsDTO = CountryCoordinateDTO(
        name: "Hogwarts",
        countryCode: "HW",
        coordinates: Coordinates(lat: 1.1, long: 102.78))
    func queryAllCountriesAndCoordinates() -> [CountryCoordinateDTO]? {
        return [ hogwartsDTO ]
    }

    func queryLatLong(name: String) -> Coordinates? {
        if name == "Hogwarts" {
            return hogwartsDTO.coordinates
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

    func queryCountryDTO(name: String) -> CountryCoordinateDTO? {
        if name == "Hogwarts" {
            return hogwartsDTO
        }
        return nil
    }
}
