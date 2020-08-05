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

    var database: OpaquePointer?

    private let path = Bundle.main.path(forResource: filename, ofType: fileType)

    init() {
        openDatabaseConnection()
        if countriesTableExists() {
            return
        }
        createTable()
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
        let insertCoordinatesCommand = SQLInsert(command: Commands.insertCoordinatesStatementString, database: database)
        let insertNamesCommand = SQLInsert(command: Commands.insertNamesStatementString, database: database)
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
            insertCoordinatesCommand.with(argument: SQLString(argument: country_code)!, index: 1)
                .with(argument: SQLDouble(argument: lat)!, index: 2)
                .with(argument: SQLDouble(argument: long)!, index: 3)
                .execute()
            insertNamesCommand.with(argument: SQLString(argument: country_code)!, index: 1)
                .with(argument: SQLString(argument: name)!, index: 2)
                .execute()

            insertCoordinatesCommand.reset()
            insertNamesCommand.reset()
        }
        insertCoordinatesCommand.tearDown()
        insertNamesCommand.tearDown()
    }

    private func createTable() {
        let createCoordinatesTableCommand =
            SQLCreate(command: Commands.createCoordinatesTableString, database: database)
        createCoordinatesTableCommand.execute()
        createCoordinatesTableCommand.tearDown()

        let createNamesTableCommand =
            SQLCreate(command: Commands.createNamesTableString, database: database)
        createNamesTableCommand.execute()
        createNamesTableCommand.tearDown()
    }
}

extension SQLDatabase: Database {
    func queryLatLong(name: String) -> Coordinates? {
        let command = SQLSelect(command: Commands.queryCountryStatementString, database: database)
            .with(argument: SQLString(argument: name)!, index: 1)
        command.execute()
        if command.isNullable {
            return nil
        }

        let queryLat = SQLDouble.extract(from: command, index: 0)
        let queryLong = SQLDouble.extract(from: command, index: 1)

        let invalidLatLong = queryLat == 0 && queryLong == 0

        command.tearDown()
        return invalidLatLong ? nil : Coordinates(lat: queryLat, long: queryLong)
    }

    func queryCountryDTO(name: String) -> CountryCoordinateDTO? {
        let command = SQLSelect(command: Commands.queryCountryCoordinateDTOStatementString, database: database)
            .with(argument: SQLString(argument: name)!, index: 1)
        command.execute()
        if command.isNullable {
            return nil
        }

        let countryCode = SQLString.extract(from: command, index: 0)
        let queryLat = SQLDouble.extract(from: command, index: 1)
        let queryLong = SQLDouble.extract(from: command, index: 2)

        let invalidLatLong = queryLat == 0 && queryLong == 0
        command.tearDown()
        guard let coordinates = Coordinates(lat: queryLat, long: queryLong) else {
            return nil
        }
        return invalidLatLong
            ? nil
            : CountryCoordinateDTO(name: name, countryCode: countryCode, coordinates: coordinates)
    }

    func queryAllCountries() -> [String]? {
        var countries: [String] = []
        let command = SQLSelect(command: Commands.queryCountriesStatementString, database: database)
        command.execute()
        while !command.isNullable {
            countries.append(SQLString.extract(from: command, index: 0))
            command.execute()
        }
        command.tearDown()
        return countries
    }

    func queryAllCountriesAndCoordinates() -> [CountryCoordinateDTO]? {
        var countryCoordinatesDTOs: [CountryCoordinateDTO] = []
        let command = SQLSelect(command: Commands.queryAllCountryCoordinateDTOStatementString, database: database)
        command.execute()
        while !command.isNullable {
            let countryCode = SQLString.extract(from: command, index: 0)
            let country = SQLString.extract(from: command, index: 1)
            let lat = SQLDouble.extract(from: command, index: 2)
            let long = SQLDouble.extract(from: command, index: 3)
            guard let coordinates = Coordinates(lat: lat, long: long) else {
                return nil
            }
            let currentDTO = CountryCoordinateDTO(name: country, countryCode: countryCode, coordinates: coordinates)
            countryCoordinatesDTOs.append(currentDTO)
            command.execute()
        }
        command.tearDown()
        return countryCoordinatesDTOs
    }

    func queryDefaultLocation() -> String? {
        let command = SQLSelect(command: Commands.queryDefaultLocationString, database: database)
        command.execute()
        if command.isNullable {
            return nil
        }
        let name = SQLString.extract(from: command, index: 0)
        command.tearDown()
        return name
    }

    func setDefaultLocation(to name: String) {
        let deleteCommand = SQLDelete(command: Commands.deleteDefaultLocationString, database: database)
        deleteCommand.execute()
        if deleteCommand.isNullable {
            // nothing deleted means table does not exist
            let createCommand = SQLCreate(command: Commands.createConfigTableString, database: database)
            createCommand.execute()
            createCommand.tearDown()
        }
        deleteCommand.tearDown()
        guard let countryDTO = queryCountryDTO(name: name) else {
            return
        }

        let insertCommand = SQLInsert(command: Commands.insertDefaultLocationString, database: database)
        insertCommand.with(argument: SQLString(argument: countryDTO.countryName)!, index: 1)
            .execute()

        insertCommand.reset()
        insertCommand.tearDown()
    }

    func populateDatabaseWithCountries() {
        guard let countries = readCsvIntoArray(from: path!) else {
            return
        }
        let countCommand = SQLSelect(command: Commands.countCommandString, database: database)
        countCommand.execute()
        if countCommand.isNullable {
            return
        }
        let noOfEntries = SQLInteger.extract(from: countCommand, index: 0)
        countCommand.tearDown()
        if noOfEntries == 244 {
            // Already populated
            print("Table already populated")
            return
        }
        clearTable()
        populateTable(countries: countries)
    }

    func clearTable() {
        Seed(database: self).deleteAll()
    }
}
