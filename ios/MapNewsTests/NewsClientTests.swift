//
//  NewsClientTests.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 7/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import XCTest

class NewsClientTests: XCTestCase {
    var retrieveResultsExpectation: XCTestExpectation!

    func testQueryNews_countryCodeIsValid() {
        retrieveResultsExpectation = expectation(description: "results retrieved")
        NewsClient.queryNews(at: "SG", name: "Singapore", callback: sampleCallback(_:))
        waitForExpectations(timeout: 5, handler: nil)
    }

    func sampleCallback(_ result: Data) {
        retrieveResultsExpectation.fulfill()
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: result, options: .allowFragments)
            guard let articles = JSONParser.getObject(from: jsonObject, key: "articles") as? Array<Any> else {
                XCTFail("Should be able to cast articles as an array")
                return
            }
            guard let firstArticleTitle = JSONParser.getObject(from: articles[0], key: "title") as? String else {
                XCTFail("Should be able to cast title as string")
                return
            }
            print(firstArticleTitle)
        } catch {
            print(error)
        }
    }
}
