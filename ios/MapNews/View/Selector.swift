//
//  MapNewsSelector.swift
//  MapNews
//
//  Created by Hol Yin Ho on 3/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import UIKit

protocol Selector: UIView {
    var selectedValue: String { get set }

    var mode: UIUserInterfaceStyle { get set }

    func addObserver(observer: MapNewsSelectorObserver)

    func closeSelector()

    func openSelector()
}
