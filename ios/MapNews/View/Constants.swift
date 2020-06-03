//
//  Constants.swift
//  MapNews
//
//  Created by Hol Yin Ho on 28/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import UIKit

struct Constants {
    static let labelHeight: CGFloat = 50
    static let labelPadding: CGFloat = 10

    static let searchIconWidth: CGFloat = 30
    static let searchIconHeight: CGFloat = 30

    static let selectorBorderRadius: CGFloat = 5
    static let selectorPadding: CGFloat = 50

    static let labelBackgroundColor = [
        UIUserInterfaceStyle.light: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
        UIUserInterfaceStyle.dark: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    ]

    static let textColor = [
        UIUserInterfaceStyle.light: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
        UIUserInterfaceStyle.dark: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    ]

    static let tableBackgroundColor = [
        UIUserInterfaceStyle.light: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
        UIUserInterfaceStyle.dark: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    ]

    static let searchIcon = [
        UIUserInterfaceStyle.light: UIImage(named: "search"),
        UIUserInterfaceStyle.dark: UIImage(named: "search_dark_mode")
    ]

    static let statusBarStyle = [
        UIUserInterfaceStyle.light: UIStatusBarStyle.darkContent,
        UIUserInterfaceStyle.dark: UIStatusBarStyle.lightContent,
    ]
}
