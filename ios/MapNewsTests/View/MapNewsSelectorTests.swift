//
//  MapNewsSelector.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 5/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import XCTest

class MapNewsSelectorTests: XCTestCase {
    var selector: MapNewsSelector!
    private let tableData = ["Test", "table", "data"]

    override func setUp() {
        selector = MapNewsSelector.getSelector(
            tableData: tableData,
            mode: .light)
        selector.observer = nil
    }

    override func tearDown() {
        selector = nil
    }

    func testSelectedCountry_defaultValue() {
        XCTAssertEqual(selector.selectedValue, "Singapore")
    }

    func testModifySelectedCountry() {
        selector.selectedValue = "Test test"
        XCTAssertEqual(selector.selectedCountryTextField.text, "Test test")

        selector.selectedValue = "🐨"
        XCTAssertEqual(selector.selectedCountryTextField.text, "🐨")
    }

    func testLightMode() {
        selector.mode = .light
        XCTAssertEqual(selector.tableView.backgroundColor, Constants.tableBackgroundColor[.light])
        XCTAssertEqual(selector.selectedCountryTextField.textColor, Constants.textColor[.light])
        XCTAssertEqual(selector.labelBackground.backgroundColor, Constants.labelBackgroundColor[.light])
        XCTAssertEqual(selector.searchButton.image(for: .normal), Constants.searchIcon[.light])
        XCTAssertEqual(selector.selectedCountryTextField.overrideUserInterfaceStyle, .light)
    }

    func testDarkMode() {
        selector.mode = .dark
        XCTAssertEqual(selector.tableView.backgroundColor, Constants.tableBackgroundColor[.dark])
        XCTAssertEqual(selector.selectedCountryTextField.textColor, Constants.textColor[.dark])
        XCTAssertEqual(selector.labelBackground.backgroundColor, Constants.labelBackgroundColor[.dark])
        XCTAssertEqual(selector.searchButton.image(for: .normal), Constants.searchIcon[.dark])
        XCTAssertEqual(selector.selectedCountryTextField.overrideUserInterfaceStyle, .dark)
    }

    func testFilteredCountries() {
        let tableView = selector.tableView
        let beforeFiltered = ["before", "filtered", "list"]
        selector.filteredCountries = beforeFiltered
        assertDataInTable(table: tableView, data: beforeFiltered)

        let afterFiltered = ["filtered, countries"]
        selector.filteredCountries = afterFiltered
        assertDataInTable(table: tableView, data: afterFiltered)

        let emptyData: [String] = []
        selector.filteredCountries = emptyData
        assertDataInTable(table: tableView, data: emptyData)
    }

    func testAddObserver() {
        let sampleObserver = SelectorObserverStub()
        XCTAssertNil(selector.observer)

        selector.observer = sampleObserver
        XCTAssertNotNil(selector.observer)
    }

    func testCreateTableView() {
        let tableView = selector.tableView

        XCTAssertEqual(tableView.frame.origin, CGPoint(x: 0, y: 50))
        XCTAssertEqual(tableView.frame.width, MapNewsSelector.tableWidth)
        XCTAssertEqual(tableView.frame.height, MapNewsSelector.tableHeight)
        XCTAssertTrue(tableView.isHidden)
        XCTAssertTrue(tableView.isUserInteractionEnabled)
        XCTAssertTrue(tableView.layer.masksToBounds)
        XCTAssertEqual(tableView.layer.cornerRadius, MapNewsSelector.selectorBorderRadius)
    }

    func testCreateTextField() {
        let textField = selector.selectedCountryTextField

        XCTAssertEqual(textField.frame.width, MapNewsSelector.selectorWidth - MapNewsSelector.searchIconWidth)
        XCTAssertEqual(textField.frame.height, MapNewsSelector.labelHeight - (MapNewsSelector.labelPadding * 2))
        XCTAssertEqual(
            textField.frame.origin,
            CGPoint(x: MapNewsSelector.labelPadding, y: MapNewsSelector.labelPadding)
        )
        XCTAssertEqual(textField.text, "Singapore")
        XCTAssertTrue(textField.isUserInteractionEnabled)
    }

    func testCreateLabelBackground() {
        let labelBackground = selector.labelBackground

        XCTAssertEqual(labelBackground.frame.width, MapNewsSelector.selectorWidth)
        XCTAssertEqual(labelBackground.frame.height, MapNewsSelector.labelHeight)
        XCTAssertEqual(labelBackground.layer.cornerRadius, 5)
        XCTAssertTrue(labelBackground.layer.masksToBounds)
    }

    func testCreateSearchButton() {
        let searchButton = selector.searchButton
        selector.mode = .light

        XCTAssertEqual(searchButton.frame.width, MapNewsSelector.searchIconWidth)
        XCTAssertEqual(searchButton.frame.height, MapNewsSelector.searchIconHeight)
        XCTAssertEqual(searchButton.image(for: .normal), Constants.searchIcon[.light])
        XCTAssertTrue(searchButton.isUserInteractionEnabled)
    }

    func testCloseSelector() {
        let closeSelectorExpectation = expectation(description: "close selector")
        let observer = SelectorObserverStub()
        observer.closeExpectation = closeSelectorExpectation
        selector.observer = observer

        selector.closeSelector()
        waitForExpectations(timeout: 0, handler: nil)
        assertTableIsHidden()
    }

    func testOpenSelector() {
        let openSelectorExpectation = expectation(description: "open selector")
        let observer = SelectorObserverStub()
        observer.openExpectation = openSelectorExpectation
        selector.observer = observer

        selector.openSelector()
        waitForExpectations(timeout: 0, handler: nil)
        assertTableIsVisible()
    }

