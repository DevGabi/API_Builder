//
//  ApiError.swift
//  CommonAPI
//
//  Created by DevGabi on 2020/08/20.
//  Copyright © 2020 devgabi. All rights reserved.
//

import Foundation
import RxAlamofire
import Alamofire

extension AFError {
    enum errorType {
        case e400
        case e500
        case etc
    }
    var errorCode: errorType {
        switch self.responseCode {
        case 400:
            return .e400
        case 500:
            return .e400
        default:
            return .etc
        }
    }
}
