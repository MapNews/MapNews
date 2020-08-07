//
//  MapNewsSelector.swift
//  MapNews
//
//  Created by Hol Yin Ho on 25/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import UIKit

class MapNewsSelector: UIView, Selector {
    private static var theSelector: MapNewsSelector?
    var closedFrame: CGRect
    var openedFrame: CGRect

    internal var allCountries: [String]
    internal var filteredCountries: [String] {
        didSet {
            tableView.reloadData()
        }
    }
    var selectedValue: String = "" {
        didSet {
            selectedCountryTextField.text = selectedValue
        }
    }

    internal lazy var tableView: UITableView = {
        let tableView = UITableView(frame: tableRect)
        tableView.isHidden = true
        tableView.isUserInteractionEnabled = true
        tableView.layer.cornerRadius = MapNewsSelector.selectorBorderRadius
        tableView.layer.masksToBounds = true

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()

    internal lazy var selectedCountryTextField: UITextField = {
        let textField =
            UITextField(frame: textFieldRect)
        textField.text = ""
        textField.isUserInteractionEnabled = true
        return textField
    }()

    internal lazy var labelBackground: UIView = {
        let labelBackground = UIView(frame: labelBackgroundRect)
        labelBackground.layer.cornerRadius = 5
        labelBackground.layer.masksToBounds = true;
        return labelBackground
    }()

    internal lazy var searchButton: UIButton = {
        let searchButton = UIButton(frame: MapNewsSelector.searchIconRect)
        searchButton.setImage(Constants.searchIcon[.light] ?? nil, for: .normal)
        searchButton.isUserInteractionEnabled = true
        return searchButton
    }()

    var observer: MapNewsSelectorObserver?
    var mode: UIUserInterfaceStyle = .light {
        didSet {
            toggleMode(to: mode)
        }
    }

    static func getSelector(tableData: [String], mode: UIUserInterfaceStyle, openedFrame: CGRect, closedFrame: CGRect) -> MapNewsSelector {
        print(openedFrame.height / UIScreen.main.bounds.height)
        if let selector = MapNewsSelector.theSelector {
            selector.allCountries = tableData
            selector.filteredCountries = selector.allCountries.filter {
                $0.startsWith(substring: selector.selectedCountryTextField.text ?? "")
            }
            selector.selectedCountryTextField.text = ""
            selector.toggleMode(to: mode)
            selector.closedFrame = closedFrame
            selector.openedFrame = openedFrame
            selector.frame = selector.closedFrame
            return selector
        } else {
            let singleton = MapNewsSelector(
                tableData: tableData,
                mode: mode,
                openedFrame: openedFrame,
                closedFrame: closedFrame
            )
            theSelector = singleton
            return singleton
        }
    }

    private init(tableData: [String], mode: UIUserInterfaceStyle, openedFrame: CGRect, closedFrame: CGRect) {
        allCountries = tableData
        filteredCountries = tableData
        self.openedFrame = openedFrame
        self.closedFrame = closedFrame

        super.init(frame: self.openedFrame)
        toggleMode(to: mode)

        addSubview(labelBackground)
        addSubview(selectedCountryTextField)
        addSubview(tableView)
        addSubview(searchButton)

        frame = self.closedFrame

        selectedCountryTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        filteredCountries = allCountries.filter { $0.startsWith(substring: selectedCountryTextField.text ?? "") }

        bindAllGestureRecognizers()

        AccessibilityIdentifierUtil.setIdentifierForContainer(view: self, to: Identifiers.selectorIdentifier)
        AccessibilityIdentifierUtil.setIdentifier(view: selectedCountryTextField, to: Identifiers.textFieldIdentifier)
        AccessibilityIdentifierUtil.setIdentifier(view: tableView, to: Identifiers.tableIdentifier)
        AccessibilityIdentifierUtil.setIdentifier(view: labelBackground, to: Identifiers.labelBackgroundIdentifier)
        AccessibilityIdentifierUtil.setIdentifier(view: searchButton, to: Identifiers.searchButtonIdentifier)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    func closeSelector() {
        frame = closedFrame
        tableView.isHidden = true
        selectedCountryTextField.resignFirstResponder()
        observer?.tableDidHide()
    }

    func openSelector() {
        frame = openedFrame
        filteredCountries = allCountries.filter { $0.startsWith(substring: selectedValue) }
        tableView.isHidden = false
        observer?.tableDidReveal()
    }

    internal func updateLocation() {
        observer?.locationDidUpdate(toLocation: selectedValue)
    }

    private func toggleMode(to mode: UIUserInterfaceStyle) {
        tableView.backgroundColor = Constants.backgroundColor[mode]
        selectedCountryTextField.textColor = Constants.textColor[mode]
        labelBackground.backgroundColor = Constants.backgroundColor[mode]
        searchButton.setImage(Constants.searchIcon[mode] ?? nil, for: .normal)
        selectedCountryTextField.overrideUserInterfaceStyle = mode
    }
}

extension MapNewsSelector {
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if tableView.isHidden {
            // Selector is close
            openSelector()
        } else {
            // Selector is open
            closeSelector()
            selectedValue = selectedCountryTextField.text ?? selectedValue
            updateLocation()
        }
    }

    @objc func handleReturnButtonPress() {
        closeSelector()
        selectedValue = selectedCountryTextField.text ?? selectedValue
        updateLocation()
    }

    internal func bindAllGestureRecognizers() {
        searchButton.addTarget(self, action: #selector(handleTap(sender:)), for: .touchUpInside)
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
        AccessibilityIdentifierUtil.setIdentifier(
            view: cell,
            to: Identifiers.generateCellIdentifier(index: indexPath.row)
        )
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedValue = filteredCountries[indexPath.row]
        closeSelector()
        updateLocation()
    }
}

extension MapNewsSelector: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        openSelector()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        closeSelector()
        return true
    }


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        filteredCountries = allCountries.filter { $0.startsWith(substring: text) }
        return true
    }

}

