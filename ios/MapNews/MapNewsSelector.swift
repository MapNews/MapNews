//
//  MapNewsSelector.swift
//  MapNews
//
//  Created by Hol Yin Ho on 25/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import UIKit

class MapNewsSelector: UIView {
    var pickerData: [String] = MapNewsConstants.countries
    var selectedCountry: String = "Singapore" {
        didSet {
            selectedCountryLabel.text = selectedCountry
        }
    }
    var pickerView: UIPickerView
    var selectedCountryLabel: UILabel
    var observers: [MapNewsSelectorObserver] = []

    override init(frame: CGRect) {
        // Create label
        let labelHeight: CGFloat = 30
        let labelPadding: CGFloat = 10
        selectedCountryLabel = MapNewsSelector.createLabel(
                width: frame.width,
                height: labelHeight,
                padding: labelPadding
        )

        // Create picker
        pickerView = MapNewsSelector.createPicker(
            origin: CGPoint(x: 0, y: labelHeight),
            width: frame.width,
            height: frame.height - labelHeight
        )

        // Create label background
        let labelBackground = MapNewsSelector.createLabelBackground(width: frame.width, height: labelHeight)

        super.init(frame: frame)

        addSubview(labelBackground)
        addSubview(selectedCountryLabel)
        addSubview(pickerView)

        bindAllGestureRecognizers()


        pickerView.delegate = self
        pickerView.dataSource = self
    }

    required init?(coder: NSCoder) {
        return nil
    }

    public func addObserver(observer: MapNewsSelectorObserver) {
        observers.append(observer)
    }

    private func bindAllGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap(recognizer:)))
        selectedCountryLabel.addGestureRecognizer(tap)
    }

    static func createPicker(origin: CGPoint, width: CGFloat, height: CGFloat) -> UIPickerView {
        let newPickerView = UIPickerView(
            frame: CGRect(origin: origin, size: CGSize(width: width, height: height))
        )
        newPickerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        newPickerView.isHidden = true
        newPickerView.layer.cornerRadius = 5
        newPickerView.layer.masksToBounds = true
        return newPickerView
    }

    static func createLabel(width: CGFloat, height: CGFloat, padding: CGFloat) -> UILabel {
        let labelSize = CGSize(width: width - (2 * padding), height: height)
        let label = UILabel(frame: CGRect(origin: CGPoint(x: padding, y: 0), size: labelSize))
        label.text = "Singapore"
        label.isUserInteractionEnabled = true
        return label
    }

    static func createLabelBackground(width: CGFloat, height: CGFloat) -> UIView {
        let labelBackgroundSize = CGSize(width: width, height: height)
        let labelBackground = UIView(frame: CGRect(origin: CGPoint.zero, size: labelBackgroundSize))
        labelBackground.layer.cornerRadius = 5
        labelBackground.layer.masksToBounds = true;
        labelBackground.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        return labelBackground
    }

    @objc func handleLabelTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .cancelled {
            return
        }
        togglePickerVisibility()
        observers.forEach { pickerView.isHidden ? $0.pickerDidHide() : $0.pickerDidReveal() }
    }
}

extension MapNewsSelector: UIPickerViewDelegate, UIPickerViewDataSource {
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
