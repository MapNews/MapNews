//
//  Identifiers.swift
//  MapNews
//
//  Created by Hol Yin Ho on 21/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

struct Identifiers {
    static let mapViewControllerIdentifier = "MapViewController"
    static let mapNewsIdentifier = "MapNewsView"
    static let selectorIdentifier = "MapNewsSelector"
    static let textFieldIdentifier =  "SelectedCountryTextField"
    static let tableIdentifier = "TableView"
    static let labelBackgroundIdentifier = "LabelBackground"
    static let searchButtonIdentifier = "SearchButton"
    static let locationMaskIdentifier = "LocationMask"
    static let infoWindowIdentifier = "InfoWindow"
    static let infoWindowCrossButtonIdentifier = "InfoWindowCrossButton"

    static func generateCellIdentifier(index: Int) -> String {
        "Cell\(index)"
    }

    static func generateInfoWindowIdentifier(country: String) -> String {
        "InfoWindow_\(country)"
    }

    static func generateMarkerIdentifer(country: String) -> String {
        "Marker_\(country)"
    }

    static func generateInfoWindowImageIdentifier(country: String) -> String {
        "InfoWindowImage_\(country)"
    }

    static func generateInfoWindowHeadlineIdentifier(country: String) -> String {
        "InfoWindowHeadline_\(country)"
    }

    static func generateWebViewIdentifier(country: String) -> String {
        "WebView_\(country)"
    }
}
