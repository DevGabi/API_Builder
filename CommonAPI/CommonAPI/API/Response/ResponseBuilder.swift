//
//  ResponseBuilder.swift
//  CommonAPI
//
//  Created by DevGabi on 2020/08/10.
//  Copyright © 2020 devgabi. All rights reserved.
//

import Foundation

typealias ResponseParsingBlock = (_ response: Any?) -> Any?
class ResponseBuilder {
    var parse: ResponseParsingBlock?
    func parseType(type: ResponseDataType) -> ResponseBuilder {
        return self
    }
}
