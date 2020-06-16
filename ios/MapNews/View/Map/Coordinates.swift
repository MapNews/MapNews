//
//  Coordinates.swift
//  MapNews
//
//  Created by Hol Yin Ho on 26/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

// To be used with database, reduce database and GMS coupling
import GoogleMaps

public struct Coordinates: Hashable {
    public let lat: Double
    public let long: Double 

    init?(lat: Double, long: Double) {
        let validLat = lat >= -90 && lat <= 90
        let validLong = long >= -180 && long <= 180
        if !validLat || !validLong {
            return nil
        }
        self.lat = lat
        self.long = long
    }

    public static func from(_ coordinates: CLLocationCoordinate2D) -> Coordinates {
        Coordinates(lat: Double(coordinates.latitude), long: Double(coordinates.longitude))!
    }
}
