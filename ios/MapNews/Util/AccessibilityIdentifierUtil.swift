//
//  AccessibilityIdentifierUtil.swift
//  MapNews
//
//  Created by Hol Yin Ho on 17/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import UIKit
import GoogleMaps

struct AccessibilityIdentifierUtil {
    static func setIdentifier(view: UIView, to identifier: String) {
        view.accessibilityIdentifier = identifier
        view.isAccessibilityElement = true
    }

    static func setIdentifierForContainer(view: UIView, to identifier: String) {
        view.accessibilityIdentifier = identifier
        view.isAccessibilityElement = false
    }

    static func setIdentifier(map: MapNewsView, to identifier: String) {
        map.accessibilityElementsHidden = false
        map.accessibilityIdentifier = identifier
        map.isAccessibilityElement = true
    }
}
