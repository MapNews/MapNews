//
//  MapNewsUITests.swift
//  MapNewsUITests
//
//  Created by Hol Yin Ho on 18/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import XCTest

class MapNewsUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        app.launch()
    }

    func testLandingPageElementsExists() throws {
        let mapView = app.otherElements["MapNewsView"]
        XCTAssertTrue(mapView.exists)
        
        let selector = app.otherElements[Identifiers.selectorIdentifier]
        XCTAssertTrue(selector.exists)

        let textField = selector.textFields[Identifiers.textFieldIdentifier]
        XCTAssertTrue(textField.exists)

        let labelBackground = selector.otherElements[Identifiers.labelBackgroundIdentifier]
        XCTAssertTrue(labelBackground.exists)

        let searchButton = selector.images[Identifiers.searchButtonIdentifier]
        XCTAssertTrue(searchButton.exists)

        let tableView = app.tables[Identifiers.tableIdentifier]
        XCTAssertFalse(tableView.exists)
    }

    func testTapOnTextField_tableReveal() {
        let selector = app.otherElements[Identifiers.selectorIdentifier]
        let textField = selector.textFields[Identifiers.textFieldIdentifier]
        textField.tap()

        let tableView = app.tables[Identifiers.tableIdentifier]
        XCTAssertTrue(tableView.exists)
    }
}
