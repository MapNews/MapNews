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
    var pickerView: UIPickerView!
    var mapView: MapView!
    var locationSelector: MapNewsSelector!
    var locationSelectorMask: UIView!
    var model: MapViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        model = MapViewModel()
        initMap()
        initLocationSelector()
        initLocationSelectorMask()

        view.addSubview(mapView)
        view.addSubview(locationSelectorMask)
        view.addSubview(locationSelector)
    }

    func initMap() {
        mapView = MapView.createMapView(frame: self.view.bounds)
        if let location = model.getLatLong(for: "Singapore") {
            mapView.location = location
        }
    }

    func initLocationSelector() {
        let selectorWidth = view.bounds.width - (2 * Constants.selectorPadding)
        let selectorHeight = view.bounds.height / 3
        let selectorRect = CGRect(
            x: Constants.selectorPadding,
            y: Constants.selectorPadding,
            width: selectorWidth,
            height: selectorHeight)
        let allCountries = model.getAllCountries() ?? ["No data"]
        locationSelector = MapNewsSelector(frame: selectorRect, tableData: allCountries)
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
    func locationDidUpdate(to newLocation: String) {
        guard let newCoordinates = model.getLatLong(for: newLocation) else {
            return
        }
        mapView.location = newCoordinates
    }

    func pickerDidReveal() {
        locationSelectorMask.isHidden = false
    }

    func pickerDidHide() {
        locationSelectorMask.isHidden = true
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
