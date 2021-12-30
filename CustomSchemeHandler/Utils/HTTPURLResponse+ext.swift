//
//  HTTPURLResponse+ext.swift
//  CustomSchemeHandler
//
//  Created by Gualtiero Frigerio on 30/12/21.
//

import Foundation

extension HTTPURLResponse {
    static func jsonResponse(url: URL, data: Data?) -> HTTPURLResponse {
        HTTPURLResponse(url: url,
                        mimeType: "application/json",
                        expectedContentLength: data?.count ?? 0,
                        textEncodingName: "utf-8")
    }
}
