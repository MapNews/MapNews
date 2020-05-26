//
//  Coordinates.swift
//  MapNews
//
//  Created by Hol Yin Ho on 26/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

struct Coordinates: Equatable {
    let lat: Double
    let long: Double

    init(lat: Double, long: Double) {
        self.lat = lat
        self.long = long
    }
}
