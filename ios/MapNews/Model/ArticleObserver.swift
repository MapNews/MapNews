//
//  ArticleObserver.swift
//  MapNews
//
//  Created by Hol Yin Ho on 10/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import UIKit

protocol ArticleObserver {
    func imageDidLoad(image: UIImage)

    func imageFailedToLoad()
}
