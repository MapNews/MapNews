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
        XCTAssertEqual(model.getLatLong(for: "Singapore"), Coordinates(lat: 1.352083, long: 103.819836))
        XCTAssertEqual(model.getLatLong(for: "China"), Coordinates(lat: 35.86166, long: 104.195397))
    }

    func testGetLatLong_CountryDoesNotExist() {
        XCTAssertNil(model.getLatLong(for: "Hogwarts"))
        XCTAssertNil(model.getLatLong(for: "🐌"))
    }

    func testAllCountries() {
        XCTAssertEqual(model.allCountryNames?.count ?? 0, 244)
    }

    func testGetCountriesWithinBounds() {
        let singaporeCoordinates =
            CLLocationCoordinate2D.from(coordinates: Coordinates(lat: 1.352083, long: 103.819836))
        let japanCoordinates =
            CLLocationCoordinate2D.from(coordinates: Coordinates(lat: 36.204824, long: 138.252924))

        let singaporeDTO =
            CountryCoordinateDTO(name: "Singapore", coordinates: Coordinates(lat: 1.352083, long: 103.819836))
        let japanDTO =
            CountryCoordinateDTO(name: "Japan", coordinates: Coordinates(lat: 36.204824, long: 138.252924))
        let vietnamDTO =
            CountryCoordinateDTO(name: "Vietnam", coordinates: Coordinates(lat: 14.058324, long: 108.277199))
        let southKoreaDTO =
            CountryCoordinateDTO(name: "South Korea", coordinates: Coordinates(lat: 35.907757, long: 127.766922))


        let bounds = GMSCoordinateBounds(coordinate: singaporeCoordinates, coordinate: japanCoordinates)
        let countryWithinBounds = model.updateCountries(within: bounds)
        XCTAssertTrue(countryWithinBounds.contains(singaporeDTO))
        XCTAssertTrue(countryWithinBounds.contains(japanDTO))
        XCTAssertTrue(countryWithinBounds.contains(vietnamDTO))
        XCTAssertTrue(countryWithinBounds.contains(southKoreaDTO))
    }
}
