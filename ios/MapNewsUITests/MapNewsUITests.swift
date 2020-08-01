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
    var mapView: XCUIElement!
    var selector: XCUIElement!
    var textField: XCUIElement!
    var labelBackground: XCUIElement!
    var searchButton: XCUIElement!
    var tableView: XCUIElement!
    var locationMask: XCUIElement!

    override func setUp() {
        app = XCUIApplication()
        app.launch()
        mapView = app.otherElements[Identifiers.mapNewsIdentifier]
        selector = app.otherElements[Identifiers.selectorIdentifier]
        textField = selector.textFields[Identifiers.textFieldIdentifier]
        labelBackground = selector.otherElements[Identifiers.labelBackgroundIdentifier]
        searchButton = selector.buttons[Identifiers.searchButtonIdentifier]
        tableView = app.tables[Identifiers.tableIdentifier]
        locationMask = app.otherElements[Identifiers.locationMaskIdentifier]
    }

    func testLandingPageElementsExists() throws {
        XCTAssertTrue(mapView.exists)
        XCTAssertTrue(selector.exists)
        XCTAssertTrue(textField.exists)
        XCTAssertTrue(labelBackground.exists)
        XCTAssertTrue(searchButton.exists)
        XCTAssertFalse(tableView.exists)
        XCTAssertFalse(locationMask.exists)
    }

    func testTapOnTextField_tableReveal() {
        textField.tap()

        XCTAssertTrue(tableView.exists)
        XCTAssertTrue(locationMask.exists)
    }

    func testTapOnSearchButton_tableReveal() {
        searchButton.tap()

        XCTAssertTrue(tableView.exists)
    }

    func testTableExist_tapOnSearchButton_tableShouldHide() {
        textField.tap()

        searchButton.tap()
        XCTAssertFalse(tableView.exists)
    }

    func testTableExist_tapOutside_tableShouldHide() {
        textField.tap()

        locationMask.tap()
        XCTAssertFalse(tableView.exists)
    }

    func testAutocomplete_startsWith_Se_lastKeyE() {
        textField.tap()
        textField.clearAndEnterText(text: "Se")

        let cell0 = tableView.cells[Identifiers.generateCellIdentifier(index: 0)]
        let cell1 = tableView.cells[Identifiers.generateCellIdentifier(index: 1)]
        let cell2 = tableView.cells[Identifiers.generateCellIdentifier(index: 2)]

        XCTAssertTrue(cell0.staticTexts["Senegal"].exists)
        XCTAssertTrue(cell1.staticTexts["Serbia"].exists)
        XCTAssertTrue(cell2.staticTexts["Seychelles"].exists)
    }

    func testAutocomplete_startsWith_Se_lastKeyBackspace() {
        textField.tap()
        textField.clearAndEnterText(text: "Sen")
        textField.tapFunctionKey(key: .delete)

        let cell0 = tableView.cells[Identifiers.generateCellIdentifier(index: 0)]
        let cell1 = tableView.cells[Identifiers.generateCellIdentifier(index: 1)]
        let cell2 = tableView.cells[Identifiers.generateCellIdentifier(index: 2)]

        XCTAssertTrue(cell0.staticTexts["Senegal"].exists)
        XCTAssertTrue(cell1.staticTexts["Serbia"].exists)
        XCTAssertTrue(cell2.staticTexts["Seychelles"].exists)
    }

    func testSearchCountryinSearchBar_mapNavigateToCountry_infoWindowDisplayed() {
        let sampleCountry = "Canada"
        textField.tap()
        textField.clearAndEnterText(text: sampleCountry)
        performActionAndWait(action: { () -> Void in searchButton.tap() }, timeout: 3)

        let canadaInfoWindow = app.otherElements[Identifiers.generateInfoWindowIdentifier(country: sampleCountry)]

        XCTAssertTrue(canadaInfoWindow.exists)
    }

    func testSelectCountryFromTable_mapNavigateToCountry_infoWindowDisplayed() {
        let sampleCountry = "Canada"
        textField.tap()
        textField.clearAndEnterText(text: sampleCountry)
        let canadaCell = tableView.cells[Identifiers.generateCellIdentifier(index: 0)]
        performActionAndWait(action: { () -> Void in canadaCell.tap() }, timeout: 3)

        let canadaInfoWindow = app.otherElements[Identifiers.generateInfoWindowIdentifier(country: sampleCountry)]

        XCTAssertTrue(canadaInfoWindow.exists)
    }

    func testTapReturnButton_mapNavigateToCountry_infoWindowDisplayed() {
        let sampleCountry = "Canada"
        textField.tap()
        textField.clearAndEnterText(text: sampleCountry)
        performActionAndWait(action: { () -> Void in textField.tapFunctionKey(key: .return) }, timeout: 3)

        let canadaInfoWindow = app.otherElements[Identifiers.generateInfoWindowIdentifier(country: sampleCountry)]

        XCTAssertEqual(textField.value as? String, sampleCountry)
        XCTAssertTrue(canadaInfoWindow.exists)
    }

    func testDefaultLocation_Singapore() {
        let defaultCountry = "Singapore"
        XCTAssertEqual(textField.value as? String, defaultCountry)
        let controller = app.otherElements[Identifiers.mapViewControllerIdentifier]
        let singaporeMarker = controller.buttons[Identifiers.generateMarkerIdentifer(country: defaultCountry)]

        XCTAssertTrue(singaporeMarker.exists)
    }

    func testClickOnMarker_InfoWindowDisplayed() {
        let sampleCountry = "Singapore"
        tap(onMarker: sampleCountry)

        let singaporeInfoWindow = app.otherElements[Identifiers.generateInfoWindowIdentifier(country: sampleCountry)]
        XCTAssertTrue(singaporeInfoWindow.exists)
    }

    func testClickOnMarker_textFieldValueUpdated() {
        let sampleCountry = "China"
        tap(onMarker: sampleCountry)

        XCTAssertEqual(textField.value as? String, sampleCountry)
    }

    func testInfoWindowDisplayed_clickOutside_infoWindowDismissed() {
        let sampleCountry = "Singapore"
        tap(onMarker: sampleCountry)
        let singaporeInfoWindow = app.otherElements[Identifiers.generateInfoWindowIdentifier(country: sampleCountry)]

        performActionAndWait(action: { () -> Void in
            tap(on: mapView, offsetX: UIScreen.main.bounds.width * 0.5, offsetY: UIScreen.main.bounds.height * 0.75)
        }, timeout: 3)

        XCTAssertFalse(singaporeInfoWindow.exists)
    }

    func testInfoWindowDisplayed_clickOnSearchButton_infoWindowDismissed_tableRevealed() {
        let sampleCountry = "Singapore"
        tap(onMarker: sampleCountry)
        performActionAndWait(action: { () -> Void in searchButton.tap() }, timeout: 3)

        let singaporeInfoWindow = app.otherElements[Identifiers.generateInfoWindowIdentifier(country: sampleCountry)]
        XCTAssertFalse(singaporeInfoWindow.exists)
        XCTAssertTrue(tableView.exists)
    }

    func testInfoWindowDisplayed_clickOnCross_InfoWindowDismissed() {
        let sampleCountry = "Singapore"
        tap(onMarker: sampleCountry)
        let singaporeInfoWindow = app.otherElements[Identifiers.generateInfoWindowIdentifier(country: sampleCountry)]
        let crossButton = singaporeInfoWindow.buttons[Identifiers.infoWindowCrossButtonIdentifier]
        performActionAndWait(action: { () -> Void in crossButton.tap() }, timeout: 3)

        XCTAssertFalse(singaporeInfoWindow.exists)
    }

    func testInfoWindowDisplayed_clickOnImage_newsWindowDisplayed() {
        let sampleCountry = "Singapore"
        tap(onMarker: sampleCountry)

        let singaporeInfoWindow = app.otherElements[Identifiers.generateInfoWindowIdentifier(country: sampleCountry)]
        let image = singaporeInfoWindow.buttons[Identifiers.generateInfoWindowImageIdentifier(country: sampleCountry)]
        performActionAndWait(action: { () -> Void in image.tap() }, timeout: 3)

        XCTAssertTrue(app.webViews[Identifiers.generateWebViewIdentifier(country: sampleCountry)].exists)
    }

    func testInfoWindowDisplayed_clickOnHeadline_newsWindowDisplayed() {
        let sampleCountry = "Singapore"
        tap(onMarker: sampleCountry)

        let singaporeInfoWindow = app.otherElements[Identifiers.generateInfoWindowIdentifier(country: sampleCountry)]
        let headline =
            singaporeInfoWindow.buttons[Identifiers.generateInfoWindowHeadlineIdentifier(country: sampleCountry)]
        performActionAndWait(action: { () -> Void in headline.tap() }, timeout: 3)

        XCTAssertTrue(app.webViews[Identifiers.generateWebViewIdentifier(country: sampleCountry)].exists)
    }
}

extension XCUIElement {
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        self.tap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
        self.typeText(text)
    }

    func tapFunctionKey(key: XCUIKeyboardKey) {
        typeText(key.rawValue)
    }
}

extension MapNewsUITests {
    func performActionAndWait(action: () -> Void, timeout: UInt32) {
        action()
        sleep(timeout)
    }

    func tap(on element: XCUIElement, offsetX: CGFloat, offsetY: CGFloat) {
        let coordinate = element.coordinate(withNormalizedOffset: CGVector(dx: offsetX, dy: offsetY))
        coordinate.tap()
    }

    func tap(onMarker sampleCountry: String) {
        let controller = app.otherElements[Identifiers.mapViewControllerIdentifier]
        let singaporeMarker = controller.buttons[Identifiers.generateMarkerIdentifer(country: sampleCountry)]
        performActionAndWait(action: {() -> Void in singaporeMarker.tap()  }, timeout: 3)
    }
}
