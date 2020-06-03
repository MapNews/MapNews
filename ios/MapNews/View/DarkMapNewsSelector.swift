//
//  DarkMapNewsSelector.swift
//  MapNews
//
//  Created by Hol Yin Ho on 3/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import UIKit

class DarkMapNewsSelector: CommonMapNewsSelector {
    override init(frame: CGRect, tableData: [String]) {
        super.init(frame: frame, tableData: tableData)
        tableView.backgroundColor = Constants.tableBackgroundColor[.dark]
        selectedCountryTextField.textColor = Constants.textColor[.dark]
        labelBackground.backgroundColor = Constants.labelBackgroundColor[.dark]
        searchButton.image = Constants.searchIcon[.dark] ?? nil
    }

    required init?(coder: NSCoder) {
        return nil
    }
}
