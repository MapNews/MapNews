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
        let padding = MapNewsSelector.selectorPadding
        let selectorWidth = UIScreen.main.bounds.width - (2 * padding)
        let selectorHeight = UIScreen.main.bounds.height * 0.8
        let selectorOrigin = CGPoint(x: padding, y: padding)
        let openedRect = CGRect(origin: selectorOrigin, size: CGSize(width: selectorWidth, height: selectorHeight))
        let closedRect = CGRect(origin: selectorOrigin, size: CGSize(width: selectorWidth, height: MapNewsSelector.labelHeight))
        let locationSelector = MapNewsSelector(tableData: allCountries, mode: mode, openedFrame: openedRect, closedFrame: closedRect)
        locationSelector.isSearchButtonHidden = false
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
    lazy var settingsButton: UIButton = {
        let padding = MapNewsSelector.selectorPadding
        let button = UIButton(frame: CGRect(origin: CGPoint(x: 10, y: 10), size: CGSize(width: padding - 20, height: padding - 20)))
        button.setImage(UIImage(named: "settings"), for: .normal)
        return button
    }()
    lazy var settingsTab: UIView = {
        let padding = MapNewsSelector.selectorPadding
        let width = padding
        let height = padding
        let origin = CGPoint(x: UIScreen.main.bounds.width - padding, y: padding)
        let tab = UIView(frame: CGRect(origin: origin, size: CGSize(width: width, height: height)))
        tab.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        tab.layer.borderWidth = 2
        tab.layer.cornerRadius = 5
        tab.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8470588235)
        tab.layer.masksToBounds = true
        tab.addSubview(settingsButton)
        return tab
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
        view.addSubview(settingsTab)

        bindAllGestureRecognizers()

        AccessibilityIdentifierUtil.setIdentifierForContainer(view: view, to: Identifiers.mapViewControllerIdentifier)
    }

    @objc func handleSettingsTap(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toSettings", sender: self)
    }

    private func bindAllGestureRecognizers() {
        settingsButton.addTarget(self, action: #selector(handleSettingsTap(sender:)), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        if let defaultLocationName = model.defaultLocation {
            guard let countryDTO = model.getCountryCoordinateDTO(for: defaultLocationName) else {
                return
            }
            mapView.location = CLLocationCoordinate2D.from(countryDTO.coordinates)
            locationDidUpdate(toLocation: defaultLocationName)
        } else {
            moveToPromptDefaultLocation()
        }
    }

    private func initMap() {
        mapView = MapNewsView(frame: self.view.bounds, location: MapConstants.singaporeCoordinates)
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
        if let websiteViewController = segue.destination as? WebsiteViewController {
            websiteViewController.url = currentDisplayingInfoWindow?.article.url
            websiteViewController.countryName = currentDisplayingInfoWindow?.countryName
        } else if let promptDefaultLocationViewController = segue.destination as? PromptDefaultLocationViewController {
            promptDefaultLocationViewController.countries = allCountries
        }
    }

    func moveToWebsite() {
        performSegue(withIdentifier: "toNewsWebsite", sender: self)
    }

    func moveToPromptDefaultLocation() {
        performSegue(withIdentifier: "toPromptDefaultLocation", sender: self)
    }

    func setDefaultLocation(to country: String) {
        model.setDefaultLocation(to: country)
        locationDidUpdate(toLocation: country)
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
        infoWindow.headlineButton.isEnabled = article.title != "No articles :("
        currentDisplayingInfoWindow = infoWindow
        loadArticleImageInInfoWindow(infoWindow: infoWindow, article: article)
    }

    private func loadArticleImageInInfoWindow(infoWindow: InfoWindow, article: ArticleDTO) {
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
