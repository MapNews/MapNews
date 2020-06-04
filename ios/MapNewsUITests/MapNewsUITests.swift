//
//  MapNewsUITests.swift
//  MapNewsUITests
//
//  Created by Hol Yin Ho on 18/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import XCTest

class MapNewsUITests: XCTestCase {

    func testLandingPageElementsExists() throws {
        let app = XCUIApplication()
        app.launch()

        let mapView = app.children(matching: .window).element(boundBy: 1)
            .children(matching: .other).element

        XCTAssertTrue(mapView.exists)

        let selector = app.children(matching: .window).element(boundBy: 0)
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element

        let textField = selector.children(matching: .other).element
            .children(matching: .textField).element

        XCTAssertTrue(textField.exists)

        let searchButton = selector.children(matching: .other).element(boundBy: 0)
        XCTAssertTrue(searchButton.exists)
    }

}
