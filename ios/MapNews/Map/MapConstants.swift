//
//  MapConstants.swift
//  MapNews
//
//  Created by Hol Yin Ho on 4/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import GoogleMaps

struct MapConstants {
    static let singaporeCamera =
        GMSCameraPosition.camera(withLatitude: 1.3521, longitude: 103.8198, zoom: 3)
    static let singaporeCoordinates =
        CLLocationCoordinate2D.from(Coordinates(lat: 1.3521, long: 103.8198))
    static private let cocoCoordinates =
        CLLocationCoordinate2D.from(Coordinates(lat: -12.164165, long: 96.870956))
    static private let taiwanCoordinates =
        CLLocationCoordinate2D.from(Coordinates(lat: 23.69781, long: 120.960515))

    static let defaultBounds = GMSCoordinateBounds(coordinate: cocoCoordinates, coordinate: taiwanCoordinates)
}
