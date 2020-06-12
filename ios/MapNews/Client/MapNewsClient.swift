//
//  NewsClient.swift
//  MapNews
//
//  Created by Hol Yin Ho on 21/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import UIKit

class MapNewsClient: NewsClient {
    private static let urlString =
        "https://newsapi.org/v2/top-headlines?country=COUNTRY_CODE&pageSize=1&language=EN&apiKey="
        + Keys.newsApiKey

    func queryArticles(country: CountryCoordinateDTO,
                              callback: @escaping ([ArticleDTO], CountryCoordinateDTO) -> Void) {
        queryData(countryCode: country.countryCode) {(data) in
            guard let articles = self.convertDataToArticles(data) else {
                return
            }
            callback(articles, country)
        }
    }

    internal func queryData(countryCode: String, callback: @escaping (Data) -> Void) {
        let countryUrlString = MapNewsClient.urlString
            .replacingOccurrences(of: "COUNTRY_CODE", with: countryCode)
        guard let url = URL(string: countryUrlString) else {
            print("Url is invalid")
            return
        }
        getData(from: url) { (data, response, error) in
            guard let data = data else {
                print("Unable to access url")
                return
            }
            DispatchQueue.main.async {
                callback(data)
            }
        }
    }

    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        print("HTTP GET request to " + url.absoluteString)
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    func downloadImage(from url: URL, callback: @escaping (UIImage) -> Void) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else {
                    return
                }
                callback(image)
            }
        }
    }

    private func convertDataToArticles(_ data: Data) -> [ArticleDTO]? {
        guard let jsonObject = JSONParser.createJsonObject(from: data) else {
            return nil
        }
        guard let jsonArticles = JSONParser.getArray(from: jsonObject, key: "articles") else {
            return nil
        }
        return jsonArticles.compactMap {
            ArticleDTO(jsonData: $0)
        }
    }
}
