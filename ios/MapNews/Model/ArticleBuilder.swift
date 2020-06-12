//
//  ArticleBuilder.swift
//  MapNews
//
//  Created by Hol Yin Ho on 11/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import UIKit

class ArticleBuilder {
    var source = ""
    var author = ""
    var title = ""
    var desc = ""
    var url = ""
    var publishedAt = ""
    var content = ""
    var urlToImage: String?

    func withSource(source: String) -> ArticleBuilder {
        self.source = source
        return self
    }

    func withAuthor(author: String) -> ArticleBuilder {
        self.author = author
        return self
    }

    func withTitle(title: String) -> ArticleBuilder {
        self.title = title
        return self
    }

    func withDesc(desc: String) -> ArticleBuilder {
        self.desc = desc
        return self
    }

    func withUrl(url: String) -> ArticleBuilder {
        self.url = url
        return self
    }

    func withPublishedTime(time: String) -> ArticleBuilder {
        self.publishedAt = time
        return self
    }

    func withContent(content: String) -> ArticleBuilder {
        self.content = content
        return self
    }

    func withUrlToImage(url: String) -> ArticleBuilder {
        self.urlToImage = url
        return self
    }

    func build() -> ArticleDTO {
        let jsonData: Any = [
            "source": ["id": nil, "name": source],
            "author": author,
            "title": title,
            "description": desc,
            "url": url,
            "urlToImage": urlToImage as Any,
            "publishedAt": publishedAt,
            "content": content
        ]
        return ArticleDTO(jsonData: jsonData)!
    }
}
