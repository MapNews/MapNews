//
//  MapNewsViewTests.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 7/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import XCTest

class MapNewsViewTests: XCTestCase {
    var mapView: MapNewsView!

    override func setUp() {
        mapView = MapNewsView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 300, height: 400)))
    }

    func testInit_defaultValues() {
        guard let location = mapView.location else {
            XCTFail("MapView should have location")
            return
        }
        XCTAssertEqual(Coordinates.from(location), Coordinates.from(MapConstants.singaporeCoordinates))
        XCTAssertEqual(mapView.camera, MapConstants.singaporeCamera)
        XCTAssertTrue(mapView.settings.zoomGestures)
    }

    func testInit_frameValues() {
        XCTAssertEqual(mapView.frame, CGRect(origin: CGPoint.zero, size: CGSize(width: 300, height: 400)))
    }

    func testGetBounds() {
        let visibleRegion = mapView.projection.visibleRegion()
        XCTAssertTrue(mapView.mapBounds.contains(visibleRegion.farRight))
        XCTAssertTrue(mapView.mapBounds.contains(visibleRegion.farLeft))
        XCTAssertTrue(mapView.mapBounds.contains(visibleRegion.nearRight))
        XCTAssertTrue(mapView.mapBounds.contains(visibleRegion.nearLeft))
    }
}
