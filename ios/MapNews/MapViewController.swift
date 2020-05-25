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
    var selectedCountry: String? {
        didSet {
            selectedCountryLabel.text = selectedCountry ?? ""
        }
    }
    @IBOutlet weak var selectedCountryLabel: UILabel!

    var pickerData: [String] = ["test", "1", "2", "3"]

    override func viewDidLoad() {
        super.viewDidLoad()

        initMap()
        view.addSubview(mapView)

        initPicker()
        view.addSubview(pickerView)

        initSelectedCountryLabel()
    }

    func initMap() {
        let newMapView = MapView.createMapView(frame: self.view.bounds)
        mapView = newMapView
    }

    func initSelectedCountryLabel() {
        view.bringSubviewToFront(selectedCountryLabel)
        selectedCountryLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        selectedCountryLabel.text = "Singapore"
        selectedCountryLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        selectedCountryLabel.addGestureRecognizer(tap)
    }

    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        print("tapped")
        if recognizer.state == .cancelled {
            return
        }
        togglePickerVisibility()
    }
}

extension MapViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func initPicker() {
        let pickerHeight = self.view.bounds.height / 3
        let newPickerView = UIPickerView(frame: CGRect(
            x: 50,
            y: 50 + selectedCountryLabel.bounds.height,
            width: selectedCountryLabel.bounds.width,
            height: pickerHeight)
        )
        newPickerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pickerView = newPickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.isHidden = true
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = pickerData[row]
    }

    func togglePickerVisibility() {
        pickerView.isHidden = !pickerView.isHidden
    }
}
