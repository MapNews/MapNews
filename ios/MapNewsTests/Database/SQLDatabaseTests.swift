//
//  SQLDatabaseTests.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 6/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import XCTest

class SQLDatabaseTests: XCTestCase {
    static var database: SQLDatabase!

    override static func setUp() {
        database = SQLDatabase()
        Seed(database: database).deleteAll()
        let seedCommandString =
            """
            INSERT INTO COUNTRIES
                (COUNTRY_CODE, LAT, LONG, NAME)
            VALUES
                ('HW', 1.1, 102.78, 'Hogwarts'),
                ('AW', 1.0, 102.98, 'America');
            """
        Seed(database: database).insert(seedCommandString)
    }

    func testQueryLatLong_locationNotInDatabase() {
        XCTAssertNil(SQLDatabaseTests.database.queryLatLong(name: "Singapore"))
    }

    func testQueryLatLong_locationInDatabase() {
        assertCountryExists(name: "Hogwarts", at: Coordinates(lat: 1.1, long: 102.78))
        assertCountryExists(name: "America", at: Coordinates(lat: 1.0, long: 102.98))
    }

    func testQueryAllCountries_twoCountries() {
        let countCommandString =
            """
            SELECT COUNT(*) FROM COUNTRIES
            """
        let countCommand = SQLSelect(command: countCommandString, database: SQLDatabaseTests.database.database)
        countCommand.execute()
        let count = SQLInteger.extract(from: countCommand, index: 0)
        XCTAssertEqual(count, 2)
    }

    func testQueryAllCountriesAndCoordinates() {
        guard let allCountriesDTO = SQLDatabaseTests.database.queryAllCountriesAndCoordinates() else {
            XCTFail("Should return 2 DTOs")
            return
        }
        XCTAssertEqual(allCountriesDTO.count, 2)
        XCTAssertTrue(allCountriesDTO.contains(
            CountryCoordinateDTO(name: "Hogwarts", countryCode: "HW", coordinates: Coordinates(lat: 1.1, long: 102.78)))
        )
        XCTAssertTrue(allCountriesDTO.contains(
            CountryCoordinateDTO(name: "America", countryCode: "AW", coordinates: Coordinates(lat: 1.0, long: 102.98)))
        )
    }
}

extension SQLDatabaseTests {
    func assertCountryExists(name: String, at coordinates: Coordinates) {
        XCTAssertEqual(
            SQLDatabaseTests.database.queryLatLong(name: name) ?? Coordinates(lat: 0, long: 0),
            coordinates
        )
    }

    func assertCountryDoesNotExist(name: String) {
        XCTAssertNil(SQLDatabaseTests.database.queryLatLong(name: name))
    }
}
