//
//  SelectorObserverStub.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 5/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import XCTest

class SelectorObserverStub: MapNewsSelectorObserver {
    var closeExpectation: XCTestExpectation?
    var openExpectation: XCTestExpectation?
    var locationExpectation: XCTestExpectation?

    func tableDidReveal() {
        openExpectation?.fulfill()
    }

    func tableDidHide() {
        closeExpectation?.fulfill()
    }

    func locationDidUpdate(toLocation newLocation: String) {
        locationExpectation?.fulfill()
    }


}
