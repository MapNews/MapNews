//
//  InfoWindow.swift
//  MapNews
//
//  Created by Hol Yin Ho on 9/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import UIKit

class InfoWindow: UIView {
    internal let countryName: String
    internal let headlineString: String
    internal let dateString: String
    internal let article: ArticleDTO
    internal let loadingBar: LoadingBar
    internal var observer: InfoWindowObserver?
    lazy internal var crossButton: UIButton = {
        let crossButton = UIButton(frame: InfoWindow.crossButtonRect)
        crossButton.setImage(UIImage(named: "cross"), for: .normal)
        AccessibilityIdentifierUtil.setIdentifier(view: crossButton, to: Identifiers.infoWindowCrossButtonIdentifier)
        return crossButton
    }()
    lazy internal var headlineLabel: UILabel = {
        let headlineLabel = UILabel(frame: InfoWindow.headlineRect)
        headlineLabel.text = headlineString
        headlineLabel.font = UIFont.systemFont(ofSize: 14)
        headlineLabel.numberOfLines = 0
        headlineLabel.lineBreakMode = .byWordWrapping
        return headlineLabel
    }()
    lazy internal var headlineButton: UIButton = {
        let headlineButton = UIButton(frame: InfoWindow.headlineRect)
        let headlineIdentifier = Identifiers.generateInfoWindowHeadlineIdentifier(country: countryName)
        AccessibilityIdentifierUtil.setIdentifier(view: headlineButton, to: headlineIdentifier)
        return headlineButton
    }()
    lazy internal var countryNameLabel: UILabel = {
        let countryNameLabel = UILabel(frame: InfoWindow.countryLabelRect)
        countryNameLabel.text = countryName
        countryNameLabel.font = UIFont.boldSystemFont(ofSize: 28.0)
        return countryNameLabel
    }()
    lazy internal var background: UIView = {
        let background = UIView(frame: CGRect(origin: CGPoint.zero, size: InfoWindow.size))
        background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        background.layer.cornerRadius = InfoWindow.borderRadius
        background.alpha = 0.8
        return background
    }()
    lazy internal var dateLabel: UILabel = {
        let label = UILabel(frame: InfoWindow.dateLabelRect)
        label.text = dateString
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    internal var newsImage: UIButton?
    var mode: UIUserInterfaceStyle = .light {
        didSet {
            toggle(to: mode)
        }
    }

    init(countryName: String, article: ArticleDTO, mode: UIUserInterfaceStyle) {
        self.countryName = countryName
        self.headlineString = article.title
        self.dateString = TimeUtil.dateToTimeDisplayString(date: article.publishedAt)
        self.article = article
        self.loadingBar = LoadingBar(frame: InfoWindow.loadingBarRect)

        super.init(frame: CGRect(origin: InfoWindow.origin, size: InfoWindow.size))

        layer.cornerRadius = InfoWindow.borderRadius
        accessibilityLabel = "InfoWindow"

        addSubview(background)
        addSubview(countryNameLabel)
        addSubview(headlineLabel)
        addSubview(crossButton)
        addSubview(loadingBar)
        addSubview(headlineButton)
        addSubview(dateLabel)

        bindAllGestureRecognizer()
        let identifier = Identifiers.generateInfoWindowIdentifier(country: countryName)
        AccessibilityIdentifierUtil.setIdentifierForContainer(view: self, to: identifier)
        toggle(to: mode)
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func toggle(to mode: UIUserInterfaceStyle) {
        background.backgroundColor = Constants.backgroundColor[mode]
        countryNameLabel.textColor = Constants.textColor[mode]
        headlineLabel.textColor = Constants.textColor[mode]
        crossButton.setImage(Constants.crossIcon[mode] ?? nil, for: .normal)
    }
}

extension InfoWindow {
    // Image functions
    func imageFailedToLoad() {
        loadingBar.removeFromSuperview()
        updateHeadlineLink()

        let noImageLabel = UILabel(frame: InfoWindow.imageRect)
        noImageLabel.text = "No image :("
        noImageLabel.textAlignment = .center

        addSubview(noImageLabel)
    }

    func imageDidLoad(image: UIImage) {
        loadingBar.removeFromSuperview()
        updateHeadlineLink()

        let headlineImage = UIButton(frame: InfoWindow.imageRect)
        headlineImage.setImage(image, for: .normal)
        headlineImage.layer.cornerRadius = 5
        headlineImage.layer.masksToBounds = true

        headlineImage.addTarget(self, action: #selector(moveToWebsite(_:)), for: .touchUpInside)
        AccessibilityIdentifierUtil.setIdentifier(
            view: headlineImage,
            to: Identifiers.generateInfoWindowImageIdentifier(country: countryName)
        )
        newsImage = headlineImage
        addSubview(headlineImage)
    }

    private func updateHeadlineLink() {
        headlineButton.addTarget(self, action: #selector(moveToWebsite(_:)), for: .touchUpInside)
        AccessibilityIdentifierUtil.setIdentifier(view: headlineButton, to: Identifiers.generateInfoWindowHeadlineIdentifier(country: countryName))
    }

    @objc func moveToWebsite(_ gesture: UITapGestureRecognizer) {
        observer?.moveToWebsite()
    }
}

extension InfoWindow {
    @objc func handleCrossTap(_ gesture: UITapGestureRecognizer) {
        observer?.infoWindowDidClose()
    }

    func bindAllGestureRecognizer() {
        crossButton.addTarget(self, action: #selector(handleCrossTap(_:)), for: .touchUpInside)
    }
}

extension InfoWindow {
    // Info window constants
    static let width: CGFloat = UIScreen.main.bounds.width - 100
    static var height: CGFloat =
        (2 * insets)
        + countryLabelHeight
        + headlineHeight
        + dateLabelHeight
        + imageHeight
    static let origin = CGPoint(x: 50, y: 125)
    static let size = CGSize(width: width, height: height)
    static let borderRadius: CGFloat = 5
    static let padding: CGFloat = 50
    static let horizontalPadding: CGFloat = 10
    static let insets: CGFloat = 20

    static let countryLabelWidth: CGFloat = width - (2 * insets) - crossButtonWidth
    static let countryLabelHeight: CGFloat = 30
    static let countryLabelOrigin = CGPoint(x: insets, y: insets)
    static let countryLabelSize = CGSize(width: countryLabelWidth, height: countryLabelHeight)
    static let countryLabelRect = CGRect(origin: countryLabelOrigin, size: countryLabelSize)

    static let crossButtonWidth: CGFloat = 15
    static let crossButtonHeight: CGFloat = 15
    static let crossButtonOrigin = CGPoint(x: width - insets - crossButtonWidth, y: insets)
    static let crossButtonSize = CGSize(width: crossButtonWidth, height: crossButtonHeight)
    static let crossButtonRect = CGRect(origin: crossButtonOrigin, size: crossButtonSize)

    static let headlineWidth: CGFloat = width - (2 * insets)
    static let headlineHeight: CGFloat = 45
    static let headlineOrigin = CGPoint(x: insets, y: countryLabelOrigin.y + countryLabelHeight)
    static let headlineSize = CGSize(width: headlineWidth, height: headlineHeight)
    static let headlineRect = CGRect(origin: headlineOrigin, size: headlineSize)

    static let dateLabelWidth: CGFloat = width - (2 * insets)
    static var dateLabelHeight: CGFloat = 15
    static let dateLabelOrigin = CGPoint(x: insets, y: headlineOrigin.y + headlineHeight)
    static let dateLabelSize = CGSize(width: dateLabelWidth, height: dateLabelHeight)
    static let dateLabelRect = CGRect(origin: dateLabelOrigin, size: dateLabelSize)

    static let imageWidth: CGFloat = width - (2 * insets)
    static var imageHeight: CGFloat = 150
    static let imageOrigin = CGPoint(x: insets, y: dateLabelOrigin.y + dateLabelHeight + horizontalPadding)
    static let imageSize = CGSize(width: imageWidth, height: imageHeight)
    static let imageRect = CGRect(origin: imageOrigin, size: imageSize)

    static let loadingBarWidth: CGFloat = width - (4 * insets)
    static let loadingBarHeight: CGFloat = 10
    static let loadingBarOrigin = CGPoint(x: 2 * insets, y: imageOrigin.y + (imageHeight / 2) - loadingBarHeight)
    static let loadingBarSize = CGSize(width: loadingBarWidth, height: loadingBarHeight)
    static let loadingBarRect = CGRect(origin: loadingBarOrigin, size: loadingBarSize)
}
