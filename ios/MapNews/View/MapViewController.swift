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
    lazy var locationSelector: MapNewsSelector = {
        let locationSelector = MapNewsSelector.getSelector(tableData: allCountries, mode: mode)
        locationSelector.observer = self
        return locationSelector
    }()
    lazy var locationSelectorMask: UIView = {
        let mask = UIView(frame: self.view.bounds)
        mask.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        mask.alpha = 0.7
        mask.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleMaskTap(recognizer:)))
        mask.addGestureRecognizer(tap)
        mask.isHidden = true
        AccessibilityIdentifierUtil.setIdentifier(view: mask, to: Identifiers.locationMaskIdentifier)
        return mask
    }()
    var model: Model! {
        didSet {
            updateMarkers()
            allCountries = model.allCountryNames ?? ["No data"]
        }
    }
    var mapNewsMarkers: [CountryCoordinateDTO: MapNewsMarker] = [:]
    var currentDisplayingInfoWindow: InfoWindow?
    var mode: UIUserInterfaceStyle {
        UIScreen.main.traitCollection.userInterfaceStyle
    }
    internal var allCountries: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        initMap()
        model = MapViewModel(within: mapView.mapBounds)
        model.addObserver(self)

        view.addSubview(mapView)
        view.addSubview(locationSelectorMask)
        view.addSubview(locationSelector)

        AccessibilityIdentifierUtil.setIdentifierForContainer(view: view, to: Identifiers.mapViewControllerIdentifier)
    }

    private func initMap() {
        mapView = MapNewsView(frame: self.view.bounds)
        mapView.delegate = self
        loadMapStyle(to: mode)
    }

    private func loadMapStyle(to mode: UIUserInterfaceStyle) {
        if mode == .light {
            mapView.mapStyle = nil
            return
        } else if mode == .dark {
            do {
              // Set the map style by passing the URL of the local file.
                if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                    mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                } else {
                    NSLog("Unable to find style.json")
                }
            } catch {
                NSLog("One or more of the map styles failed to load. \(error)")
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let websiteViewController = segue.destination as? WebsiteViewController else {
            return
        }
        websiteViewController.url = currentDisplayingInfoWindow?.article.url
        websiteViewController.countryName = currentDisplayingInfoWindow?.countryName
    }

    func moveToWebsite() {
        performSegue(withIdentifier: "toNewsWebsite", sender: self)
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
        marker.icon = Constants.newsIcon[mode] ?? nil
        marker.title = country.countryName
        marker.map = mapView
        marker.accessibilityLabel = Identifiers.generateMarkerIdentifer(country: country.countryName)
        return marker
    }
}

extension MapViewController: InfoWindowObserver {
    func infoWindowDidClose() {
        closeActiveInfoWindow()
    }
}

extension MapViewController: MapViewModelObserver {
    func updateHeadlines(country: CountryCoordinateDTO, article: ArticleDTO) {
        guard let selectedMarker = mapNewsMarkers[country] else {
            return
        }
        selectedMarker.zIndex = 1
        addInfoWindow(countryName: country.countryName, article: article)
    }

    private func addInfoWindow(countryName: String, article: ArticleDTO) {
        let infoWindow = InfoWindow(countryName: countryName, article: article, mode: mode)
        infoWindow.observer = self
        view.addSubview(infoWindow)
        currentDisplayingInfoWindow = infoWindow
        loadArticleImageInInfowWindow(infoWindow: infoWindow, article: article)
    }

    private func loadArticleImageInInfowWindow(infoWindow: InfoWindow, article: ArticleDTO) {
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
        move(to: mapNewsMarker.position)
        moveMarkerUp(marker: mapNewsMarker)
        model.updateNews(country: mapNewsMarker.location)
        locationSelector.selectedValue = mapNewsMarker.location.countryName
        dimMarkers(except: mapNewsMarker, after: 0.5)
    }

    private func move(to location: CLLocationCoordinate2D) {
        if model.currentBounds.contains(location) {
            mapView.animate(to: GMSCameraPosition(target: location, zoom: mapView.camera.zoom))
        } else {
            mapView.location = location
        }
    }

    private func moveMarkerUp(marker: MapNewsMarker) {
        marker.map = nil
        mapNewsMarkers.values.forEach {
            $0.zIndex = 0
        }
        marker.map = mapView
    }

    private func dimMarkers(except marker: MapNewsMarker, after delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            self.dimAllMarkers(except: marker)
        })
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
