//
//  WebsiteViewController.swift
//  MapNews
//
//  Created by Hol Yin Ho on 1/7/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import UIKit
import WebKit
class WebsiteViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!
    var url: String?
    var countryName: String?

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let urlString = url else {
            return
        }
        let myURL = URL(string: urlString)
        let myRequest = URLRequest(url: myURL!)
        AccessibilityIdentifierUtil.setIdentifierForContainer(
            view: webView,
            to: Identifiers.generateWebViewIdentifier(country: countryName ?? "")
        )
        webView.load(myRequest)
    }
}
