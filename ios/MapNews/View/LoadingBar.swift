//
//  LoadingBar.swift
//  MapNews
//
//  Created by Hol Yin Ho on 11/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import UIKit

class LoadingBar: UIView {
    private let loadingBar: UIView
    private let slider: UIView
    private var displayLink: CADisplayLink?
    var loadingBarColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) {
        didSet {
            loadingBar.backgroundColor = loadingBarColor
        }
    }
    var sliderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) {
        didSet {
            slider.backgroundColor = sliderColor
        }
    }
    var sliderFactor: CGFloat = 5 {
        didSet {
            slider.frame = CGRect(
                origin: slider.frame.origin,
                size: CGSize(width: frame.width / sliderFactor, height: frame.height)
            )
        }
    }

    static var advanceFactor: CGFloat = 2

    override init(frame: CGRect) {
        loadingBar = LoadingBar.createLoadingBar(width: frame.width, height: frame.height)
        loadingBar.backgroundColor = loadingBarColor

        slider = LoadingBar.createSlider(width: frame.width / sliderFactor, height: frame.height)
        slider.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)

        super.init(frame: frame)
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
        addSubview(loadingBar)
        addSubview(slider)

        animate()
    }

    override func removeFromSuperview() {
        displayLink?.invalidate()
        super.removeFromSuperview()
    }

    private func animate() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateAnimation))
        displayLink?.add(to: RunLoop.main, forMode: .common)
    }

    @objc private func updateAnimation() {
        slider.frame = getNextSliderFrame()
    }

    private func getNextSliderFrame() -> CGRect {
        let newX = sliderFrameExceedLimit() ? -slider.frame.width : slider.frame.origin.x + LoadingBar.advanceFactor
        return CGRect(origin: CGPoint(x: newX, y: slider.frame.origin.y), size: slider.frame.size)
    }

    private func sliderFrameExceedLimit() -> Bool {
        return slider.frame.origin.x + LoadingBar.advanceFactor > frame.width
    }

    static func createLoadingBar(width: CGFloat, height: CGFloat) -> UIView {
        let loadingBar = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)))
        return loadingBar
    }

    static func createSlider(width: CGFloat, height: CGFloat) -> UIView {
        let slider = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)))
        return slider
    }

    required init?(coder: NSCoder) {
        return nil
    }
}
