//
//  MapNewsSelector.swift
//  MapNews
//
//  Created by Hol Yin Ho on 25/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import UIKit

class MapNewsSelector: UIView {
    private var allCountries: [String]
    private var filteredCountries: [String] {
        didSet {
            tableView.reloadData()
        }
    }
    var selectedCountry: String = "Singapore" {
        didSet {
            selectedCountryTextField.text = selectedCountry
        }
    }
    private var tableView: UITableView
    private var selectedCountryTextField: UITextField
    private var searchButton: UIImageView
    private var observers: [MapNewsSelectorObserver] = []
    private var openedSelectorFrame: CGRect
    private var closedSelectorFrame: CGRect

    init(frame: CGRect, tableData: [String]) {
        // Create label
        selectedCountryTextField = MapNewsSelector.createTextField(
                width: frame.width,
                height: Constants.labelHeight,
                padding: Constants.labelPadding
        )

        // Create picker
        tableView = MapNewsSelector.createTableView(
            origin: CGPoint(x: 0, y: Constants.labelHeight),
            width: frame.width,
            height: frame.height - Constants.labelHeight
        )

        // Create label background
        let labelBackground = MapNewsSelector.createLabelBackground(width: frame.width, height: Constants.labelHeight)

        // Create search button
        searchButton = MapNewsSelector.createSearchButton(within: frame, padding: Constants.labelPadding)

        self.allCountries = tableData
        self.filteredCountries = tableData

        openedSelectorFrame = frame
        closedSelectorFrame = CGRect(
            origin: frame.origin,
            size: CGSize(width: frame.width, height: Constants.labelHeight)
        )

        super.init(frame: openedSelectorFrame)

        addSubview(labelBackground)
        addSubview(selectedCountryTextField)
        addSubview(tableView)
        addSubview(searchButton)

        self.frame = closedSelectorFrame

        selectedCountryTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        filteredCountries = allCountries.filter { $0.startsWith(substring: selectedCountryTextField.text ?? "") }

        bindAllGestureRecognizers()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    func addObserver(observer: MapNewsSelectorObserver) {
        observers.append(observer)
    }

    private static func createTableView(origin: CGPoint, width: CGFloat, height: CGFloat) -> UITableView {
        let tableView = UITableView(
            frame: CGRect(origin: origin, size: CGSize(width: width, height: height))
        )
        tableView.backgroundColor =
            Constants.tableBackgroundColor[UIScreen.main.traitCollection.userInterfaceStyle]
        tableView.isHidden = true
        tableView.isUserInteractionEnabled = true
        tableView.layer.cornerRadius = Constants.selectorBorderRadius
        tableView.layer.masksToBounds = true

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }

    private static func createTextField(width: CGFloat, height: CGFloat, padding: CGFloat) -> UITextField {
        let textFieldWidth = width - (2 * padding) - Constants.searchIconWidth
        let textFieldHeight = height - (2 * padding)
        let textFieldSize = CGSize(width: textFieldWidth, height: textFieldHeight)
        let textField = UITextField(frame: CGRect(origin: CGPoint(x: padding, y: padding), size: textFieldSize))
        textField.textColor = Constants.textColor[UIScreen.main.traitCollection.userInterfaceStyle]
        textField.overrideUserInterfaceStyle = .light
        textField.text = "Singapore"
        textField.isUserInteractionEnabled = true
        return textField
    }

    private static func createLabelBackground(width: CGFloat, height: CGFloat) -> UIView {
        let labelBackgroundSize = CGSize(width: width, height: height)
        let labelBackground = UIView(frame: CGRect(origin: CGPoint.zero, size: labelBackgroundSize))
        labelBackground.layer.cornerRadius = 5
        labelBackground.layer.masksToBounds = true;
        labelBackground.backgroundColor =
            Constants.labelBackgroundColor[UIScreen.main.traitCollection.userInterfaceStyle]
        return labelBackground
    }

    private static func createSearchButton(within frame: CGRect, padding: CGFloat) -> UIImageView {
        let searchButtonSize = CGSize(width: Constants.searchIconWidth, height: Constants.searchIconHeight)
        let searchButtonOrigin = CGPoint(x: frame.width - Constants.searchIconWidth - padding, y: padding)
        let searchButton = UIImageView(frame: CGRect(origin: searchButtonOrigin, size: searchButtonSize))
        searchButton.image = Constants.searchIcon[UIScreen.main.traitCollection.userInterfaceStyle] as? UIImage
        searchButton.isUserInteractionEnabled = true
        return searchButton
    }
    
    func closeSelector() {
        frame = closedSelectorFrame
        selectedCountryTextField.resignFirstResponder()
        tableView.isHidden = true
        observers.forEach { $0.pickerDidHide() }
    }

    func openSelector() {
        frame = openedSelectorFrame
        tableView.isHidden = false
        observers.forEach { $0.pickerDidReveal() }
    }

    private func updateLocation() {
        observers.forEach { $0.locationDidUpdate(toLocation: selectedCountry) }
    }
}

extension MapNewsSelector {
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if tableView.isHidden {
            // Selector is close
            openSelector()
            return
        }
        if !tableView.isHidden {
            closeSelector()
            selectedCountry = selectedCountryTextField.text ?? selectedCountry
            updateLocation()
            return
        }
    }

    @objc func handleReturnButtonPress() {
        closeSelector()
        selectedCountry = selectedCountryTextField.text ?? selectedCountry
        updateLocation()
    }

    private func bindAllGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        searchButton.addGestureRecognizer(tap)

        selectedCountryTextField.addTarget(self, action: #selector(handleReturnButtonPress), for: .editingDidEndOnExit)
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
        print("selected")
        selectedCountry = filteredCountries[indexPath.row]
        closeSelector()
        updateLocation()
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
        let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        filteredCountries = allCountries.filter { $0.startsWith(substring: text) }
        return true
    }

}
