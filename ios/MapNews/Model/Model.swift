//
//  Model.swift
//  MapNews
//
//  Created by Hol Yin Ho on 10/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import GoogleMaps

protocol Model {
    func addObserver(_ observer: MapViewModelObserver)
    
    var allCountryNames: [String]? { get }

    var observers: [MapViewModelObserver] { get }

    var currentBounds: GMSCoordinateBounds { get set }

    var allCountriesInBounds: [CountryCoordinateDTO] { get }

    func updateNews(country: CountryCoordinateDTO)

    func getCountryCoordinateDTO(for country: String) -> CountryCoordinateDTO?
}