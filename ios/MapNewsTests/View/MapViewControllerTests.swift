//
//  MapViewControllerTests.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 10/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import XCTest
import GoogleMaps

class MapViewControllerTests: XCTestCase {
    var viewController: MapViewController!

    override func setUp() {
        viewController = MapViewController()
        viewController.viewDidLoad()
        viewController.mapView.location
            = CLLocationCoordinate2D.from(Coordinates(lat: 1.1, long: 102.78)!)
        viewController.model = ModelStub()
        viewController.model.addObserver(viewController)
    }

    func testSubviewsExistence() {
        let subviews = viewController.view.subviews.map { String(describing: type(of: $0)) }
        XCTAssertTrue(subviews.contains("MapNewsView"))
        XCTAssertTrue(subviews.contains("MapNewsSelector"))
        XCTAssertTrue(subviews.contains("UIView"))
    }

    func testLocationDidUpdate_locationDoesNotExists() {
        let originalBounds = viewController.model.currentBounds
        viewController.locationDidUpdate(toLocation: "HegHeg")
        let currentBounds = viewController.model.currentBounds
        XCTAssertEqual(
            originalBounds,
            currentBounds, 
            "Bounds should not be updated if location name is not valid"
        )
        XCTAssertNil(
            viewController.currentDisplayingInfoWindow,
            "No marker should be selected"
        )
        XCTAssertNotEqual(viewController.locationSelector.selectedValue, "HegHeg")
    }

    func testLocationDidUpdate_locationExists() {
        let originalBounds = viewController.model.currentBounds
        viewController.locationDidUpdate(toLocation: "Atlantis")
        let currentBounds = viewController.model.currentBounds
        XCTAssertNotEqual(
            originalBounds,
            currentBounds,
            "Bounds should be updated if location name is valid"
        )
        XCTAssertEqual(viewController.currentDisplayingInfoWindow?.countryName, "Atlantis")

        viewController.locationDidUpdate(toLocation: "Hogwarts")
        XCTAssertEqual(viewController.currentDisplayingInfoWindow?.countryName, "Hogwarts")
        XCTAssertEqual(viewController.locationSelector.selectedValue, "Hogwarts")
    }

    func testTableDidReveal_noInfoWindowDisplayed() {
        viewController.tableDidReveal()
        XCTAssertNil(viewController.currentDisplayingInfoWindow)
        XCTAssertFalse(viewController.locationSelectorMask.isHidden)
    }

    func testTableDidReveal_infoWindowDisplayed() {
        viewController.locationDidUpdate(toLocation: "Atlantis")
        XCTAssertEqual(viewController.currentDisplayingInfoWindow?.countryName, "Atlantis")
        viewController.tableDidReveal()
        XCTAssertNil(viewController.currentDisplayingInfoWindow)
        XCTAssertFalse(viewController.locationSelectorMask.isHidden)
    }

    func testTableDidHide() {
        viewController.tableDidHide()
        XCTAssertTrue(viewController.locationSelectorMask.isHidden)
    }

    func testUpdateHeadlines_countryDoesNotExist() {
        let singaporeDTO = CountryCoordinateDTO(
            name: "Singapore",
            countryCode: "SG",
            coordinates: Coordinates(lat: 0.3, long: 0.4)!)
        viewController.updateHeadlines(country: singaporeDTO, article: ModelStub.sampleArticle)
        XCTAssertNil(viewController.currentDisplayingInfoWindow)
    }

    func testUpdateHeadlines_countryExist() {
        viewController.updateHeadlines(country: ModelStub.hogwartsDTO, article: ModelStub.sampleArticle)
        XCTAssertEqual(viewController.currentDisplayingInfoWindow?.countryName, "Hogwarts")
        viewController.currentDisplayingInfoWindow?.loadingBar.removeFromSuperview()
    }

    func testUpdateHeadlines_noImageInArticle() {
        let sampleArticleNoImage = ArticleBuilder.from(article: ModelStub.sampleArticle).withUrlToImage(url: nil).build()
        viewController.updateHeadlines(country: ModelStub.hogwartsDTO, article: sampleArticleNoImage)
        XCTAssertEqual(viewController.currentDisplayingInfoWindow?.countryName, "Hogwarts")
    }

