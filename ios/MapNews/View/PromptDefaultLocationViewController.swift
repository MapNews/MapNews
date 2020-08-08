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
        let selector = MapNewsSelector(tableData: countries, mode: mode, openedFrame: openedRect, closedFrame: closedRect)
        selector.observer = self
        return selector
    }()
    override func viewDidLoad() {
        view.addSubview(selector)
        selector.openSelector()
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
        self.dismiss(animated: true, completion: {
            presenter.viewDidLoad()
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        guard let presenter = presentingViewController as? MapViewController else {
            return
        }
        selector.removeFromSuperview()
        presenter.viewDidLoad()
    }
}
