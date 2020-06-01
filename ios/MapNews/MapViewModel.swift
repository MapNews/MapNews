//
//  MapViewModel.swift
//  MapNews
//
//  Created by Hol Yin Ho on 30/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import GoogleMaps

class MapViewModel {
    var database: Database
    var allCountryCoordinateDTOs: [CountryCoordinateDTO]
    var allCountries: [String]? {
        database.queryAllCountries()
    }

    init() {
        database = SQLDatabase()
        allCountryCoordinateDTOs = database.queryAllCountriesAndCoordinates() ?? []
    }
}

extension MapViewModel {
    func getLatLong(for country: String) -> CLLocationCoordinate2D? {
        guard let coordinates = database.queryLatLong(name: country) else {
            return nil
        }
        return CLLocationCoordinate2D.from(coordinates: coordinates)
    }

    func getCountries(within bounds: GMSCoordinateBounds) -> [CountryCoordinateDTO] {
        return allCountryCoordinateDTOs.filter {
            bounds.contains(CLLocationCoordinate2D.from(coordinates: $0.coordinates))
        }
    }
}
