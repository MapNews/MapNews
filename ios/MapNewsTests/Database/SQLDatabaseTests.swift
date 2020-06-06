//
//  SQLDatabaseTests.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 6/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import XCTest

class SQLDatabaseTests: XCTestCase {
    var database: SQLDatabase!

    override func setUp() {
        database = SQLDatabase()
        Seed(database: database).deleteAll()
    }

    func testSeeding() {
        XCTAssertNil(database.queryLatLong(name: "Hogwarts"))
        let seedCommandString =
            """
            INSERT INTO COUNTRIES (COUNTRY_CODE, LAT, LONG, NAME) VALUES ('HW', 1.1, 102.78, 'Hogwarts');
            """
        Seed(database: database).insert(seedCommandString)
        assertCountryExists(name: "Hogwarts", at: Coordinates(lat: 1.1, long: 102.78))
    }

    func testClear() {
        let seedCommandString =
            """
            INSERT INTO COUNTRIES (COUNTRY_CODE, LAT, LONG, NAME) VALUES
                ('HW', 1.1, 102.78, 'Hogwarts'),
                ('AW', 1.0, 102.98, 'America');
            """
        Seed(database: database).insert(seedCommandString)
        assertCountryExists(name: "Hogwarts", at: Coordinates(lat: 1.1, long: 102.78))
        assertCountryExists(name: "America", at: Coordinates(lat: 1.0, long: 102.98))
        let deleteCommandString =
            """
            DELETE FROM COUNTRIES WHERE COUNTRY_CODE = 'HW'
            """
        Seed(database: database).delete(deleteCommandString)
        assertCountryDoesNotExist(name: "Hogwarts")
        assertCountryExists(name: "America", at: Coordinates(lat: 1.0, long: 102.98))
    }

    func testDeleteAll() {
        let seedCommandString =
            """
            INSERT INTO COUNTRIES (COUNTRY_CODE, LAT, LONG, NAME) VALUES
                ('HW', 1.1, 102.78, 'Hogwarts'),
                ('AW', 1.0, 102.98, 'America');
            """
        Seed(database: database).insert(seedCommandString)
        assertCountryExists(name: "Hogwarts", at: Coordinates(lat: 1.1, long: 102.78))
        assertCountryExists(name: "America", at: Coordinates(lat: 1.0, long: 102.98))
        Seed(database: database).deleteAll()
        assertCountryDoesNotExist(name: "Hogwarts")
        assertCountryDoesNotExist(name: "America")
    }

    func testQueryLatLong_locationNotInDatabase() {
        XCTAssertNil(database.queryLatLong(name: "Singapore"))
    }

    func testQueryLatLong_locationInDatabase() {
        let seedCommandString =
            """
            INSERT INTO COUNTRIES (COUNTRY_CODE, LAT, LONG, NAME) VALUES
                ('HW', 1.1, 102.78, 'Hogwarts'),
                ('AW', 1.0, 102.98, 'America');
            """
        Seed(database: database).insert(seedCommandString)
        assertCountryExists(name: "Hogwarts", at: Coordinates(lat: 1.1, long: 102.78))
        assertCountryExists(name: "America", at: Coordinates(lat: 1.0, long: 102.98))
    }
}

extension SQLDatabaseTests {
    func assertCountryExists(name: String, at coordinates: Coordinates) {
        XCTAssertEqual(
            database.queryLatLong(name: name) ?? Coordinates(lat: 0, long: 0),
            coordinates
        )
    }

    func assertCountryDoesNotExist(name: String) {
        XCTAssertNil(database.queryLatLong(name: name))
    }
}
