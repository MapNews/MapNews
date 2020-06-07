//
//  NewsClient.swift
//  MapNews
//
//  Created by Hol Yin Ho on 21/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import Foundation

class NewsClient {
    static let urlString = "https://newsapi.org/v2/top-headlines?country=COUNTRY_CODE&q=NAME&apiKey="
        + Keys.newsApiKey

    static func queryNews(at countryCode: String, name: String, callback: @escaping (Data) -> Void) {
        let countryUrlString = urlString
            .replacingOccurrences(of: "COUNTRY_CODE", with: countryCode)
            .replacingOccurrences(of: "NAME", with: name)
        guard let url = URL(string: countryUrlString) else {
            print("Url is invalid")
            return
        }
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                print("Unable to access url")
                return
            }
            callback(data)
        }
        task.resume()
    }

}
