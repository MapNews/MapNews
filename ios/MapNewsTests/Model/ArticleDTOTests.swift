//
//  ArticleDTOTests.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 8/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import XCTest

class ArticleDTOTests: XCTestCase {
    static let author = "Michael Yong"
    static let title = "Doctors in Singapore advised to look out for blood, heart problems in COVID-19 patients - CNA"
    static let desc = "Four COVID-19 cases in Singapore died in May because of heart-related issues, and not of the disease."
    static let url = "https://www.channelnewsasia"
        + ".com/news/singapore/covid-19-cases-singapore-heart-issues-blood-doctors-12805406"
    static let urlToImage = "https://cna-sg-res.cloudinary"
        + ".com/image/upload/q_auto,f_auto/image/12668676/16x9/"
        + "991/557/eee906a31bd1bd1a3972c22d1ddd4f2/pQ/coronavirus-cells.jpg"
    static let publishedAt = "2020-06-08T00:12:07Z"
    static let content = "SINGAPORE: Doctors in Singapore have been advised to be watchful for cardiovascular symptoms "
        + "in COVID-19 patients, with emerging data globally about the increased risks of blood clots ..."

    let dataWithAuthorWithContent: Any = [
            "source": ["id": nil, "name": "CNA"],
            "author": author,
            "title": title,
            "description": desc,
            "url": url,
            "urlToImage": urlToImage,
            "publishedAt": publishedAt,
            "content": content
    ]

    let dataNoAuthor: Any = [
        "source": ["id": nil, "name": "CNA"],
        "author": nil,
        "title": title,
        "description": desc,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt,
        "content": content
    ]

    let dataNoContent: Any = [
        "source": ["id": nil, "name": "CNA"],
        "author": author,
        "title": title,
        "description": desc,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt,
        "content": nil
    ]

    let dataNoAuthorNoContent: Any = [
        "source": ["id": nil, "name": "CNA"],
        "author": nil,
        "title": title,
        "description": desc,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt,
        "content": nil
    ]

    let dataNoUrlToImage: Any = [
        "source": ["id": nil, "name": "CNA"],
        "author": author,
        "title": title,
        "description": desc,
        "url": url,
        "urlToImage": nil,
        "publishedAt": publishedAt,
        "content": content
    ]

    let dataNoDescription: Any = [
        "source": ["id": nil, "name": "CNA"],
        "author": author,
        "title": title,
        "description": nil,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt,
        "content": content
    ]

    func testInit_noTitleObject() {
        let jsonData: Any = "Test"
        let article = ArticleDTO(jsonData: jsonData)
        XCTAssertNil(article)
    }

    func testInit_noSourceObject() {
        let jsonData: Any = [
            "title": "sampleTitle"
        ]
        let article = ArticleDTO(jsonData: jsonData)
        XCTAssertNil(article)
    }

    func testInit_noSourceNameObject() {
        let jsonData: Any = [
            "title": "sampleTitle",
            "source": "no name"
        ]
        let article = ArticleDTO(jsonData: jsonData)
        XCTAssertNil(article)
    }

    func testInit_noUrlObject() {
        let jsonData: Any = [
            "title": "sampleTitle",
            "source": ["name": "CNA"]
        ]
        let article = ArticleDTO(jsonData: jsonData)
        XCTAssertNil(article)
    }

    func testInit_noPublishedTimeObject() {
        let jsonData: Any = [
            "title": "sampleTitle",
            "source": ["name": "CNA"],
            "url": "www.google.com"
        ]
        let article = ArticleDTO(jsonData: jsonData)
        XCTAssertNil(article)
    }

    func testInit_nonNullElements_allPresent() {
        let jsonData: Any = [
            "title": "sampleTitle",
            "source": ["name": "CNA"],
            "url": "www.google.com",
            "publishedAt": "today"
        ]
        let article = ArticleDTO(jsonData: jsonData)
        XCTAssertNotNil(article)
    }

    func testInit_withAuthor_withContent() {
        guard let sampleArticle = ArticleDTO(jsonData: dataWithAuthorWithContent) else {
            XCTFail("Should be able to create article DTO from jsonobject")
            return
        }
        XCTAssertEqual(sampleArticle.author, ArticleDTOTests.author)
        XCTAssertEqual(sampleArticle.title, ArticleDTOTests.title)
        XCTAssertEqual(sampleArticle.desc, ArticleDTOTests.desc)
        XCTAssertEqual(sampleArticle.url, ArticleDTOTests.url)
        XCTAssertEqual(sampleArticle.publishedAt, TimeUtil.toDate(ArticleDTOTests.publishedAt))
        XCTAssertEqual(sampleArticle.content, ArticleDTOTests.content)
    }

