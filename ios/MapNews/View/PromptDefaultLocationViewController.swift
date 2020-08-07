//
//  PromptDefaultLocationViewController.swift
//  MapNews
//
//  Created by Hol Yin Ho on 5/8/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import UIKit

class PromptDefaultLocationViewController: UIViewController {
    var countries: [String] = []
    var selectCountryCallback: (String) -> Void = {_ in }
    lazy var selector: MapNewsSelector = {
        let padding = MapNewsSelector.selectorPadding
        let selectorWidth = UIScreen.main.bounds.width - (2 * padding)
        let selectorHeight = UIScreen.main.bounds.height * 0.6
        let selectorOrigin = CGPoint(x: padding, y: padding * 2)
        let openedRect = CGRect(origin: selectorOrigin, size: CGSize(width: selectorWidth, height: selectorHeight))
        let closedRect = CGRect(origin: selectorOrigin, size: CGSize(width: selectorWidth, height: MapNewsSelector.labelHeight))
        let selector = MapNewsSelector.getSelector(tableData: countries, mode: mode, openedFrame: openedRect, closedFrame: closedRect)
        selector.observer = self
        selector.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        selector.layer.borderWidth = 2
        selector.closeSelector()
        selector.openSelector()
        return selector
    }()
    override func viewDidLoad() {
        view.addSubview(selector)
    }
    var mode: UIUserInterfaceStyle {
        UIScreen.main.traitCollection.userInterfaceStyle
    }
}

extension PromptDefaultLocationViewController: MapNewsSelectorObserver {
    func tableDidReveal() {

    }

    func tableDidHide() {

    }

    func locationDidUpdate(toLocation newLocation: String) {
        guard let presenter = presentingViewController as? MapViewController else {
            return
        }
        presenter.setDefaultLocation(to: newLocation)
        selector.removeFromSuperview()
        self.dismiss(animated: true, completion: {})
    }
}
