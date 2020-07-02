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

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let myURL = URL(string:"https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