    func testNoCountries_noData() {
        viewController.model = NoCountriesModelStub()
        XCTAssertEqual(viewController.allCountries, ["No data"])
    }
}

class NoCountriesModelStub: Model {
    func addObserver(_ observer: MapViewModelObserver) {
    }

    var defaultLocation: String?

    func setDefaultLocation(to country: String) {
    }

    var allCountryNames: [String]? = nil

    var observers: [MapViewModelObserver] = []

    var currentBounds = GMSCoordinateBounds(
        coordinate: CLLocationCoordinate2D.from(ModelStub.hogwartsDTO.coordinates)!,
        coordinate: CLLocationCoordinate2D.from(ModelStub.atlantisDTO.coordinates)!
    )

    var allCountriesInBounds: [CountryCoordinateDTO] = []

    func updateNews(country: CountryCoordinateDTO) {
    }

    func getCountryCoordinateDTO(for country: String) -> CountryCoordinateDTO? {
        return nil
    }

    func loadImage(url: String, withImageCallback: @escaping (UIImage) -> Void, noImageCallback: () -> Void) {
    }
}

class ModelStub: Model {
    var observers: [MapViewModelObserver] = []
    var defaultLocation: String?

    func setDefaultLocation(to country: String) {

    }
    
    func addObserver(_ observer: MapViewModelObserver) {
        observers.append(observer)
    }

    static let hogwartsDTO = CountryCoordinateDTO(
        name: "Hogwarts",
        countryCode: "HW",
        coordinates: Coordinates(lat: 1.1, long: 102.78)!)
    static let atlantisDTO = CountryCoordinateDTO(
        name: "Atlantis",
        countryCode: "AT",
        coordinates: Coordinates(lat: 1.0, long: 102.98)!)
    static let sampleArticle = ArticleBuilder()
        .withSource(source: "CNA")
        .withAuthor(author: author)
        .withTitle(title: title)
        .withDesc(desc: desc)
        .withUrl(url: url)
        .withUrlToImage(url: urlToImage)
        .withPublishedTime(time: publishedAt)
        .withContent(content: content)
        .build()

    var allCountryNames: [String]? = ["Hogwarts", "Atlantis"]

    var currentBounds = GMSCoordinateBounds(
        coordinate: CLLocationCoordinate2D.from(ModelStub.hogwartsDTO.coordinates)!,
        coordinate: CLLocationCoordinate2D.from(ModelStub.atlantisDTO.coordinates)!
    )

    var allCountriesInBounds = [ModelStub.hogwartsDTO, ModelStub.atlantisDTO]

    func updateNews(country: CountryCoordinateDTO) {
        observers.forEach { $0.updateHeadlines(country: country, article: ModelStub.sampleArticle) }
    }

    func getCountryCoordinateDTO(for country: String) -> CountryCoordinateDTO? {
        if country == "Hogwarts" {
            return ModelStub.hogwartsDTO
        }
        if country == "Atlantis" {
            return ModelStub.atlantisDTO
        }
        return nil
    }

    func loadImage(url: String, withImageCallback: @escaping (UIImage) -> Void, noImageCallback: () -> Void) {
    }
}

extension ModelStub {
    static let author = "Michael Yong"
    static let title = "Doctors in Singapore advised to look out for blood, heart problems in COVID-19 patients - CNA"
    static let desc = "Four COVID-19 cases in Singapore died in May because of heart-related issues, and not of the disease."
    static let url = "https://www.channelnewsasia"
        + ".com/news/singapore/covid-19-cases-singapore-heart-issues-blood-doctors-12805406"
    static let urlToImage = "https://cna-sg-res.cloudinary"
        + ".com/image/upload/q_auto,f_auto/image/12668676/16x9/"
        + "991/557/eee906a31bd1bd1a3972c22d1ddd4f2/pQ/coronavirus-cells.jpg"
    static let publishedAt = "2020-06-08T00:12:07Z"
    static let content = "SINGAPORE: Doctors in Singapore have been advised to be watchful for cardiovascular symptoms "
        + "in COVID-19 patients, with emerging data globally about the increased risks of blood clots ..."
}
