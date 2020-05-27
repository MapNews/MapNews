//
//  MapNewsSelector.swift
//  MapNews
//
//  Created by Hol Yin Ho on 25/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import UIKit

class MapNewsSelector: UIView {
    var allCountries: [String]
    var filteredCountries: [String] {
        didSet {
            tableView.reloadData()
        }
    }
    var selectedCountry: String = "Singapore" {
        didSet {
            selectedCountryTextField.text = selectedCountry
            if let newCoordinates = SQLDatabase().queryLatLong(name: selectedCountry) {
                observers.forEach { $0.locationDidUpdate(to: newCoordinates) }
            }
        }
    }
    var tableView: UITableView
    var selectedCountryTextField: UITextField
    var observers: [MapNewsSelectorObserver] = []

    init(frame: CGRect, tableData: [String]) {
        // Create label
        let labelHeight: CGFloat = 30
        let labelPadding: CGFloat = 10
        selectedCountryTextField = MapNewsSelector.createTextField(
                width: frame.width,
                height: labelHeight,
                padding: labelPadding
        )

        // Create picker
        tableView = MapNewsSelector.createTableView(
            origin: CGPoint(x: 0, y: labelHeight),
            width: frame.width,
            height: frame.height - labelHeight
        )

        // Create label background
        let labelBackground = MapNewsSelector.createLabelBackground(width: frame.width, height: labelHeight)
        self.allCountries = tableData
        self.filteredCountries = tableData

        super.init(frame: frame)

        addSubview(labelBackground)
        addSubview(selectedCountryTextField)
        addSubview(tableView)

        selectedCountryTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }

    required init?(coder: NSCoder) {
        return nil
    }

    public func addObserver(observer: MapNewsSelectorObserver) {
        observers.append(observer)
    }

    static func createTableView(origin: CGPoint, width: CGFloat, height: CGFloat) -> UITableView {
        let tableView = UITableView(
            frame: CGRect(origin: origin, size: CGSize(width: width, height: height))
        )
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.isHidden = true
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = true

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }

    static func createTextField(width: CGFloat, height: CGFloat, padding: CGFloat) -> UITextField {
        let textFieldSize = CGSize(width: width - (2 * padding), height: height)
        let textField = UITextField(frame: CGRect(origin: CGPoint(x: padding, y: 0), size: textFieldSize))
        textField.text = "Singapore"
        textField.isUserInteractionEnabled = true
        return textField
    }

    static func createLabelBackground(width: CGFloat, height: CGFloat) -> UIView {
        let labelBackgroundSize = CGSize(width: width, height: height)
        let labelBackground = UIView(frame: CGRect(origin: CGPoint.zero, size: labelBackgroundSize))
        labelBackground.layer.cornerRadius = 5
        labelBackground.layer.masksToBounds = true;
        labelBackground.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        return labelBackground
    }

    func closeSelector() {
        selectedCountryTextField.resignFirstResponder()
        tableView.isHidden = true
    }
}

extension MapNewsSelector: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCountries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = filteredCountries[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCountry = filteredCountries[indexPath.row]
        closeSelector()
    }
}

extension MapNewsSelector: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tableView.isHidden = false
        observers.forEach { $0.pickerDidReveal() }
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        tableView.isHidden = true
        observers.forEach { $0.pickerDidHide() }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard var text = textField.text else {
            return false
        }
        if string == "" {
            text = String(text[..<text.index(before: text.endIndex)])
        }
        filteredCountries = allCountries.filter { $0.startsWith(substring: text + string) }
        return true
    }

}

extension String {
    func startsWith(substring: String) -> Bool {
        if substring.count > self.count {
            return false
        }
        for i in 0..<substring.count {
            if substring.charAt(offset: i) != self.charAt(offset: i) {
                return false
            }
        }
        return true
    }

    func charAt(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
