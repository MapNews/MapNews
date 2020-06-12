//
//  InfoWindow.swift
//  MapNews
//
//  Created by Hol Yin Ho on 9/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import UIKit

class InfoWindow: UIView {
    let countryName: String
    let headline: String
    let article: ArticleDTO
    let loadingBar: LoadingBar

    init(countryName: String, article: ArticleDTO) {
        self.countryName = countryName
        self.headline = article.title
        self.article = article
        self.loadingBar = LoadingBar(frame: InfoWindow.loadingBarRect)

        super.init(frame: CGRect(origin: InfoWindow.origin, size: InfoWindow.size))

        layer.cornerRadius = InfoWindow.borderRadius

        addBackground()
        addCountryNameLabel()
        addHeadline()
        addSubview(loadingBar)
    }

    required init?(coder: NSCoder) {
        nil
    }

    internal func addBackground() {
        let background = UIView(frame: CGRect(origin: CGPoint.zero, size: InfoWindow.size))
        background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        background.layer.cornerRadius = InfoWindow.borderRadius
        background.alpha = 0.8

        addSubview(background)
    }

    internal func addCountryNameLabel() {
        let countryNameLabel = UILabel(frame: InfoWindow.countryLabelRect)
        countryNameLabel.text = countryName
        countryNameLabel.font = UIFont.boldSystemFont(ofSize: 28.0)
        addSubview(countryNameLabel)
    }

    internal func addHeadline() {
        let headlineLabel = UILabel(frame: InfoWindow.headlineRect)
        headlineLabel.text = headline
        headlineLabel.font = UIFont.systemFont(ofSize: 14)
        headlineLabel.numberOfLines = 0
        headlineLabel.lineBreakMode = .byWordWrapping
        addSubview(headlineLabel)
    }
}

extension InfoWindow {
    // Image functions
    func imageFailedToLoad() {
        loadingBar.removeFromSuperview()

        let noImageLabel = UILabel(frame: InfoWindow.imageRect)
        noImageLabel.text = "No image :("
        noImageLabel.textAlignment = .center

        addSubview(noImageLabel)
    }

    func imageDidLoad(image: UIImage) {
        loadingBar.removeFromSuperview()

        let headlineImage = UIImageView(frame: InfoWindow.imageRect)
        headlineImage.image = image
        headlineImage.alpha = 1
        headlineImage.layer.cornerRadius = 5
        headlineImage.layer.masksToBounds = true
        addSubview(headlineImage)
    }
}

extension InfoWindow {
    // Info window constants
    static let width: CGFloat = UIScreen.main.bounds.width - 100
    static var height: CGFloat = (2 * insets) + countryLabelHeight + headlineHeight + imageHeight
    static let origin = CGPoint(x: 50, y: 125)
    static let size = CGSize(width: width, height: height)
    static let borderRadius: CGFloat = 5
    static let padding: CGFloat = 50
    static let insets: CGFloat = 20

    static let countryLabelWidth: CGFloat = width - (2 * insets)
    static let countryLabelHeight: CGFloat = 30
    static let countryLabelOrigin = CGPoint(x: insets, y: insets)
    static let countryLabelSize = CGSize(width: countryLabelWidth, height: countryLabelHeight)
    static let countryLabelRect = CGRect(origin: countryLabelOrigin, size: countryLabelSize)

    static let headlineWidth: CGFloat = width - (2 * insets)
    static let headlineHeight: CGFloat = 50
    static let headlineOrigin = CGPoint(x: insets, y: countryLabelOrigin.y + countryLabelHeight)
    static let headlineSize = CGSize(width: headlineWidth, height: headlineHeight)
    static let headlineRect = CGRect(origin: headlineOrigin, size: headlineSize)

    static let imageWidth: CGFloat = width - (2 * insets)
    static var imageHeight: CGFloat = 150
    static let imageOrigin = CGPoint(x: insets, y: headlineOrigin.y + headlineHeight)
    static let imageSize = CGSize(width: imageWidth, height: imageHeight)
    static let imageRect = CGRect(origin: imageOrigin, size: imageSize)

    static let loadingBarWidth: CGFloat = width - (4 * insets)
    static let loadingBarHeight: CGFloat = 10
    static let loadingBarOrigin = CGPoint(x: 2 * insets, y: imageOrigin.y + (imageHeight / 2) - loadingBarHeight)
    static let loadingBarSize = CGSize(width: loadingBarWidth, height: loadingBarHeight)
    static let loadingBarRect = CGRect(origin: loadingBarOrigin, size: loadingBarSize)

}
