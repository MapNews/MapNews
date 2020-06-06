//
//  Database.swift
//  MapNews
//
//  Created by Hol Yin Ho on 26/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

protocol Database {
    func queryLatLong(name: String) -> Coordinates?

    func queryAllCountries() -> [String]?

    func queryAllCountriesAndCoordinates() -> [CountryCoordinateDTO]?

    func populateDatabaseWithCountries()
}
