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
        let (response, data) = responseAndData(fromRequest: urlSchemeTask.request)
        
        urlSchemeTask.didReceive(response)
        if let data = data {
            urlSchemeTask.didReceive(data)
        }
        urlSchemeTask.didFinish()
    }
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        
    }
    
    // MARK: - Private

    private var sqlWrapper: SQLiteWrapper

    private func dataForURL_noquery(_ url: URL) -> Data? {
        guard let urlValue = url.host,
              let jsonObject = sqlWrapper.performQuery("select * from \(urlValue)") else { return nil }
        return JSONSerialization.data(fromJSON: jsonObject)
    }

    private func dataForURL(_ url: URL) -> Data? {
        guard let query = SQLQueryHelper.makeQuery(fromURL: url),
              let jsonObject = sqlWrapper.performQuery(query) else { return nil }
        return JSONSerialization.data(fromJSON: jsonObject)
    }
    
    private func responseAndData(fromRequest request: URLRequest) -> (URLResponse, Data?) {
        guard let url = request.url,
              let method = request.httpMethod else {
                  return Self.responseError(forUrl: request.url,
                                               message: "Error while parsing request")
              }
        if method == "POST" {
            return responseFromPOST(url: url, data: request.httpBody)
        }
        else {
            let data = dataForURL(url)
            let response = HTTPURLResponse.jsonResponse(url: url, data: data)
            return (response, data)
        }
    }
    
    private func responseFromPOST(url: URL, data: Data?) -> (URLResponse, Data?) {
        guard let insertQuery = SQLQueryHelper.makeInsert(url: url, data: data) else {
            return Self.responseError(forUrl: url,
                                         message: "Error while parsing request")
        }
        guard let jsonObject = sqlWrapper.performQuery(insertQuery) else {
            return Self.responseError(forUrl: url, message: "error while inserting data")
        }
        let returnData = JSONSerialization.data(fromJSON: jsonObject)
        let response = HTTPURLResponse.jsonResponse(url: url, data: data)
        return (response, returnData)
    }
}


