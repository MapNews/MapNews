//
//  LoadingBar.swift
//  MapNews
//
//  Created by Hol Yin Ho on 11/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import UIKit

class LoadingBar: UIView {
    let loadingBar: UIView
    let slider: UIView
    var displayLink: CADisplayLink?

    override init(frame: CGRect) {
        let width = frame.width
        let height = frame.height
        loadingBar = LoadingBar.createLoadingBar(width: width, height: height)
        slider = LoadingBar.createSlider(width: width / 5, height: height)
        super.init(frame: frame)
        layer.cornerRadius = height / 2
        clipsToBounds = true
        addSubview(loadingBar)
        addSubview(slider)

        animate()
    }

    override func removeFromSuperview() {
        displayLink?.remove(from: RunLoop.main, forMode: .common)
        super.removeFromSuperview()
    }

    private func animate() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateAnimation))
        displayLink?.add(to: RunLoop.main, forMode: .common)
    }

    @objc private func updateAnimation() {
        slider.frame = getNextFrame(from: slider.frame)
    }

    private func getNextFrame(from frame: CGRect) -> CGRect {
        let newX = frame.origin.x + 2 > self.frame.width ? -slider.frame.width : frame.origin.x + 2
        return CGRect(origin: CGPoint(x: newX, y: frame.origin.y), size: frame.size)
    }

    static func createLoadingBar(width: CGFloat, height: CGFloat) -> UIView {
        let loadingBar = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)))
        loadingBar.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return loadingBar
    }

    static func createSlider(width: CGFloat, height: CGFloat) -> UIView {
        let slider = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)))
        slider.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        return slider
    }

    required init?(coder: NSCoder) {
        return nil
    }
}
