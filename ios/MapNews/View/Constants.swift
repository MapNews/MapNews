//
//  Constants.swift
//  MapNews
//
//  Created by Hol Yin Ho on 28/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import UIKit

struct Constants {
    static let backgroundColor = [
        UIUserInterfaceStyle.light: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
        UIUserInterfaceStyle.dark: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    ]

    static let textColor = [
        UIUserInterfaceStyle.light: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
        UIUserInterfaceStyle.dark: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    ]

    static let newsIcon = [
        UIUserInterfaceStyle.light: UIImage(named: "news"),
        UIUserInterfaceStyle.dark: UIImage(named: "news_dark_mode")
    ]

    static let searchIcon = [
        UIUserInterfaceStyle.light: UIImage(named: "search"),
        UIUserInterfaceStyle.dark: UIImage(named: "search_dark_mode")
    ]

    static let crossIcon = [
        UIUserInterfaceStyle.light: UIImage(named: "cross"),
        UIUserInterfaceStyle.dark: UIImage(named: "cross_dark_mode")
    ]

    static let statusBarStyle = [
        UIUserInterfaceStyle.light: UIStatusBarStyle.darkContent,
        UIUserInterfaceStyle.dark: UIStatusBarStyle.lightContent,
    ]
}
