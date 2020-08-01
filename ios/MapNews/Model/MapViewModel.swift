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
    var currentBounds: GMSCoordinateBounds {
        didSet {
            allCountriesInBounds = allCountryCoordinateDTOs.filter {
                currentBounds.contains(CLLocationCoordinate2D.from($0.coordinates)!)
            }
        }
    }
    var allCountryNames: [String]? {
        database.queryAllCountries()
    }
    var observers: [MapViewModelObserver] = []
    var newsClient: NewsClient

    convenience init() {
        self.init(within: MapConstants.defaultBounds)
    }

    init(within bounds: GMSCoordinateBounds) {
        database = SQLDatabase()
        database.populateDatabaseWithCountries()
        allCountryCoordinateDTOs = database.queryAllCountriesAndCoordinates() ?? []
        currentBounds = bounds
        newsClient = MapNewsClient()
    }

    func updateNews(country: CountryCoordinateDTO) {
        newsClient.queryArticles(country: country, callback: getHeadline(articles:country:))
    }

    func addObserver(_ observer: MapViewModelObserver) {
        observers.append(observer)
    }
}

extension MapViewModel {
    private func getHeadline(articles: [ArticleDTO], country: CountryCoordinateDTO) {
        var article: ArticleDTO
        if articles.isEmpty {
            article = ArticleBuilder().withTitle(title: "No articles :(").build()
        } else {
            guard let latestArticle = getLatestNews(articles: articles) else {
                return
            }
            article = latestArticle
        }
        observers.forEach { $0.updateHeadlines(country: country, article: article) }
    }

    internal func getLatestNews(articles: [ArticleDTO]) -> ArticleDTO? {
        if articles.isEmpty {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let defaultDate = formatter.date(from: "01/01/2099 23:59")!
        return articles.max {
            let firstDate = $0.publishedAt ?? defaultDate
            let secondDate = $1.publishedAt ?? defaultDate
            return firstDate < secondDate
        }
    }

    func getCountryCoordinateDTO(for country: String) -> CountryCoordinateDTO? {
        return database.queryCountryDTO(name: country)
    }

    func loadImage(url: String, withImageCallback: @escaping (UIImage) -> Void, noImageCallback: () -> Void) {
        if let urlObject = URL(string: url) {
            newsClient.downloadImage(from: urlObject, callback: withImageCallback)
        } else {
            noImageCallback()
        }
    }
}
