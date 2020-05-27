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
    var database: Database!

    override func viewDidLoad() {
        super.viewDidLoad()

        database = SQLDatabase()
        
        initMap()
        initLocationSelector()
        initLocationSelectorMask()
        if let location = database.queryLatLong(name: "Singapore") {
            mapView.location = location
        }

        view.addSubview(mapView)
        view.addSubview(locationSelectorMask)
        view.addSubview(locationSelector)
    }

    func initMap() {
        mapView = MapView.createMapView(frame: self.view.bounds)
    }

    func initLocationSelector() {
        let padding: CGFloat = 50
        let selectorRect = CGRect(
            x: padding,
            y: padding,
            width: view.bounds.width - (2 * padding),
            height: view.bounds.height / 3)
        let allCountries = database.queryAllCountries() ?? ["No data"]
        locationSelector = MapNewsSelector(frame: selectorRect, tableData: allCountries)
        locationSelector.addObserver(observer: self)
    }

    func initLocationSelectorMask() {
        let mask = UIView(frame: self.view.bounds)
        mask.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        mask.alpha = 0.7
        mask.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(recognizer:)))
        mask.addGestureRecognizer(tap)
        mask.isHidden = true
        locationSelectorMask = mask
    }

}

extension MapViewController: MapNewsSelectorObserver {
    func locationDidUpdate(to newCoordinates: Coordinates) {
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
    @objc func handleMapTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .cancelled {
            return
        }
        locationSelector.closeSelector()
        locationSelectorMask.isHidden = true
    }
}
