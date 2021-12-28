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
