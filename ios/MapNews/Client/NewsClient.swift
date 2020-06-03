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

    static func queryNews(at countryCode: String, name: String) {
        let countryUrlString = urlString
            .replacingOccurrences(of: "COUNTRY_CODE", with: countryCode)
            .replacingOccurrences(of: "NAME", with: name)
        guard let url = URL(string: countryUrlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }

        task.resume()
    }

}
