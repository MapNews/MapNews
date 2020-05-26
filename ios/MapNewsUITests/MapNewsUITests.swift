//
//  MapNewsUITests.swift
//  MapNewsUITests
//
//  Created by Hol Yin Ho on 18/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import XCTest

class MapNewsUITests: XCTestCase {

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()

        let mapView = XCUIApplication()
            .children(matching: .window).element(boundBy: 1)
            .children(matching: .other).element

        XCTAssertTrue(mapView.exists)
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testTogglePickerVisibility() {
        let app = XCUIApplication()
        let mask = app.children(matching: .window)
            .element(boundBy: 0).children(matching: .other)
            .element.children(matching: .other)
            .element.children(matching: .other)
            .element.children(matching: .other)
            .element(boundBy: 0)

        app.launch()

        XCTAssertFalse(app.pickerWheels["Afghanistan"].exists)

        app.buttons["Singapore"].tap()
        XCTAssertTrue(app.pickerWheels["Afghanistan"].exists)

        app.buttons["Singapore"].tap()
        XCTAssertFalse(app.pickerWheels["Afghanistan"].exists)

        app.buttons["Singapore"].tap()
        XCTAssertTrue(app.pickerWheels["Afghanistan"].exists)

        mask.tap()
        XCTAssertFalse(app.pickerWheels["Afghanistan"].exists)
    }

}
