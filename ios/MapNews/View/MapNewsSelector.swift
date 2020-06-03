//
//  MapNewsSelector.swift
//  MapNews
//
//  Created by Hol Yin Ho on 3/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import UIKit

protocol MapNewsSelector: UIView {
    func addObserver(observer: MapNewsSelectorObserver)

    func closeSelector()

    func openSelector()
}
