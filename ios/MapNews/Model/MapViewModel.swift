//
//  MapViewModel.swift
//  MapNews
//
//  Created by Hol Yin Ho on 30/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import GoogleMaps

class MapViewModel: Model {
    var database: Database {
        didSet {
            allCountryCoordinateDTOs = database.queryAllCountriesAndCoordinates() ?? []
        }
    }
    var allCountryCoordinateDTOs: [CountryCoordinateDTO] = []
    var allCountriesInBounds: [CountryCoordinateDTO] = []
    var countryToHeadlineMap: [CountryCoordinateDTO: ArticleDTO] = [:]
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
    var observers: [MapViewModelObserver] = []

    convenience init() {
        self.init(within: MapConstants.defaultBounds)
    }

    init(within bounds: GMSCoordinateBounds) {
        database = SQLDatabase()
        database.populateDatabaseWithCountries()
        allCountryCoordinateDTOs = database.queryAllCountriesAndCoordinates() ?? []
        currentBounds = bounds
    }

    func updateNews(country: CountryCoordinateDTO) {
        NewsClient.queryArticles(country: country, callback: getHeadline(articles:country:))
    }

    func addObserver(_ observer: MapViewModelObserver) {
        observers.append(observer)
    }
}

extension MapViewModel {
    func getHeadline(articles: [ArticleDTO], country: CountryCoordinateDTO) {
        if articles.count == 0 {
            return
        }
        countryToHeadlineMap[country] = articles[0]
        observers.forEach { $0.updateHeadlines(country: country, article: articles[0]) }
    }

    func getCountryCoordinateDTO(for country: String) -> CountryCoordinateDTO? {
        return database.queryCountryDTO(name: country)
    }
}
