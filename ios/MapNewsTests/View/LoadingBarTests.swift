//
//  LoadingBarTests.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 14/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import XCTest

class LoadingBarTests: XCTestCase {
    var loadingBar: LoadingBar!
    let loadingBarHeight: CGFloat = 10
    let loadingBarWidth: CGFloat = 300

    override func setUp() {
        loadingBar = LoadingBar(frame: CGRect(
            origin: CGPoint.zero,
            size: CGSize(width: loadingBarWidth, height: loadingBarHeight)))
    }
    override func tearDown() {
        loadingBar.removeFromSuperview()
    }

    func testInit() {
        XCTAssertEqual(loadingBar.sliderColor, #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
        XCTAssertEqual(loadingBar.loadingBarColor, #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        XCTAssertEqual(loadingBar.layer.cornerRadius, loadingBarHeight / 2)
        XCTAssertEqual(loadingBar.bounds.origin, CGPoint.zero)
        XCTAssertTrue(loadingBar.clipsToBounds)

        let subviews = loadingBar.subviews.map { String(describing: type(of: $0)) }
        let uiViewCount = subviews.filter { $0 == "UIView" }.count
        XCTAssertEqual(subviews.count, 2)
        XCTAssertEqual(uiViewCount, 2)

        XCTAssertEqual(loadingBar.advanceFactor, 2)
        XCTAssertEqual(loadingBar.sliderFactor, 5)
    }

    func testSetLoadingBarColor() {
        let newColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        loadingBar.loadingBarColor = newColor
        XCTAssertEqual(loadingBar.loadingBar.backgroundColor, newColor)
    }

    func testSetSliderColor() {
        let newColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        loadingBar.sliderColor = newColor
        XCTAssertEqual(loadingBar.slider.backgroundColor, newColor)
    }

    func testSetSliderFactor() {
        let newFactor: CGFloat = 10
        loadingBar.sliderFactor = newFactor
        XCTAssertEqual(
            loadingBar.slider.bounds.width,
            loadingBar.bounds.width / newFactor
        )
        XCTAssertEqual(
            loadingBar.slider.bounds.height,
            loadingBar.bounds.height
        )
    }
}
