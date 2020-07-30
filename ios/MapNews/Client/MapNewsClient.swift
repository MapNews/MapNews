//
//  NewsClient.swift
//  MapNews
//
//  Created by Hol Yin Ho on 21/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import UIKit

class MapNewsClient: NewsClient {
    private static let urlString = "https://newsapi.org/v2/top-headlines?"

    private func queryByCountryCode(countryCode: String) -> String {
        return RequestBuilder(baseUrl: MapNewsClient.urlString)
            .addParam(param: "country", value: countryCode.lowercased())
            .addParam(param: "apiKey", value: Keys.newsApiKey)
            .build()
    }

    private func queryByCountryName(countryName: String) -> String {
        return RequestBuilder(baseUrl: MapNewsClient.urlString)
            .addParam(param: "q", value: countryName.replacingOccurrences(of: " ", with: ""))
            .addParam(param: "apiKey", value: Keys.newsApiKey)
            .build()
    }

    func queryArticles(country: CountryCoordinateDTO,
                              callback: @escaping ([ArticleDTO], CountryCoordinateDTO) -> Void) {
        let countryCodeUrlString = queryByCountryCode(countryCode: country.countryCode)

        queryData(request: countryCodeUrlString) {(data) in
            guard let articles = self.convertDataToArticles(data) else {
                return
            }
            if articles.isEmpty {
                let countryNameUrlString = self.queryByCountryName(countryName: country.countryName)
                self.queryData(request: countryNameUrlString) {(data) in
                    guard let articles = self.convertDataToArticles(data) else {
                        return
                    }
                    callback(articles, country)
                }
            } else {
                callback(articles, country)
            }
        }
    }

    internal func queryData(request: String, callback: @escaping (Data) -> Void) {
        guard let url = URL(string: request) else {
            print("Url is invalid: " + request)
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
