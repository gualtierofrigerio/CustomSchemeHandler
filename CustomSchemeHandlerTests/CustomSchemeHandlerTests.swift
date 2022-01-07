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
        guard let task = schemeHandlerTest.schemeTask(forProductName: "Name1") else {
            XCTFail("Cannot create scheme task")
            return
        }
        guard let data = coreDataTest.data(forProductName: productName) else {
            XCTFail("Cannot get data for product")
            return
        }
        let expectation = expectation(description: "testCoreDataGet")
        
        task.expectData(data: data) { success in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.1)
    }
    
    func testCoreDataPost() {
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
