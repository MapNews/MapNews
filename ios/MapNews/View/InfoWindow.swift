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

    init(countryName: String, article: ArticleDTO) {
        self.countryName = countryName
        self.headline = article.title
        super.init(frame: CGRect(origin: InfoWindow.origin, size: InfoWindow.size))

        layer.cornerRadius = InfoWindow.borderRadius

        addBackground()
        addCountryNameLabel()
        addHeadline(headline: article.title)
        asyncLoadImage(for: article)
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

    internal func addHeadline(headline: String) {
        let headlineLabel = UILabel(frame: InfoWindow.headlineRect)
        headlineLabel.text = headline
        headlineLabel.font = UIFont.systemFont(ofSize: 14)
        headlineLabel.numberOfLines = 0
        headlineLabel.lineBreakMode = .byWordWrapping
        addSubview(headlineLabel)
    }

    private func asyncLoadImage(for article: ArticleDTO) {
        article.articleObserver = self
        DispatchQueue.main.async {
            article.loadImage()
        }
    }
}

extension InfoWindow: ArticleObserver {
    func imageFailedToLoad() {
    }

    func imageDidLoad(image: UIImage) {
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
    static let headlineOrigin = CGPoint(x: insets, y: insets + countryLabelHeight)
    static let headlineSize = CGSize(width: headlineWidth, height: headlineHeight)
    static let headlineRect = CGRect(origin: headlineOrigin, size: headlineSize)

    static let imageWidth: CGFloat = width - (2 * insets)
    static var imageHeight: CGFloat = 150
    static let imageOrigin = CGPoint(x: insets, y: insets + countryLabelHeight + headlineHeight)
    static let imageSize = CGSize(width: imageWidth, height: imageHeight)
    static let imageRect = CGRect(origin: imageOrigin, size: imageSize)
}