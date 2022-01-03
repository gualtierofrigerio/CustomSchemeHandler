//
//  CoreDataHelper.swift
//  CustomSchemeHandler
//
//  Created by Gualtiero Frigerio on 02/01/22.
//

import Foundation

class CoreDataHelper {
    class func predicate(fromURL url: URL) -> NSPredicate? {
        let queryItems = URLComponents(string: url.absoluteString)?.queryItems ?? []
        let whereDictionary: [String:String] = queryItems.reduce(into: [:]) { dictionary, item in
            if let value = item.value {
                dictionary[item.name] = value
            }
        }
        if whereDictionary.count == 0 {
            return nil
        }
        var whereStr = ""
        for (key, value) in whereDictionary {
            if whereStr != "" {
                whereStr += " and "
            }
            whereStr += "\(key) == \(value)"
        }
        return NSPredicate(format: whereStr)
    }
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
