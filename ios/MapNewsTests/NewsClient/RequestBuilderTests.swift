//
//  RequestBuilderTests.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 27/7/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import XCTest

class RequestBuilderTests: XCTestCase {
    let baseUrl = "https://gnews.io/api/v3/search?"
    var requestBuilder: RequestBuilder!

    override func setUp() {
        requestBuilder = RequestBuilder(baseUrl: baseUrl)
    }

    func testInit() {
        XCTAssertEqual(requestBuilder.baseUrl, baseUrl)
    }

    func testAddParam() {
        let newRequestBuilder = requestBuilder.addParam(param: "test", value: "testParam")
        XCTAssertEqual(newRequestBuilder.params[0].0, "test")
        XCTAssertEqual(newRequestBuilder.params[0].1, "testParam")
        XCTAssertEqual(newRequestBuilder.params.count, 1)
    }

    func testBuild() {
        let requestString = requestBuilder
            .addParam(param: "q", value: "example")
            .addParam(param: "token", value: "abcde")
            .build()
        let expectedString = "https://gnews.io/api/v3/search?q=example&token=abcde"
        XCTAssertEqual(requestString, expectedString)
    }
}
