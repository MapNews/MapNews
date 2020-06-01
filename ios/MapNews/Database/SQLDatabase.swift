//
//  SQLDatabase.swift
//  MapNews
//
//  Created by Hol Yin Ho on 25/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import Foundation
import SQLite3

class SQLDatabase {
    static let filename = "coordinates"
    static let fileType = "txt"

    static private let SqliteTransient = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

    private let createTableString =
    """
    CREATE TABLE IF NOT EXISTS COUNTRIES(
    COUNTRY_CODE STRING,
    LAT DOUBLE,
    LONG DOUBLE,
    NAME STRING);
    """

    private let queryCountryStatementString =
    """
    SELECT LAT, LONG FROM COUNTRIES
    WHERE NAME = ?;
    """

    private let queryCountryCoordinateDTOStatementString =
    """
    SELECT NAME, LAT, LONG FROM COUNTRIES
    """

    private let insertStatementString =
    """
    INSERT INTO COUNTRIES (COUNTRY_CODE, LAT, LONG, NAME) VALUES (?, ?, ?, ?);
    """

    private let queryCountriesStatementString =
    """
    SELECT NAME FROM COUNTRIES
    ORDER BY NAME
    """

    private var database: OpaquePointer?

    private let path = Bundle.main.path(forResource: filename, ofType: fileType)

    init() {
        openDatabaseConnection()
        if countriesTableExists() {
            return
        }
        createTable()
        guard let countries = readCsvIntoArray(from: path!) else {
            return
        }
        populateTable(countries: countries)
    }

    private func readCsvIntoArray(from path: String) -> [String]? {
        do {
            let result = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            return result.components(separatedBy: "\n")
        } catch {
            print("unable to read csv file")
            return nil
        }
    }

    private func countriesTableExists() -> Bool {
        guard let singaporeCoordinates = queryLatLong(name: "Singapore") else {
            return false
        }
        return singaporeCoordinates != Coordinates(lat: 0, long: 0)
    }

    private func openDatabaseConnection() {
        guard let fileUrl = getFileURL(filename: "coordinates") else {
            return
        }
        database = openDatabase(fileURL: fileUrl)
    }

    private func getFileURL(filename: String) -> URL? {
        do {
            return try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false)
                .appendingPathComponent(filename + ".sqlite")
        } catch {
            print("Error in getting url")
            return nil
        }
    }

    private func openDatabase(fileURL: URL) -> OpaquePointer? {
        var database: OpaquePointer?
        if sqlite3_open(fileURL.path, &database) != SQLITE_OK {
            print("error opening database")
            return nil
        }
        print("Successfully opened connection to database at \(fileURL.path)")
        return database
    }

    private func populateTable(countries: [String]) {
        var insertStatement: OpaquePointer?

        if sqlite3_prepare_v2(database, insertStatementString, -1, &insertStatement, nil) != SQLITE_OK {
            print("INSERT statement is not prepared")
            return
        }

        for country in countries {
            let countryArray = country.components(separatedBy: ",")
            if countryArray.count != 4 {
                return
            }
            let country_code = countryArray[0]
            guard let lat = Double(countryArray[1]) else {
                return
            }
            guard let long = Double(countryArray[2]) else {
                return
            }
            let name = countryArray[3]
            sqlite3_bind_text(insertStatement, 1, country_code, -1, nil)
            sqlite3_bind_double(insertStatement, 2, lat)
            sqlite3_bind_double(insertStatement, 3, long)
            sqlite3_bind_text(insertStatement, 4, name, -1, nil)

            if sqlite3_step(insertStatement) != SQLITE_DONE {
                print("Error inserting country")
                return
            }
            sqlite3_reset(insertStatement)
        }
        print("Successfully saved all countries")
        sqlite3_finalize(insertStatement)
    }

    private func createTable() {
        var createTableStatement: OpaquePointer?

        if sqlite3_prepare_v2(database, createTableString, -1, &createTableStatement, nil) != SQLITE_OK {
            print("CREATE statement is not prepared")
            return
        }
        if sqlite3_step(createTableStatement) != SQLITE_DONE {
            print("Table was not created")
            return
        }
        print("Table created")
        sqlite3_finalize(createTableStatement)
        return
    }
}

extension SQLDatabase: Database {
    func queryLatLong(name: String) -> Coordinates? {
        var queryStatement: OpaquePointer?
        var result: Coordinates?
        if sqlite3_prepare_v2(database, queryCountryStatementString, -1, &queryStatement, nil) != SQLITE_OK {
            print("Query not prepared")
            return nil
        }
        if sqlite3_bind_text(queryStatement, 1, name, -1, SQLDatabase.SqliteTransient) != SQLITE_OK {
            print("Statement not binded")
            return nil
        }

        if sqlite3_step(queryStatement) == SQLITE_ROW {
            let queryLat = sqlite3_column_double(queryStatement, 0)
            let queryLong = sqlite3_column_double(queryStatement, 1)

            result = Coordinates(lat: queryLat, long: queryLong)
        }
        sqlite3_finalize(queryStatement)
        return result
    }

    func queryAllCountries() -> [String]? {
        var countries: [String] = []
        var queryCountriesStatement: OpaquePointer?
        if sqlite3_prepare_v2(database, queryCountriesStatementString, -1, &queryCountriesStatement, nil) != SQLITE_OK {
            print("Query not prepared")
            return nil
        }
        while sqlite3_step(queryCountriesStatement) == SQLITE_ROW {
            guard let country = sqlite3_column_text(queryCountriesStatement, 0) else {
                return nil
            }
            countries.append(String(cString: country))
        }
        sqlite3_finalize(queryCountriesStatement)
        return countries
    }

    func queryAllCountriesAndCoordinates() -> [CountryCoordinateDTO]? {
        var countryCoordinatesDTOs: [CountryCoordinateDTO] = []
        var queryCountryCoordinateDTOStatement: OpaquePointer?
        if sqlite3_prepare_v2(
            database,
            queryCountryCoordinateDTOStatementString,
            -1,
            &queryCountryCoordinateDTOStatement,
            nil) != SQLITE_OK {
            print("Query not prepared")
            return nil
        }
        while sqlite3_step(queryCountryCoordinateDTOStatement) == SQLITE_ROW {
            guard let country = sqlite3_column_text(queryCountryCoordinateDTOStatement, 0) else {
                return nil
            }
            let queryLat = sqlite3_column_double(queryCountryCoordinateDTOStatement, 1)
            let queryLong = sqlite3_column_double(queryCountryCoordinateDTOStatement, 2)
            let currentDTO = CountryCoordinateDTO(
                name: String(cString: country),
                coordinates: Coordinates(lat: queryLat, long: queryLong)
            )
            countryCoordinatesDTOs.append(currentDTO)
        }
        return countryCoordinatesDTOs
    }
}
