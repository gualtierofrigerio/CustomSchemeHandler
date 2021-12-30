//
//  SchemeHandler.swift
//  CustomSchemeHandler
//
//  Created by Gualtiero Frigerio on 24/12/21.
//

import Foundation
import WebKit

enum SchemeHandlerType {
    case assets
    case sqlite(databasePath: String)
}

protocol SchemeHandler: WKURLSchemeHandler {
    
}

/// extension to add a default HTTPURLResponse in case of error to be used by concrete types
extension SchemeHandler {
    static func responseError(forUrl url: URL?, message: String) -> (HTTPURLResponse, Data) {
        let responseUrl = url ?? URL(string: "error://error")!
        let response = HTTPURLResponse(url: responseUrl,
                                       mimeType: nil,
                                       expectedContentLength: message.count,
                                       textEncodingName: "utf-8")
        let data = message.data(using: .utf8) ?? Data()
        return (response, data)
    }
}

class SchemeHandlerFactory {
    static func createWithType(_ type: SchemeHandlerType) -> SchemeHandler {
        switch type {
        case .assets:
            return AssetsSchemeHandler()
        case .sqlite(let databasePath):
            return SQLiteSchemeHandler(databasePath: databasePath)
        }
    }
}

struct SchemeHandlerEntry {
    var schemeHandler: SchemeHandler
    var urlScheme: String
}
