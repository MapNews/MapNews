//
//  MapViewModelTests.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 1/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//


import XCTest
import GoogleMaps
@testable import MapNews

class MapViewModelTests: XCTestCase {
    var model: MapViewModel!
    var withImageCallBackExpectation: XCTestExpectation?
    var noImageCallBackExpectation: XCTestExpectation?

    override func setUp() {
        model = MapViewModel()
        model.database = MockDatabase()
        model.newsClient = MockNewsClient()
    }

    func testGetAllCountryCoordinateDTO_onInit() {
        XCTAssertEqual(model.allCountryCoordinateDTOs.count, 3)
    }

    func testAllCountries() {
        XCTAssertEqual(model.allCountryNames?.count ?? 0, 3)
    }

    func testAllCountriesAndCoordinatesDTOListener_withDatabase() {
        model.database = MockDatabaseOneEntry()
        XCTAssertEqual(model.allCountryCoordinateDTOs.count, 1)
    }

    func testCurrentBounds_countryInBounds() {
        let newBounds = GMSCoordinateBounds(
            coordinate: CLLocationCoordinate2D.from(Coordinates(lat: 1.352083, long: 103.819836)),
            coordinate: CLLocationCoordinate2D.from(Coordinates(lat: 35.86166, long: 104.195397))
        )
        model.currentBounds = newBounds
        XCTAssertTrue(model.allCountriesInBounds.contains(
            CountryCoordinateDTO(
                name: "Montreal",
                countryCode: "MN",
                coordinates: Coordinates(lat: 20.22, long: 103.988))
        ))
    }

    func testCurrentBounds_countryOutOfBounds() {
        let withoutChina = GMSCoordinateBounds(
            coordinate: CLLocationCoordinate2D.from(Coordinates(lat: 1.352083, long: 103.819836)),
            coordinate: CLLocationCoordinate2D.from(Coordinates(lat: 20.22, long: 103.988))
        )
        model.currentBounds = withoutChina
        XCTAssertFalse(model.allCountriesInBounds.contains(
            CountryCoordinateDTO(
                name: "China",
                countryCode: "CN",
                coordinates: Coordinates(lat: 35.86166, long: 104.195397))
        ))
    }

    func testUpdateNews_countryHasNoNews() {
        let mockObserver = MockModelObserver()
        mockObserver.updateHeadlineExpectation = expectation(description: "update headlines")
        model.addObserver(mockObserver)
        model.newsClient = MockNewsClient()

        let atlantisDto = CountryCoordinateDTO(name: "Atlantis", countryCode: "AT", coordinates: Coordinates(lat: 0.4, long: 0.2))

        model.updateNews(country: atlantisDto)
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(mockObserver.updatedHeadlines, "No articles :(")
    }

    func testUpdateNews_countryHasNews() {
        let mockObserver = MockModelObserver()
        mockObserver.updateHeadlineExpectation = expectation(description: "update headlines")
        model.addObserver(mockObserver)
        let singaporeDTO = CountryCoordinateDTO(
            name: "Singapore",
            countryCode: "SG",
            coordinates: Coordinates(lat: 1.352083, long: 103.819836))

        model.updateNews(country: singaporeDTO)

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(mockObserver.updatedHeadlines, "test headlines")
    }

    func testAddObserver() {
        let previousCount = model.observers.count
        let mockObserver = MockModelObserver()
        model.addObserver(mockObserver)
        XCTAssertEqual(model.observers.count, previousCount + 1)
    }

    func testGetCountryCoordinateDTO_countryNotInDatabase() {
        XCTAssertNil(model.getCountryCoordinateDTO(for: "Atlantis"))
    }

    func testGetCountryCoordinateDTO_countryInDatabase() {
        let singaporeDTO = CountryCoordinateDTO(
            name: "Singapore",
            countryCode: "SG",
            coordinates: Coordinates(lat: 1.352083, long: 103.819836))
        let chinaDTO = CountryCoordinateDTO(
            name: "China",
            countryCode: "CN",
            coordinates: Coordinates(lat: 35.86166, long: 104.195397))
        let montrealDTO = CountryCoordinateDTO(
            name: "Montreal",
            countryCode: "MN",
            coordinates: Coordinates(lat: 20.22, long: 103.988))
        XCTAssertEqual(
            model.getCountryCoordinateDTO(for: "Singapore"),
            singaporeDTO
        )
        XCTAssertEqual(
            model.getCountryCoordinateDTO(for: "China"),
            chinaDTO
        )
        XCTAssertEqual(
            model.getCountryCoordinateDTO(for: "Montreal"),
            montrealDTO
        )
    }

