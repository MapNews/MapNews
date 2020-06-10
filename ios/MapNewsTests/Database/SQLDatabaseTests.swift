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
    private let hogwartsDTO = CountryCoordinateDTO(
        name: "Hogwarts",
        countryCode: "HW",
        coordinates: Coordinates(lat: 1.1, long: 102.78))
    private let americaDTO = CountryCoordinateDTO(
        name: "America",
        countryCode: "AW",
        coordinates: Coordinates(lat: 1.0, long: 102.98))

    override func setUp() {
        SQLDatabaseTests.database = SQLDatabase()
        Seed(database: SQLDatabaseTests.database).deleteAll()
        let seedCommandString =
            """
            INSERT INTO COUNTRIES
                (COUNTRY_CODE, LAT, LONG, NAME)
            VALUES
                ('HW', 1.1, 102.78, 'Hogwarts'),
                ('AW', 1.0, 102.98, 'America');
            """
        Seed(database: SQLDatabaseTests.database).insert(seedCommandString)
    }

    func testQueryLatLong_locationNotInDatabase() {
        XCTAssertNil(SQLDatabaseTests.database.queryLatLong(name: "Atlantis"))
    }

    func testQueryLatLong_locationInDatabase() {
        assertCountryExists(name: "Hogwarts", at: hogwartsDTO.coordinates)
        assertCountryExists(name: "America", at: americaDTO.coordinates)
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
        XCTAssertTrue(allCountriesDTO.contains(hogwartsDTO))
        XCTAssertTrue(allCountriesDTO.contains(americaDTO))
    }

    func testQueryCountryAndCoordinates_countriesExists() {
        guard let queryHogwartsDTO = SQLDatabaseTests.database.queryCountryDTO(name: "Hogwarts") else {
            XCTFail("Should return hogwarts DTO")
            return
        }
        XCTAssertEqual(queryHogwartsDTO, hogwartsDTO)
        guard let queryAmericaDTO = SQLDatabaseTests.database.queryCountryDTO(name: "America") else {
            XCTFail("Should return hogwarts DTO")
            return
        }
        XCTAssertEqual(queryAmericaDTO, americaDTO)
    }

    func testQueryCountryAndCoordinates_countryDoesNotExists() {
        let queryAtlantis = SQLDatabaseTests.database.queryCountryDTO(name: "Atlantis")
        XCTAssertNil(queryAtlantis)
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
