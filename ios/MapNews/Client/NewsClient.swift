//
//  NewsClient.swift
//  MapNews
//
//  Created by Hol Yin Ho on 11/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import UIKit

protocol NewsClient {
    func queryArticles(country: CountryCoordinateDTO,

                              callback: @escaping ([ArticleDTO], CountryCoordinateDTO) -> Void)
    func downloadImage(from url: URL, callback: @escaping (UIImage) -> Void)
}
