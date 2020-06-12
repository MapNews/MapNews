//
//  ArticleBuilderTests.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 12/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import XCTest

class ArticleBuilderTests: XCTestCase {
    func testBuild_noArgumentsSupplied() {
        let emptyArticle = ArticleBuilder().build()
        XCTAssertEqual(emptyArticle.source, "")
        XCTAssertEqual(emptyArticle.author, "")
        XCTAssertEqual(emptyArticle.title, "")
        XCTAssertEqual(emptyArticle.desc, "")
        XCTAssertEqual(emptyArticle.url, "")
        XCTAssertNil(emptyArticle.urlToImage)
        XCTAssertEqual(emptyArticle.publishedAt, "")
        XCTAssertEqual(emptyArticle.content, "")
    }

    func testBuild_withSource() {
        let articleWithSource = ArticleBuilder().withSource(source: "test source").build()
        XCTAssertEqual(articleWithSource.source, "test source")
        XCTAssertEqual(articleWithSource.author, "")
        XCTAssertEqual(articleWithSource.title, "")
        XCTAssertEqual(articleWithSource.desc, "")
        XCTAssertEqual(articleWithSource.url, "")
        XCTAssertNil(articleWithSource.urlToImage)
        XCTAssertEqual(articleWithSource.publishedAt, "")
        XCTAssertEqual(articleWithSource.content, "")
    }

    func testBuild_withAuthor() {
        let articleWithAuthor = ArticleBuilder().withAuthor(author: "J K Rowling").build()
        XCTAssertEqual(articleWithAuthor.source, "")
        XCTAssertEqual(articleWithAuthor.author, "J K Rowling")
        XCTAssertEqual(articleWithAuthor.title, "")
        XCTAssertEqual(articleWithAuthor.desc, "")
        XCTAssertEqual(articleWithAuthor.url, "")
        XCTAssertNil(articleWithAuthor.urlToImage)
        XCTAssertEqual(articleWithAuthor.publishedAt, "")
        XCTAssertEqual(articleWithAuthor.content, "")
    }

    func testBuild_withTitle() {
        let articleWithTitle = ArticleBuilder().withTitle(title: "Harry Botter").build()
        XCTAssertEqual(articleWithTitle.source, "")
        XCTAssertEqual(articleWithTitle.author, "")
        XCTAssertEqual(articleWithTitle.title, "Harry Botter")
        XCTAssertEqual(articleWithTitle.desc, "")
        XCTAssertEqual(articleWithTitle.url, "")
        XCTAssertNil(articleWithTitle.urlToImage)
        XCTAssertEqual(articleWithTitle.publishedAt, "")
        XCTAssertEqual(articleWithTitle.content, "")
    }

    func testBuild_withDesc() {
        let articleWithDesc = ArticleBuilder().withDesc(desc: "Climb up the chiminey").build()
        XCTAssertEqual(articleWithDesc.source, "")
        XCTAssertEqual(articleWithDesc.author, "")
        XCTAssertEqual(articleWithDesc.title, "")
        XCTAssertEqual(articleWithDesc.desc, "Climb up the chiminey")
        XCTAssertEqual(articleWithDesc.url, "")
        XCTAssertNil(articleWithDesc.urlToImage)
        XCTAssertEqual(articleWithDesc.publishedAt, "")
        XCTAssertEqual(articleWithDesc.content, "")
    }

    func testBuild_withUrl() {
        let articleWithUrl = ArticleBuilder().withUrl(url: "https://www.google.com").build()
        XCTAssertEqual(articleWithUrl.source, "")
        XCTAssertEqual(articleWithUrl.author, "")
        XCTAssertEqual(articleWithUrl.title, "")
        XCTAssertEqual(articleWithUrl.desc, "")
        XCTAssertEqual(articleWithUrl.url, "https://www.google.com")
        XCTAssertNil(articleWithUrl.urlToImage)
        XCTAssertEqual(articleWithUrl.publishedAt, "")
        XCTAssertEqual(articleWithUrl.content, "")
    }

    func testBuild_withUrlToImage() {
        let articleWithUrlToImage = ArticleBuilder().withUrlToImage(url: "https://www.google.com/images").build()
        XCTAssertEqual(articleWithUrlToImage.source, "")
        XCTAssertEqual(articleWithUrlToImage.author, "")
        XCTAssertEqual(articleWithUrlToImage.title, "")
        XCTAssertEqual(articleWithUrlToImage.desc, "")
        XCTAssertEqual(articleWithUrlToImage.url, "")
        XCTAssertEqual(articleWithUrlToImage.urlToImage, "https://www.google.com/images")
        XCTAssertEqual(articleWithUrlToImage.publishedAt, "")
        XCTAssertEqual(articleWithUrlToImage.content, "")
    }

    func testBuild_withPublishedAt() {
        let articleWithPublishedAt = ArticleBuilder().withPublishedTime(time: "30/02/2012 8pm").build()
        XCTAssertEqual(articleWithPublishedAt.source, "")
        XCTAssertEqual(articleWithPublishedAt.author, "")
        XCTAssertEqual(articleWithPublishedAt.title, "")
        XCTAssertEqual(articleWithPublishedAt.desc, "")
        XCTAssertEqual(articleWithPublishedAt.url, "")
        XCTAssertNil(articleWithPublishedAt.urlToImage)
        XCTAssertEqual(articleWithPublishedAt.publishedAt, "30/02/2012 8pm")
        XCTAssertEqual(articleWithPublishedAt.content, "")
    }

    func testBuild_withContent() {
        let articleWithContent = ArticleBuilder().withContent(content: "Lorem ipsum climb up the wall").build()
        XCTAssertEqual(articleWithContent.source, "")
        XCTAssertEqual(articleWithContent.author, "")
        XCTAssertEqual(articleWithContent.title, "")
        XCTAssertEqual(articleWithContent.desc, "")
        XCTAssertEqual(articleWithContent.url, "")
        XCTAssertNil(articleWithContent.urlToImage)
        XCTAssertEqual(articleWithContent.publishedAt, "")
        XCTAssertEqual(articleWithContent.content, "Lorem ipsum climb up the wall")
    }

    func testBuild_withAllArgumentsSupplied() {
        let article = ArticleBuilder()
            .withSource(source: "test source")
            .withAuthor(author: "J K Rowling")
            .withTitle(title: "Harry Botter")
            .withDesc(desc: "Climb up the chiminey")
            .withUrl(url: "https://www.google.com")
            .withUrlToImage(url: "https://www.google.com/images")
            .withPublishedTime(time: "30/02/2012 8pm")
            .withContent(content: "Lorem ipsum climb up the wall")
            .build()

        XCTAssertEqual(article.source, "test source")
        XCTAssertEqual(article.author, "J K Rowling")
        XCTAssertEqual(article.title, "Harry Botter")
        XCTAssertEqual(article.desc, "Climb up the chiminey")
        XCTAssertEqual(article.url, "https://www.google.com")
        XCTAssertEqual(article.urlToImage, "https://www.google.com/images")
        XCTAssertEqual(article.publishedAt, "30/02/2012 8pm")
        XCTAssertEqual(article.content, "Lorem ipsum climb up the wall")
    }
}
