//
//  MapNewsSelectorObserver.swift
//  MapNews
//
//  Created by Hol Yin Ho on 25/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

protocol MapNewsSelectorObserver {
    func tableDidReveal()

    func tableDidHide()

    func locationDidUpdate(toLocation newLocation: String)
}
