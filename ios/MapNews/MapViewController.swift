//
//  ViewController.swift
//  MapNews
//
//  Created by Hol Yin Ho on 18/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    var mapView: MapNewsView!
    var locationSelector: MapNewsSelector!
    var locationSelectorMask: UIView!
    var model: MapViewModel!
    var mapNewsMarkers: [CountryCoordinateDTO: MapNewsMarker] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        initMap()
        model = MapViewModel(within: mapView.mapBounds)
        model.addObserver(self)
        initLocationSelector()
        initLocationSelectorMask()

        view.addSubview(mapView)
        view.addSubview(locationSelectorMask)
        view.addSubview(locationSelector)

        updateMarkers()
    }

    func initMap() {
        mapView = MapNewsView(frame: self.view.bounds)
        mapView.delegate = self
    }

    func initLocationSelector() {
        let selectorWidth = view.bounds.width - (2 * Constants.selectorPadding)
        let selectorHeight = view.bounds.height / 3
        let selectorRect = CGRect(
            x: Constants.selectorPadding,
            y: Constants.selectorPadding,
            width: selectorWidth,
            height: selectorHeight)
        let allCountries = model.allCountryNames ?? ["No data"]
        locationSelector = MapNewsSelector(
            frame: selectorRect,
            tableData: allCountries,
            mode: UIScreen.main.traitCollection.userInterfaceStyle
        )
        locationSelector.addObserver(observer: self)
    }

    func initLocationSelectorMask() {
        let mask = UIView(frame: self.view.bounds)
        mask.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        mask.alpha = 0.7
        mask.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleMaskTap(recognizer:)))
        mask.addGestureRecognizer(tap)
        mask.isHidden = true
        locationSelectorMask = mask
    }

}

extension MapViewController: MapNewsSelectorObserver {
    func locationDidUpdate(toLocation newLocation: String) {
        guard let newCoordinates = model.getLatLong(for: newLocation) else {
            return
        }
        mapView.location = newCoordinates
        locationDidUpdate(toCoordinate: newCoordinates)
    }

    func tableDidReveal() {
        locationSelectorMask.isHidden = false
    }

    func tableDidHide() {
        locationSelectorMask.isHidden = true
    }

    private func locationDidUpdate(toCoordinate coordinate: CLLocationCoordinate2D) {
        model.currentBounds = mapView.mapBounds
        updateMarkers()
    }

    private func updateMarkers() {
        mapNewsMarkers = [:]
        model.allCountriesInBounds.forEach {
            let marker = MapNewsMarker(at: $0)
            marker.icon = UIImage(named: "news")
            marker.title = $0.countryName
            marker.map = mapView
            mapNewsMarkers[$0] = marker
        }
    }
}

extension MapViewController: MapViewModelObserver {
    func updateHeadlines(country: CountryCoordinateDTO, headline: String) {
        print(country.countryName)
        print(headline)
        guard let selectedMarker = mapNewsMarkers[country] else {
            return
        }
        selectedMarker.snippet = headline
        mapView.selectedMarker = selectedMarker
    }
}

extension MapViewController {
    @objc func handleMaskTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .cancelled {
            return
        }
        locationSelector.closeSelector()
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        locationDidUpdate(toCoordinate: position.target)
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let mapNewsMarker = marker as? MapNewsMarker else {
            return true
        }
        model.updateNews(country: mapNewsMarker.location)
        mapNewsMarker.map = nil
        mapNewsMarkers.values.forEach {
            $0.zIndex = 0
        }
        mapNewsMarker.zIndex = 1
        mapNewsMarker.map = mapView
        mapView.animate(to: GMSCameraPosition(target: mapNewsMarker.position, zoom: mapView.camera.zoom))
        return true
    }
}

extension MapViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Constants.statusBarStyle[UIScreen.main.traitCollection.userInterfaceStyle] ?? .darkContent
    }
}
