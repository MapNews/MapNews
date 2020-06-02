//
//  CountryCoordinateDTO.swift
//  MapNews
//
//  Created by Hol Yin Ho on 30/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

struct CountryCoordinateDTO: Equatable {
    let countryName: String
    let coordinates: Coordinates

    init(name: String, coordinates: Coordinates) {
        self.countryName = name
        self.coordinates = coordinates
    }
}