    func testInit_noAuthor_withContent() {
        guard let sampleArticle = ArticleDTO(jsonData: dataNoAuthor) else {
            XCTFail("Should be able to create article DTO from jsonobject")
            return
        }
        XCTAssertEqual(sampleArticle.author, "No author")
        XCTAssertEqual(sampleArticle.title, ArticleDTOTests.title)
        XCTAssertEqual(sampleArticle.desc, ArticleDTOTests.desc)
        XCTAssertEqual(sampleArticle.url, ArticleDTOTests.url)
        XCTAssertEqual(sampleArticle.publishedAt, TimeUtil.toDate(ArticleDTOTests.publishedAt))
        XCTAssertEqual(sampleArticle.content, ArticleDTOTests.content)
    }

    func testInit_withAuthor_noContent() {
        guard let sampleArticle = ArticleDTO(jsonData: dataNoContent) else {
            XCTFail("Should be able to create article DTO from jsonobject")
            return
        }
        XCTAssertEqual(sampleArticle.author, ArticleDTOTests.author)
        XCTAssertEqual(sampleArticle.title, ArticleDTOTests.title)
        XCTAssertEqual(sampleArticle.desc, ArticleDTOTests.desc)
        XCTAssertEqual(sampleArticle.url, ArticleDTOTests.url)
        XCTAssertEqual(sampleArticle.publishedAt, TimeUtil.toDate(ArticleDTOTests.publishedAt))
        XCTAssertEqual(sampleArticle.content, "No content")
    }

    func testInit_noAuthor_noContent() {
        guard let sampleArticle = ArticleDTO(jsonData: dataNoAuthorNoContent) else {
            XCTFail("Should be able to create article DTO from jsonobject")
            return
        }
        XCTAssertEqual(sampleArticle.author, "No author")
        XCTAssertEqual(sampleArticle.title, ArticleDTOTests.title)
        XCTAssertEqual(sampleArticle.desc, ArticleDTOTests.desc)
        XCTAssertEqual(sampleArticle.url, ArticleDTOTests.url)
        XCTAssertEqual(sampleArticle.publishedAt, TimeUtil.toDate(ArticleDTOTests.publishedAt))
        XCTAssertEqual(sampleArticle.content, "No content")
    }

    func testInit_noUrlToImage(){
        guard let sampleArticle = ArticleDTO(jsonData: dataNoUrlToImage) else {
            XCTFail("Should be able to create article DTO from jsonobject")
            return
        }
        XCTAssertEqual(sampleArticle.author, ArticleDTOTests.author)
        XCTAssertEqual(sampleArticle.title, ArticleDTOTests.title)
        XCTAssertEqual(sampleArticle.desc, ArticleDTOTests.desc)
        XCTAssertEqual(sampleArticle.url, ArticleDTOTests.url)
        XCTAssertEqual(sampleArticle.publishedAt, TimeUtil.toDate(ArticleDTOTests.publishedAt))
        XCTAssertEqual(sampleArticle.content, ArticleDTOTests.content)
    }

    func testInit_noDescription(){
        guard let sampleArticle = ArticleDTO(jsonData: dataNoDescription) else {
            XCTFail("Should be able to create article DTO from jsonobject")
            return
        }
        XCTAssertEqual(sampleArticle.author, ArticleDTOTests.author)
        XCTAssertEqual(sampleArticle.title, ArticleDTOTests.title)
        XCTAssertEqual(sampleArticle.desc, "No description")
        XCTAssertEqual(sampleArticle.url, ArticleDTOTests.url)
        XCTAssertEqual(sampleArticle.publishedAt, TimeUtil.toDate(ArticleDTOTests.publishedAt))
        XCTAssertEqual(sampleArticle.content, ArticleDTOTests.content)
    }

    func testEqual() {
        let jsonData1: Any = [
            "title": "sampleTitle",
            "source": ["name": "CNA"],
            "url": "www.google.com",
            "publishedAt": "today"
        ]
        let jsonData2: Any = [
            "title": "sampleTitle",
            "source": ["name": "CNA"],
            "url": "www.google.com",
            "publishedAt": "today"
        ]
        let article1 = ArticleDTO(jsonData: jsonData1)
        let article2 = ArticleDTO(jsonData: jsonData2)
        XCTAssertEqual(article1, article2)
    }
}
