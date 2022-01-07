//
//  SchemeHandlerTest.swift
//  CustomSchemeHandlerTests
//
//  Created by Gualtiero Frigerio on 06/01/22.
//

import Foundation
import WebKit

enum SchemeHandlerTestType {
    case coreData
    case sql
}


class SchemeHandlerTest {
    init(type: SchemeHandlerTestType) {
        switch type {
        case .coreData:
            schemeString = "coredata"
        case .sql:
            schemeString = "sql"
        }
    }
    
    func schemeTask(forProductName name: String) -> WKURLSchemeTaskTest? {
        guard let url = urlForProduct(withName: name) else { return nil }
        return WKURLSchemeTaskTest(withRequest: URLRequest(url: url))
    }
    
    func urlForProduct(withName name: String) -> URL? {
        let urlString = schemeString + "://products?name=" + name
        return URL(string: urlString)
    }
    
    private var schemeString: String
}
