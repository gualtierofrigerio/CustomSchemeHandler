//
//  SchemeHandler.swift
//  CustomSchemeHandler
//
//  Created by Gualtiero Frigerio on 24/12/21.
//

import Foundation

import WebKit

class SQLiteSchemeHandler: NSObject, SchemeHandler {
    init(databasePath: String) {
        sqlWrapper = SQLiteWrapper(path: databasePath)
    }
    
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        guard let url = urlSchemeTask.request.url else { return }
        let data = dataForURL(url)
        let response = HTTPURLResponse(url: url,
                                       mimeType: "application/json",
                                       expectedContentLength: data?.count ?? 0,
                                       textEncodingName: "utf-8")
        
        urlSchemeTask.didReceive(response)
        if let data = data {
            urlSchemeTask.didReceive(data)
        }
        urlSchemeTask.didFinish()
    }
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        
    }
}

// MARK: - Private

private var sqlWrapper: SQLiteWrapper?

private func dataForURL_noquery(_ url: URL) -> Data? {
    var data: Data?
    guard let wrapper = sqlWrapper,
          let urlValue = url.host,
          let jsonObject = wrapper.performQuery("select * from \(urlValue)") else { return nil }
    if JSONSerialization.isValidJSONObject(jsonObject) {
        data = try? JSONSerialization.data(withJSONObject: jsonObject,
                                           options: .fragmentsAllowed)
    }
    return data
}

private func dataForURL(_ url: URL) -> Data? {
    var data: Data?
    guard let wrapper = sqlWrapper,
          let host = url.host else { return nil }
    let queryItems = URLComponents(string: url.absoluteString)?.queryItems ?? []
    var query: String = ""
    if queryItems.count > 0 {
        var whereStr = ""
        for item in queryItems {
            if let value = item.value {
                if whereStr != "" {
                    whereStr += " AND "
                }
                whereStr += "\(item.name) = \(value)"
            }
        }
        query = "select * from \(host) WHERE \(whereStr)"
    }
    else {
        query = "select * from \(host)"
    }
    
    guard let jsonObject = wrapper.performQuery(query) else { return nil }
    if JSONSerialization.isValidJSONObject(jsonObject) {
        data = try? JSONSerialization.data(withJSONObject: jsonObject,
                                           options: .fragmentsAllowed)
    }
    return data
}
