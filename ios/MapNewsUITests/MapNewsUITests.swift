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

        let mapView = app.otherElements["MapNewsView"]
        XCTAssertTrue(mapView.exists)
        
        let selector = app.otherElements["MapNewsSelector"]
        XCTAssertTrue(selector.exists)

        let textField = selector.otherElements["selectedCountryTextField"]
        XCTAssertTrue(textField.exists)

        let labelBackground = selector.otherElements["labelBackground"]
        XCTAssertTrue(labelBackground.exists)

        let searchButton = selector.buttons["searchButton"]
        XCTAssertTrue(searchButton.exists)

        let tableView = selector.tables["tableView"]
        XCTAssertTrue(tableView.exists)
    }

}
