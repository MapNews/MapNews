//
//  LoadingBarTests.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 14/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import XCTest

class LoadingBarTests: XCTestCase {
    func testInit() {
        let loadingBar = LoadingBar(frame: CGRect(
            origin: CGPoint.zero,
            size: CGSize(width: 300, height: 10)))
        XCTAssertEqual(loadingBar.sliderColor, #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
        XCTAssertEqual(loadingBar.loadingBarColor, #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        XCTAssertEqual(loadingBar.layer.cornerRadius, 5)
        XCTAssertTrue(loadingBar.clipsToBounds)

        let subviews = loadingBar.subviews.map { String(describing: type(of: $0)) }
        let uiViewCount = subviews.filter { $0 == "UIView" }.count
        XCTAssertEqual(subviews.count, 2)
        XCTAssertEqual(uiViewCount, 2)

        loadingBar.removeFromSuperview()
    }
}