extension MapNewsSelector {
    // Map Selector Constants
    static let selectorWidth = UIScreen.main.bounds.width - (2 * selectorPadding)
    static let selectorHeight = UIScreen.main.bounds.height * 0.7
    static let selectorOrigin = CGPoint(x: selectorPadding, y: selectorPadding)
    static let selectorRect = CGRect(origin: selectorOrigin, size: CGSize(width: selectorWidth, height: selectorHeight))
    static let closedSelectorRect =
        CGRect(origin: selectorOrigin, size: CGSize(width: selectorWidth, height: labelHeight))

    static let labelHeight: CGFloat = 50
    static let labelPadding: CGFloat = 10

    static let searchIconWidth: CGFloat = 30
    static let searchIconHeight: CGFloat = 30
    static let searchIconSize = CGSize(width: searchIconWidth, height: searchIconHeight)
    static let searchIconOrigin = CGPoint(x: selectorWidth - searchIconWidth - labelPadding, y: labelPadding)
    static let searchIconRect = CGRect(origin: searchIconOrigin, size: searchIconSize)

    static let selectorBorderRadius: CGFloat = 5
    static let selectorPadding: CGFloat = 50

    var width: CGFloat {
        openedFrame.width
    }
    var height: CGFloat {
        openedFrame.height
    }
    var textFieldWidth: CGFloat {
        width - MapNewsSelector.searchIconWidth
    }
    var textFieldHeight: CGFloat {
        MapNewsSelector.labelHeight - (2 * MapNewsSelector.labelPadding)
    }
    var textFieldSize: CGSize {
        CGSize(width: textFieldWidth, height: textFieldHeight)
    }
    var textFieldOrigin: CGPoint {
        CGPoint(x: MapNewsSelector.labelPadding, y: MapNewsSelector.labelPadding)
    }
    var textFieldRect: CGRect {
        CGRect(origin: textFieldOrigin, size: textFieldSize)
    }
    var labelBackgroundWidth: CGFloat{
       width
    }
    var labelBackgroundHeight: CGFloat {
        MapNewsSelector.labelHeight
    }
    var labelBackgroundSize: CGSize {
        CGSize(width: labelBackgroundWidth, height: labelBackgroundHeight)
    }
    var labelBackgroundOrigin: CGPoint {
        CGPoint.zero
    }
    var labelBackgroundRect: CGRect {
        CGRect(origin: labelBackgroundOrigin, size: labelBackgroundSize)
    }
    var tableWidth: CGFloat {
        width
    }
    var tableHeight: CGFloat {
        height - MapNewsSelector.labelHeight
    }
    var tableSize: CGSize {
        CGSize(width: tableWidth, height: tableHeight)
    }
    var tableOrigin: CGPoint {
        CGPoint(x: 0, y: MapNewsSelector.labelHeight)
    }
    var tableRect: CGRect {
        CGRect(origin: tableOrigin, size: CGSize(width: tableWidth, height: tableHeight))
    }
}
