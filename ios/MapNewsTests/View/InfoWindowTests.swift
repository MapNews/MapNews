//
//  InfoWindowTests.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 12/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import XCTest

class InfoWindowTests: XCTestCase {
    var infoWindow: InfoWindow!

    override func setUp() {
        let sampleArticle = ArticleBuilder().withTitle(title: "Harry Potter Goes To School").build()
        infoWindow = InfoWindow(countryName: "Hogwarts", article: sampleArticle)
    }

    func testInit() {
        let subviews = infoWindow.subviews.map { String(describing: type(of: $0)) }
        let uiLabelCount = subviews.filter { $0 == "UILabel" }.count
        XCTAssertTrue(subviews.contains("LoadingBar"))
        XCTAssertEqual(uiLabelCount, 2)
        XCTAssertTrue(subviews.contains("UIView"))

        XCTAssertEqual(infoWindow.countryName, "Hogwarts")
        XCTAssertEqual(infoWindow.headline, "Harry Potter Goes To School")
        XCTAssertEqual(
            infoWindow.article,
            ArticleBuilder().withTitle(title: "Harry Potter Goes To School").build()
        )
    }

    func testTapCrossIcon() {
        let observer = MockInfoWindowObserver()
        observer.windowClosedExpectation = expectation(description: "window closed")
        infoWindow.observer = observer
        tap(button: infoWindow.crossButton)
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testImageFailedToLoad() {
        infoWindow.imageFailedToLoad()
        let subviews = infoWindow.subviews.map { String(describing: type(of: $0)) }
        let uiLabelCount = subviews.filter { $0 == "UILabel" }.count

        XCTAssertFalse(subviews.contains("LoadingBar"))
        XCTAssertEqual(uiLabelCount, 3)
    }

    func testImageDidLoad() {
        infoWindow.imageDidLoad(image: UIImage())
        let subviews = infoWindow.subviews.map { String(describing: type(of: $0)) }
        let uiLabelCount = subviews.filter { $0 == "UILabel" }.count

        XCTAssertFalse(subviews.contains("LoadingBar"))
        XCTAssertEqual(uiLabelCount, 2)
    }
}

class MockInfoWindowObserver: InfoWindowObserver {
    var windowClosedExpectation: XCTestExpectation?
    func infoWindowDidClose() {
        windowClosedExpectation?.fulfill()
    }
}
