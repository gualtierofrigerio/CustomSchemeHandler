//
//  JSONSerialization+ext.swift
//  CustomSchemeHandler
//
//  Created by Gualtiero Frigerio on 29/12/21.
//

import Foundation

extension JSONSerialization {
    static func data(fromJSON jsonObject: Any) -> Data? {
        if isValidJSONObject(jsonObject) {
            return try? JSONSerialization.data(withJSONObject: jsonObject,
                                               options: .fragmentsAllowed)
        }
        return nil
    }
}
