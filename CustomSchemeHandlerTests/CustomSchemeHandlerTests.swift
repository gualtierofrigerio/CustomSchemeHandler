//
//  CustomSchemeHandlerTests.swift
//  CustomSchemeHandlerTests
//
//  Created by Gualtiero Frigerio on 24/12/21.
//

import CoreData
import XCTest
@testable import CustomSchemeHandler
import WebKit

class CustomSchemeHandlerTests: XCTestCase {
    var coreDataSchemeHandler: CoreDataSchemeHandler!
    var coreDataTest: CoreDataTest!
    var schemeHandlerTest: SchemeHandlerTest!
    var webViewTest: WKWebView!

    override func setUpWithError() throws {
        coreDataTest = CoreDataTest()
        coreDataSchemeHandler = CoreDataSchemeHandler(managedContext: coreDataTest.container.viewContext)
        try coreDataTest.loadTestData()
        schemeHandlerTest = SchemeHandlerTest(type: .coreData)
        webViewTest = WKWebView()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCoreDataGet() {
        let productName = "Name1"
        guard let data = coreDataTest.dataArray(forProductName: productName) else {
            XCTFail("Cannot get data for product")
            return
        }
        guard let task = schemeHandlerTest.schemeTask(forProductName: productName) else {
            XCTFail("Cannot create scheme task")
            return
        }
        let expectation = expectation(description: "testCoreDataGet")
        
        task.expectData(data: data) { success in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        coreDataSchemeHandler.webView(webViewTest, start: task)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testCoreDataGetAsync() async {
        let productName = "Name1"
        guard let data = coreDataTest.dataArray(forProductName: productName) else {
            XCTFail("Cannot get data for product")
            return
        }
        guard let task = schemeHandlerTest.schemeTask(forProductName: productName) else {
            XCTFail("Cannot create scheme task")
            return
        }
        let success: Bool = await withUnsafeContinuation{ continuation in
            task.expectData(data: data) { success in
                continuation.resume(returning: success)
            }
            coreDataSchemeHandler.webView(webViewTest, start: task)
        }
        XCTAssertTrue(success)
    }
    
    func testCoreDataPost() {
        let productName = "Name2"
        guard let data = coreDataTest.data(forProductName: productName) else {
            XCTFail("Cannot get data for product")
            return
        }
        guard let task = schemeHandlerTest.schemeTaskPost(forProductName: productName,
                                                          data: data) else {
            XCTFail("Cannot create scheme task")
            return
        }
        let expectation = expectation(description: "testCoreDataPost")
        let successResponse = "success".data(using: .utf8)!
        
        task.expectData(data: successResponse) { success in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        coreDataSchemeHandler.webView(webViewTest, start: task)
        
        waitForExpectations(timeout: 1.0)
    }

}
