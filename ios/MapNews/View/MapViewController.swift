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
            allCountries = model.allCountryNames ?? ["No data"]
        }
    }
    var mapNewsMarkers: [CountryCoordinateDTO: MapNewsMarker] = [:]
    var currentDisplayingInfoWindow: InfoWindow?
    internal var allCountries: [String] = []

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

        AccessibilityIdentifierUtil.setIdentifierForContainer(view: view, to: Identifiers.mapViewControllerIdentifier)
    }

    private func initMap() {
        mapView = MapNewsView(frame: self.view.bounds)
        mapView.delegate = self
    }

    private func initLocationSelector() {
        locationSelector = MapNewsSelector.getSelector(
            tableData: allCountries,
            mode: UIScreen.main.traitCollection.userInterfaceStyle
        )
        locationSelector.observer = self
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
        AccessibilityIdentifierUtil.setIdentifier(view: mask, to: Identifiers.locationMaskIdentifier)
    }

}

extension MapViewController: MapNewsSelectorObserver {
    func locationDidUpdate(toLocation newLocation: String) {
        guard let newLocationDTO = model.getCountryCoordinateDTO(for: newLocation) else {
            return
        }
        guard let newCoordinates = CLLocationCoordinate2D.from(newLocationDTO.coordinates) else {
            return
        }
        locationDidUpdate(toCoordinate: newCoordinates)

        if let marker = mapNewsMarkers[newLocationDTO] {
            select(marker: marker)
        } else {
            let newMarker = createMarker(at: newLocationDTO)
            mapNewsMarkers[newLocationDTO] = newMarker
            select(marker: newMarker)
        }
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
        mapView.clear()
        model.allCountriesInBounds.forEach {
            let marker = createMarker(at: $0)
            mapNewsMarkers[$0] = marker
        }
    }

    private func closeActiveInfoWindow() {
        currentDisplayingInfoWindow?.removeFromSuperview()
        currentDisplayingInfoWindow = nil
        lightUpAllMarkers()
    }

    private func createMarker(at country: CountryCoordinateDTO) -> MapNewsMarker {
        let marker = MapNewsMarker(at: country)
        marker.icon = UIImage(named: "news")
        marker.title = country.countryName
        marker.map = mapView
        marker.accessibilityLabel = Identifiers.generateMarkerIdentifer(country: country.countryName)
        return marker
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
        guard let urlObject = article.urlToImage else {
            infoWindow.imageFailedToLoad()
            return
        }

        model.loadImage(
            url: urlObject,
            withImageCallback: infoWindow.imageDidLoad(image:),
            noImageCallback: infoWindow.imageFailedToLoad
        )
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
        if model.currentBounds.contains(mapNewsMarker.position) {
            mapView.animate(to: GMSCameraPosition(target: mapNewsMarker.position, zoom: mapView.camera.zoom))
        } else {
            mapView.location = mapNewsMarker.position
        }
        moveMarkerUp(marker: mapNewsMarker)
        model.updateNews(country: mapNewsMarker.location)
        locationSelector.selectedValue = mapNewsMarker.location.countryName
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.dimAllMarkers(except: mapNewsMarker)
        })
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
        mapNewsMarkers.values.forEach {
            $0.opacity = $0.location.countryName == marker.location.countryName ? 1 : 0.5
        }
    }

    func lightUpAllMarkers() {
        mapNewsMarkers.values.forEach {
            $0.opacity = 1
        }
    }
}

extension MapViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Constants.statusBarStyle[UIScreen.main.traitCollection.userInterfaceStyle] ?? .darkContent
    }
}
