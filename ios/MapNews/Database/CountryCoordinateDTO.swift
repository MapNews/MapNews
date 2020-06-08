//
//  CountryCoordinateDTO.swift
//  MapNews
//
//  Created by Hol Yin Ho on 30/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

struct CountryCoordinateDTO: Hashable {
    let countryName: String
    let countryCode: String
    let coordinates: Coordinates

    init(name: String, countryCode: String, coordinates: Coordinates) {
        self.countryName = name
        self.countryCode = countryCode
        self.coordinates = coordinates
    }
}
