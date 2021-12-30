//
//  SQLQueryHelper.swift
//  CustomSchemeHandler
//
//  Created by Gualtiero Frigerio on 30/12/21.
//

import Foundation

class SQLQueryHelper {
    class func makeInsert(url: URL, data: Data?) -> String? {
        guard let data = data,
              let tableName = url.host,
              let dataDictionary = try? JSONSerialization.jsonObject(with: data,
                                                                     options: .fragmentsAllowed) as? [String: String]
        else {
            return nil
        }
        var fields = ""
        var values = ""
        for (key, value) in dataDictionary {
            if fields != "" {
                fields += ","
                values += ","
            }
            fields += key
            values += "'" + value + "'"
        }
        let insertQuery = "insert into \(tableName) (\(fields)) values (\(values))"
        return insertQuery
    }
    
    class func makeQuery(fromURL url: URL) -> String? {
        guard let table = url.host else { return nil }
        let queryItems = URLComponents(string: url.absoluteString)?.queryItems ?? []
        let whereDictionary: [String:String] = queryItems.reduce(into: [:]) { dictionary, item in
            if let value = item.value {
                dictionary[item.name] = value
            }
        }
        return makeQuery(table: table, whereDictionary: whereDictionary)
    }
    
    class func makeQuery(table: String, whereDictionary: [String: String]) -> String {
        var query: String = ""
        if whereDictionary.count > 0 {
            var whereStr = ""
            for (key, value) in whereDictionary {
                if whereStr != "" {
                    whereStr += " AND "
                }
                whereStr += "\(key) = \(value)"
            }
            query = "select * from \(table) WHERE \(whereStr)"
        }
        else {
            query = "select * from \(table)"
        }
        return query
    }
}
