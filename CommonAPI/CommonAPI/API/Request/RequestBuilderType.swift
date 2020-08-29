//
//  ApiType.swift
//  CommonAPI
//
//  Created by DevGabi on 2020/08/05.
//  Copyright © 2020 devgabi. All rights reserved.
//

import Foundation

enum SchemeType {
    case HTTP
    case HTTPS
    func string() -> String {
        switch self {
        case .HTTP:
            return "http"
        case .HTTPS:
            return "https"
        }
    }
}

enum ResponseDataType {
    case data
    case json
    case string
}

protocol RequestBuilderType {
    var responseData: ResponseDataType { get set }
    var urlComponents: URLComponents { get set }

    @discardableResult
    func setScheme(scheme: SchemeType) -> RequestBuilderType
    @discardableResult
    func setDomain(domain: String) -> RequestBuilderType
    @discardableResult
    func setPath(path: String) -> RequestBuilderType
    @discardableResult
    func setQuary(query: [String: String]) -> RequestBuilderType
    func build(_ responseType: ResponseDataType) -> URLComponents
}