    func testOpenSelector_closeSelector_openSelector() {
        let openSelectorExpectation = expectation(description: "open selector")
        openSelectorExpectation.expectedFulfillmentCount = 2

        let observer = SelectorObserverStub()
        observer.openExpectation = openSelectorExpectation
        selector.observer = observer

        selector.openSelector()
        assertTableIsVisible()

        let closeSelectorExpectation = expectation(description: "close selector")
        observer.closeExpectation = closeSelectorExpectation

        selector.closeSelector()
        assertTableIsHidden()

        selector.openSelector()
        waitForExpectations(timeout: 0, handler: nil)
        assertTableIsVisible()
    }

    func testLocationUpdate() {
        let locationExpectation = expectation(description: "location update")

        let observer = SelectorObserverStub()
        observer.locationExpectation = locationExpectation
        selector.observer = observer

        selector.updateLocation()
        waitForExpectations(timeout: 0, handler: nil)
    }

    func testSetMode() {
        selector.mode = .light
        XCTAssertEqual(selector.tableView.backgroundColor, Constants.tableBackgroundColor[.light])
        XCTAssertEqual(selector.selectedCountryTextField.textColor, Constants.textColor[.light])
        XCTAssertEqual(selector.labelBackground.backgroundColor, Constants.labelBackgroundColor[.light])
        XCTAssertEqual(selector.searchButton.image(for: .normal), Constants.searchIcon[.light])
        XCTAssertEqual(selector.selectedCountryTextField.overrideUserInterfaceStyle, .light)
        
        selector.mode = .dark
        XCTAssertEqual(selector.tableView.backgroundColor, Constants.tableBackgroundColor[.dark])
        XCTAssertEqual(selector.selectedCountryTextField.textColor, Constants.textColor[.dark])
        XCTAssertEqual(selector.labelBackground.backgroundColor, Constants.labelBackgroundColor[.dark])
        XCTAssertEqual(selector.searchButton.image(for: .normal), Constants.searchIcon[.dark])
        XCTAssertEqual(selector.selectedCountryTextField.overrideUserInterfaceStyle, .dark)
    }

    func testTextFieldTap_whenTableIsHidden_tableShouldShow() {
        selector.closeSelector()
        assertTableIsHidden()
        let touchTextFieldExpectation = expectation(description: "tap on text field")
        let observer = SelectorObserverStub()
        observer.openExpectation = touchTextFieldExpectation
        selector.observer = observer

        XCTAssertTrue(selector.selectedCountryTextField.canBecomeFirstResponder)
        tap(textField: selector.selectedCountryTextField)
        waitForExpectations(timeout: 0, handler: nil)
        assertTableIsVisible()
    }

    func testTextFieldTap_whenTableIsVisible_tableShouldRemainVisible() {
        selector.openSelector()
        assertTableIsVisible()
        tap(textField: selector.selectedCountryTextField)
        assertTableIsVisible()
    }

    func testSearchIconTap_whenTableIsHidden_tableShouldShow() {
        selector.closeSelector()
        assertTableIsHidden()
        let touchSearchIconExpectation = expectation(description: "tap on search icon")
        let observer = SelectorObserverStub()
        observer.openExpectation = touchSearchIconExpectation
        selector.observer = observer

        tap(button: selector.searchButton)
        waitForExpectations(timeout: 0, handler: nil)
        assertTableIsVisible()
    }

    func testSearchIconTap_whenTableIsVisible_tableShouldHide() {
        selector.openSelector()
        assertTableIsVisible()
        let touchSearchIconExpectation = expectation(description: "tap on search icon")
        let observer = SelectorObserverStub()
        observer.closeExpectation = touchSearchIconExpectation
        selector.observer = observer

        tap(button: selector.searchButton)
        waitForExpectations(timeout: 0, handler: nil)
        assertTableIsHidden()
    }

    func testTypeQuery_tapReturnKey_tableShouldHide() {
        selector.closeSelector()
        assertTableIsHidden()
        let observer = SelectorObserverStub()
        selector.observer = observer

        tap(textField: selector.selectedCountryTextField)
        selector.selectedCountryTextField.text = "Canada"
        selector.handleReturnButtonPress()
        assertTableIsHidden()
    }

    func testTextFieldNil_tapReturnKey_tableShouldHide() {
        selector.closeSelector()
        assertTableIsHidden()
        let observer = SelectorObserverStub()
        selector.observer = observer

        tap(textField: selector.selectedCountryTextField)
        selector.selectedValue = "Test value"
        selector.selectedCountryTextField.text = nil
        selector.handleReturnButtonPress()
        assertTableIsHidden()
        XCTAssertEqual(selector.selectedValue, "")
    }
}


extension MapNewsSelectorTests {
    private func assertDataInTable(table: UITableView, data: [String]) {
        for i in 0..<data.count {
            let text = getText(from: table, at: i, section: 1)
            XCTAssertEqual(text, data[i])
        }
    }

    private func getText(from table: UITableView, at row: Int, section: Int) -> String? {
        return table.dataSource?.tableView(table, cellForRowAt: IndexPath(row: row, section: section)).textLabel?.text
    }

    private func assertTableIsVisible() {
        XCTAssertEqual(selector.frame.width, MapNewsSelector.selectorWidth)
        XCTAssertEqual(selector.frame.height, MapNewsSelector.selectorHeight)
        XCTAssertFalse(selector.tableView.isHidden)
    }

    private func assertTableIsHidden() {
        XCTAssertEqual(selector.frame.width, MapNewsSelector.selectorWidth)
        XCTAssertEqual(selector.frame.height, MapNewsSelector.labelHeight)
        XCTAssertTrue(selector.tableView.isHidden)
    }
}
