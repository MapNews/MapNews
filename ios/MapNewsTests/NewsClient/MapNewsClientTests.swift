//
//  NewsClientTests.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 7/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import XCTest

class MapNewsClientTests: XCTestCase {
    var retrieveResultsExpectation: XCTestExpectation!
    var newsClient = MapNewsClient()

    override func setUp() {
        retrieveResultsExpectation = expectation(description: "results retrieved")
    }

    func testQueryData_countryCodeIsValid() {
        newsClient.queryData(countryCode: "SG", callback: fulfillExpectationCallback(_:))
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testQueryData_countryCodeIsInvalid() {
        newsClient.queryData(countryCode: "HW", callback: noResultsCallback(_:))
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testQueryData_urlIsInvalid() {
        retrieveResultsExpectation.isInverted = true
        newsClient.queryData(countryCode: "://\\\\.,&8", callback: noResultsCallback(_:))
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testQueryData_jsonFormatIsValid() {
        newsClient.queryData(countryCode: "SG", callback: createArticleDTOCallback(_:))
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testQueryArticles_validCountryCode() {
        newsClient.queryArticles(
            country: CountryCoordinateDTO(name: "Canada", countryCode: "CA", coordinates:
                Coordinates(lat: 0.5, long: 0.9)!),
            callback: returnArticlesCallback(_:_:))
        waitForExpectations(timeout: 30, handler: nil)
    }

    func testDownloadImage_invalidUrl() {
        
    }
}

extension MapNewsClientTests {
    func fulfillExpectationCallback(_ result: Data) {
        guard let jsonObject = JSONParser.createJsonObject(from: result) else {
            XCTFail("Unable to parse to json object")
            return
        }
        guard let articles = JSONParser.getArray(from: jsonObject, key: "articles") else {
            XCTFail("Should be able to cast articles as an array")
            return
        }
        XCTAssertNotEqual(articles.count, 0)
        retrieveResultsExpectation.fulfill()
    }

    func noResultsCallback(_ result: Data) {
        guard let jsonObject = JSONParser.createJsonObject(from: result) else {
            XCTFail("Unable to parse to json object")
            return
        }
        guard let articles = JSONParser.getArray(from: jsonObject, key: "articles") else {
            XCTFail("Should be able to cast articles as an array")
            return
        }
        XCTAssertEqual(articles.count, 0)
        retrieveResultsExpectation.fulfill()
    }

    func createArticleDTOCallback(_ result: Data) {
        guard let jsonObject = JSONParser.createJsonObject(from: result) else {
            XCTFail("Unable to parse to json object")
            return
        }
        guard let articles = JSONParser.getArray(from: jsonObject, key: "articles") else {
            XCTFail("Should be able to cast articles as an array")
            return
        }
        let articleDTOs = articles.compactMap {
            ArticleDTO(jsonData: $0)
        }
        XCTAssertEqual(articles.count, articleDTOs.count)
        retrieveResultsExpectation.fulfill()
    }

    func returnArticlesCallback(_ articles: [ArticleDTO], _ country: CountryCoordinateDTO) {
        XCTAssertNotEqual(articles.count, 0)
        retrieveResultsExpectation.fulfill()
    }
}
