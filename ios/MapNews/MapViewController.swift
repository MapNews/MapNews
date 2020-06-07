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
    var mapNewsMarkers: [MapNewsMarker] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        initMap()
        model = MapViewModel(within: mapView.mapBounds)
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
        mapNewsMarkers = []
        model.allCountriesInBounds.forEach {
            let position = CLLocationCoordinate2D.from($0.coordinates)
            let marker = MapNewsMarker(at: $0.countryName, position: position)
            marker.icon = UIImage(named: "news")
            marker.title = $0.countryName
            marker.map = mapView
            mapNewsMarkers.append(marker)
        }
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
        marker.map = nil
        mapNewsMarkers.forEach {
            $0.zIndex = 0
        }
        marker.zIndex = 1
        marker.map = mapView
        mapView.animate(to: GMSCameraPosition(target: marker.position, zoom: mapView.camera.zoom))
        mapView.selectedMarker = marker
        return true
    }
}

extension MapViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Constants.statusBarStyle[UIScreen.main.traitCollection.userInterfaceStyle] ?? .darkContent
    }
}
