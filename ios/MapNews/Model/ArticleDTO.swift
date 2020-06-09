//
//  ArticleDTO.swift
//  MapNews
//
//  Created by Hol Yin Ho on 8/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

struct ArticleDTO: Equatable {
    let source: String
    let author: String
    let title: String
    let desc: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String

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
        guard let desc = JSONParser.getObject(from: jsonData, key: "description") as? String else {
            print("Unable to extract description object from " + title)
            return nil
        }
        guard let url = JSONParser.getObject(from: jsonData, key: "url") as? String else {
            print("Unable to extract url object from " + title)
            return nil
        }
        let urlToImage = JSONParser.getObject(from: jsonData, key: "urlToImage") as? String ?? "No image"
        guard let publishedAt = JSONParser.getObject(from: jsonData, key: "publishedAt") as? String else {
            print("Unable to extract publishedAt object from " + title)
            return nil
        }
        let content = JSONParser.getObject(from: jsonData, key: "content") as? String ?? "No content"

        self.source = source
        self.author = author
        self.title = title
        self.desc = desc
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
}
