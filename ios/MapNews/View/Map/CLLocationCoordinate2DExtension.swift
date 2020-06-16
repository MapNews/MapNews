//
//  CLLocationCoordinate2DExtension.swift
//  MapNews
//
//  Created by Hol Yin Ho on 1/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import GoogleMaps

extension CLLocationCoordinate2D {
    public static func from(_ coordinates: Coordinates) -> CLLocationCoordinate2D? {
        guard let latDegrees = CLLocationDegrees(exactly: coordinates.lat) else {
            return nil
        }
        guard let longDegrees = CLLocationDegrees(exactly: coordinates.long) else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latDegrees, longitude: longDegrees)
    }
}
