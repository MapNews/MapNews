//
//  MapNewsSelectorFactory.swift
//  MapNews
//
//  Created by Hol Yin Ho on 3/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import UIKit

struct MapNewsSelectorFactory {
    static func with(style: UIUserInterfaceStyle, in frame: CGRect, tableData: [String]) -> MapNewsSelector {
        return (style == .light)
            ? CommonMapNewsSelector(frame: frame, tableData: tableData)
            : DarkMapNewsSelector(frame: frame, tableData: tableData)
    }
}
