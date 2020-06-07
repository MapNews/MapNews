//
//  MapViewModel.swift
//  MapNews
//
//  Created by Hol Yin Ho on 30/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import GoogleMaps

class MapViewModel {
    var database: Database {
        didSet {
            allCountryCoordinateDTOs = database.queryAllCountriesAndCoordinates() ?? []
        }
    }
    var allCountryCoordinateDTOs: [CountryCoordinateDTO] = []
    var allCountriesInBounds: [CountryCoordinateDTO] = []
    var currentBounds: GMSCoordinateBounds {
        didSet {
            allCountriesInBounds = allCountryCoordinateDTOs.filter {
                currentBounds.contains(CLLocationCoordinate2D.from($0.coordinates))
            }
        }
    }
    var allCountryNames: [String]? {
        database.queryAllCountries()
    }

    convenience init() {
        self.init(within: MapConstants.defaultBounds)
    }

    init(within bounds: GMSCoordinateBounds) {
        database = SQLDatabase()
        database.clearTable()
        database.populateDatabaseWithCountries()
        allCountryCoordinateDTOs = database.queryAllCountriesAndCoordinates() ?? []
        currentBounds = bounds
        NewsClient.queryNews(at: "SG", name: "Singapore", callback: handleNews(result:))
    }
}

extension MapViewModel {
    func getLatLong(for country: String) -> CLLocationCoordinate2D? {
        guard let coordinates = database.queryLatLong(name: country) else {
            return nil
        }
        return CLLocationCoordinate2D.from(coordinates)
    }

    func handleNews(result: Data) {
        print(result)
    }
}
