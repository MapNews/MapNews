//
//  ArticleDTO.swift
//  MapNews
//
//  Created by Hol Yin Ho on 8/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import UIKit

class ArticleDTO {
    let source: String
    let author: String
    let title: String
    let desc: String
    let url: String
    let publishedAt: Date?
    let publishedAtString: String
    let content: String
    let urlToImage: String?


    init?(jsonData: Any) {
        guard let title = JSONParser.getObject(from: jsonData, key: "title") as? String else {
            print("Unable to extract title object")
            return nil
        }
        guard let sourceObject = JSONParser.getObject(from: jsonData, key: "source") else {
            print("Unable to extract source object from " + title)
            return nil
        }
        guard let source = JSONParser.getObject(from: sourceObject, key: "name") as? String else {
            print("Unable to extract name object from " + title)
            return nil
        }
        let author = JSONParser.getObject(from: jsonData, key: "author") as? String ?? "No author"
        let desc = JSONParser.getObject(from: jsonData, key: "description") as? String ?? "No description"
        guard let url = JSONParser.getObject(from: jsonData, key: "url") as? String else {
            print("Unable to extract url object from " + title)
            return nil
        }
        guard let publishedDate = JSONParser.getObject(from: jsonData, key: "publishedAt") as? String else {
            print("Unable to extract publishedAt object from " + title)
            return nil
        }
        let content = JSONParser.getObject(from: jsonData, key: "content") as? String ?? "No content"

        self.source = source
        self.author = author
        self.title = title
        self.desc = desc
        self.url = url
        self.urlToImage = JSONParser.getObject(from: jsonData, key: "urlToImage") as? String
        self.publishedAtString = publishedDate
        publishedAt = ArticleDTO.toDate(publishedAt: publishedDate)
        self.content = content
    }

}

extension ArticleDTO: Equatable {
    static func == (lhs: ArticleDTO, rhs: ArticleDTO) -> Bool {
        lhs.source == rhs.source
            && lhs.author == rhs.author
            && lhs.title == rhs.title
            && lhs.desc == rhs.desc
            && lhs.url == rhs.url
            && lhs.publishedAt == rhs.publishedAt
            && lhs.content == rhs.content
    }

    static func toDate(publishedAt: String) -> Date? {
        if publishedAt.count != 20 {
            return nil
        }
        guard let year = publishedAt.substring(0, 4) else {
            return nil
        }
        guard let month = publishedAt.substring(5, 7) else {
            return nil
        }
        guard let day = publishedAt.substring(8, 10) else {
            return nil
        }
        guard let hour = publishedAt.substring(11, 13) else {
            return nil
        }
        guard let minute = publishedAt.substring(14, 16) else {
            return nil
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.date(from: "\(day)/\(month)/\(year) \(hour):\(minute)")
    }
}