    func testLoadImage_invalidUrl() {
        let invalidUrl = ""
        noImageCallBackExpectation = expectation(description: "no image")

        model.loadImage(
            url: invalidUrl,
            withImageCallback: withImageCallback(_:),
            noImageCallback: noImageCallback)

        waitForExpectations(timeout: 0, handler: nil)
    }

    func testLoadImage_validUrl() {
        let validUrl = "https://gamepedia.cursecdn"
            + ".com/minecraft_gamepedia/thumb/8/82/Duncan_Geere_Mojang_avatar"
            + ".png/64px-Duncan_Geere_Mojang_avatar"
            + ".png?version=48ddfefae25053fb7b140c6eec865641"
        withImageCallBackExpectation = expectation(description: "have image")

        model.loadImage(
            url: validUrl,
            withImageCallback: withImageCallback(_:),
            noImageCallback: noImageCallback)

        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension MapViewModelTests {
    func withImageCallback(_ image: UIImage) {
        withImageCallBackExpectation?.fulfill()
    }

    func noImageCallback() {
        noImageCallBackExpectation?.fulfill()
    }
}

class MockNewsClient: NewsClient {
    func queryArticles(country: CountryCoordinateDTO, callback: @escaping ([ArticleDTO], CountryCoordinateDTO) -> Void) {
        if country.countryName == "Singapore" {
            let sampleArticle = ArticleBuilder().withTitle(title: "test headlines").build()
            DispatchQueue.main.async {
                callback([sampleArticle], country)
            }
        } else {
            DispatchQueue.main.async {
                callback([], country)
            }
        }
    }

    func downloadImage(from url: URL, callback: @escaping (UIImage) -> Void) {
        DispatchQueue.main.async {
            callback(UIImage())
        }
    }
}

class MockModelObserver: MapViewModelObserver {
    var updateHeadlineExpectation: XCTestExpectation?
    var updatedHeadlines: String?

    func updateHeadlines(country: CountryCoordinateDTO, article: ArticleDTO) {
        updateHeadlineExpectation?.fulfill()
        updatedHeadlines = article.title
    }
}

class MockDatabase: Database {
    let singaporeDTO = CountryCoordinateDTO(
        name: "Singapore",
        countryCode: "SG",
        coordinates: Coordinates(lat: 1.352083, long: 103.819836))
    let chinaDTO = CountryCoordinateDTO(
        name: "China",
        countryCode: "CN",
        coordinates: Coordinates(lat: 35.86166, long: 104.195397))
    let montrealDTO = CountryCoordinateDTO(
        name: "Montreal",
        countryCode: "MN",
        coordinates: Coordinates(lat: 20.22, long: 103.988))

    func queryLatLong(name: String) -> Coordinates? {
        if name == "Singapore" {
            return singaporeDTO.coordinates
        }
        if name == "China" {
            return chinaDTO.coordinates
        }
        if name == "Montreal" {
            return montrealDTO.coordinates
        }
        return nil
    }

    func queryAllCountries() -> [String]? {
        return ["Singapore", "China", "Montreal"]
    }

    func queryAllCountriesAndCoordinates() -> [CountryCoordinateDTO]? {
        return [singaporeDTO, chinaDTO, montrealDTO]
    }

    func populateDatabaseWithCountries() {
    }

    func clearTable() {
    }

    func queryCountryDTO(name: String) -> CountryCoordinateDTO? {
        if name == "Singapore" {
            return singaporeDTO
        }
        if name == "China" {
            return chinaDTO
        }
        if name == "Montreal" {
            return montrealDTO
        }
        return nil
    }
}

class MockDatabaseOneEntry: Database {
    let hogwartsDTO = CountryCoordinateDTO(
        name: "Hogwarts",
        countryCode: "HW",
        coordinates: Coordinates(lat: 1.1, long: 102.78))
    func queryAllCountriesAndCoordinates() -> [CountryCoordinateDTO]? {
        return [ hogwartsDTO ]
    }

    func queryLatLong(name: String) -> Coordinates? {
        if name == "Hogwarts" {
            return hogwartsDTO.coordinates
        }
        return nil
    }

    func queryAllCountries() -> [String]? {
        return ["Hogwarts"]
    }

    func populateDatabaseWithCountries() {
    }

    func clearTable() {
    }

    func queryCountryDTO(name: String) -> CountryCoordinateDTO? {
        if name == "Hogwarts" {
            return hogwartsDTO
        }
        return nil
    }
}
