//
//  MapViewModel.swift
//  MapNews
//
//  Created by Hol Yin Ho on 30/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

class MapViewModel {
    var database: Database

    init() {
        database = SQLDatabase()
    }
}

extension MapViewModel {
    func getLatLong(for country: String) -> Coordinates? {
        database.queryLatLong(name: country)
    }

    func getAllCountries() -> [String]? {
        database.queryAllCountries()
    }
}
