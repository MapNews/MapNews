//
//  MapViewModelObserver.swift
//  MapNews
//
//  Created by Hol Yin Ho on 8/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

protocol MapViewModelObserver {
    func updateHeadlines(country: CountryCoordinateDTO, headline: String)
}
