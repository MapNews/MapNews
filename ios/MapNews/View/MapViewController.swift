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
    var model: Model! {
        didSet {
            updateMarkers()
        }
    }
    var mapNewsMarkers: [CountryCoordinateDTO: MapNewsMarker] = [:]
    var currentDisplayingInfoWindow: InfoWindow?

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
    }

    private func initMap() {
        mapView = MapNewsView(frame: self.view.bounds)
        mapView.delegate = self
    }

    private func initLocationSelector() {
        let allCountries = model.allCountryNames ?? ["No data"]
        locationSelector = MapNewsSelector(
            tableData: allCountries,
            mode: UIScreen.main.traitCollection.userInterfaceStyle
        )
        locationSelector.addObserver(observer: self)
    }

    private func initLocationSelectorMask() {
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
        guard let newLocationDTO = model.getCountryCoordinateDTO(for: newLocation) else {
            return
        }
        let newCoordinates = CLLocationCoordinate2D.from(newLocationDTO.coordinates)
        locationDidUpdate(toCoordinate: newCoordinates)

        guard let marker = mapNewsMarkers[newLocationDTO] else {
            return
        }
        select(marker: marker)
    }

    func tableDidReveal() {
        closeActiveInfoWindow()
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

    private func closeActiveInfoWindow() {
        currentDisplayingInfoWindow?.removeFromSuperview()
        currentDisplayingInfoWindow = nil
    }
}

extension MapViewController: MapViewModelObserver {
    func updateHeadlines(country: CountryCoordinateDTO, article: ArticleDTO) {
        guard let selectedMarker = mapNewsMarkers[country] else {
            return
        }
        selectedMarker.zIndex = 1

        let infoWindow = InfoWindow(countryName: country.countryName, article: article)
        view.addSubview(infoWindow)
        currentDisplayingInfoWindow = infoWindow
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
            return false
        }
        locationDidUpdate(toLocation: mapNewsMarker.location.countryName)
        return true
    }

    private func select(marker: GMSMarker) {
        closeActiveInfoWindow()
        guard let mapNewsMarker = marker as? MapNewsMarker else {
            return
        }
        moveMarkerUp(marker: mapNewsMarker)
        model.updateNews(country: mapNewsMarker.location)
        mapView.animate(to: GMSCameraPosition(target: mapNewsMarker.position, zoom: mapView.camera.zoom))
    }

    private func moveMarkerUp(marker: MapNewsMarker) {
        marker.map = nil
        mapNewsMarkers.values.forEach {
            $0.zIndex = 0
        }
        marker.map = mapView
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        closeActiveInfoWindow()
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            closeActiveInfoWindow()
        }
    }

    func dimAllMarkers(except marker: MapNewsMarker) {
    }
}

extension MapViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Constants.statusBarStyle[UIScreen.main.traitCollection.userInterfaceStyle] ?? .darkContent
    }
}