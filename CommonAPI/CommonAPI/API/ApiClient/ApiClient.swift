//
//  ApiClient.swift
//  CommonAPI
//
//  Created by DevGabi on 2020/08/05.
//  Copyright © 2020 devgabi. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxCocoa
import RxSwift
import NSObject_Rx

typealias RequestCompletion = (Bool, Any?, Error?) -> Void
typealias RequestObCompletion = (Bool, Any?, Error?)
class ApiClient: HasDisposeBag {
    private let session: Alamofire.Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.headers = HTTPHeaders.default // default
        configuration.timeoutIntervalForRequest = 5 // 타임아웃
        return Alamofire.Session.init(configuration: configuration)
    }()
    
    public func send(api: API, responseData: @escaping RequestCompletion) {
        session.rx
            .request(api.request.httpMethod, api.request.build(api.request.responseData), headers: api.request.headerField)
            .validationDataResponse(api: api)
            .subscribe(onNext: { (dataResponse) in
                let result = api.response.parse!(dataResponse.value)
                if result is Error {
                    responseData(true, nil, result as? Error)
                } else {
                    responseData(true, result, nil)
                }
            }, onError: { (error) in
                responseData(false, nil, error)
            })
            .disposed(by: disposeBag)
    }
    
    public func send(api: API, retryCnt: Int = 1) -> Observable<RequestObCompletion> {
        return session.rx
            .request(api.request.httpMethod, api.request.build(api.request.responseData), headers: api.request.headerField)
            .validationDataResponse(api: api)
            .map { (dataResponse) in
                let result = api.response.parse!(dataResponse.value)
                var requestCompletion: RequestObCompletion
                if result is Error {
                    requestCompletion = (false, nil, result as? Error)
                } else {
                    requestCompletion = (true, result, nil)
                }
                return requestCompletion
            }
            .retry(retryCnt)
            .catchError { Observable.just((false, nil, $0)) }
    }
    
    public func sendZip(api: [Observable<RequestObCompletion>]) -> Observable<[RequestObCompletion]> {
        return Observable.zip(api)
    }
    
    deinit {
        print("deinit")
    }
}

extension ObservableType where Element: DataRequest {
    func validationDataResponse(api: API) -> Observable<DataResponse<Any, AFError>> {
        return map { $0.validate(statusCode: 200..<300)}
            .flatMap { (dataRequest) -> Observable<DataResponse<Any, AFError>> in
            switch api.request.responseData {
            case .string:
                return dataRequest.rx
                    .responseString()
                    .flatMap { (arg) -> Observable<DataResponse<Any, AFError>> in
                        let (httpResponse, jsonString) = arg
                        let dataResponse = DataResponse<Any, AFError>(request: dataRequest.request,
                                                                      response: httpResponse,
                                                                      data: nil,
                                                                      metrics: nil,
                                                                      serializationDuration: 5.0,
                                                                      result: .success(jsonString))
                        return Observable.just(dataResponse)
                    }
            case .json:
                    return dataRequest.rx.responseJSON()
            case .data:
                return dataRequest.rx
                    .responseData()
                    .flatMap { (arg) -> Observable<DataResponse<Any, AFError>> in
                        let (httpResponse, jsonString) = arg
                        let dataResponse = DataResponse<Any, AFError>(request: dataRequest.request,
                                                                      response: httpResponse,
                                                                      data: nil,
                                                                      metrics: nil,
                                                                      serializationDuration: 5.0,
                                                                      result: .success(jsonString))
                        return Observable.just(dataResponse)
                }
            }
        }
    }
}
