//
//  NewsClient.swift
//  MapNews
//
//  Created by Hol Yin Ho on 21/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import Foundation

class NewsClient {
    static let urlString = "https://newsapi.org/v2/top-headlines?country=COUNTRY_CODE&apiKey="
        + Keys.newsApiKey

    static func queryArticles(country: CountryCoordinateDTO,
                              callback: @escaping ([ArticleDTO], CountryCoordinateDTO) -> Void) {
        queryData(countryCode: country.countryCode) {(data) in
            guard let articles = convertDataToArticles(data) else {
                return
            }
            callback(articles, country)
        }
    }

    internal static func queryData(countryCode: String, callback: @escaping (Data) -> Void) {
        let countryUrlString = urlString
            .replacingOccurrences(of: "COUNTRY_CODE", with: countryCode)
        guard let url = URL(string: countryUrlString) else {
            print("Url is invalid")
            return
        }
        print("HTTP GET request to " + countryUrlString)
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                print("Unable to access url")
                return
            }
            DispatchQueue.main.async {
                callback(data)
            }
        }
        task.resume()
    }

    private static func convertDataToArticles(_ data: Data) -> [ArticleDTO]? {
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
