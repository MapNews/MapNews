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
        selector.isSearchButtonHidden = true
        selector.observer = self
        return selector
    }()
    lazy var header: UILabel = {
        let padding = MapNewsSelector.selectorPadding
        let headerWidth = UIScreen.main.bounds.width - (2 * padding)
        let headerHeight = padding
        let headerOrigin = CGPoint(x: padding, y: padding)
        let header = UILabel(frame: CGRect(origin: headerOrigin, size: CGSize(width: headerWidth, height: headerHeight)))
        header.text = "Choose a default location:"
        header.font = UIFont.boldSystemFont(ofSize: 24)
        return header
    }()
    override func viewDidLoad() {
        view.addSubview(header)
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
        self.dismiss(animated: true, completion: {
            presenter.viewDidLoad()
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        guard let presenter = presentingViewController as? MapViewController else {
            return
        }
        presenter.viewDidLoad()
    }
}
