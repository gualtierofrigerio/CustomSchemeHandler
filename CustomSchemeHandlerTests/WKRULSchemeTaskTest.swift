//
//  WKRULSchemeTaskTest.swift
//  CustomSchemeHandlerTests
//
//  Created by Gualtiero Frigerio on 06/01/22.
//

import Foundation
import WebKit

class WKURLSchemeTaskTest: NSObject {
    private (set) var request: URLRequest
    
    init(withRequest: URLRequest) {
        self.request = withRequest
    }
    
    func expectData(data: Data, completionHandler: @escaping (Bool) -> Void) {
        self.expectedData = data
        self.completionHandler = completionHandler
    }
    
    private var completionHandler: ((Bool) -> Void)?
    private var expectedData: Data?
    private var receivedData: Data?
}

extension WKURLSchemeTaskTest: WKURLSchemeTask {
    func didReceive(_ response: URLResponse) {
        
    }
    
    func didReceive(_ data: Data) {
        if receivedData == nil {
            receivedData = data
        }
        else {
            receivedData?.append(data)
        }
    }
    
    func didFinish() {
        if receivedData == expectedData {
            completionHandler?(true)
        }
        else {
            completionHandler?(false)
        }
    }
    
    func didFailWithError(_ error: Error) {
        completionHandler?(false)
    }
}
