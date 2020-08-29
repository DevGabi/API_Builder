//
//  ViewController.swift
//  CommonAPI
//
//  Created by DevGabi on 2020/08/05.
//  Copyright © 2020 devgabi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let apiClient = ApiClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func apiCall(_ sender: Any) {
        apiClient.send(api: API.sampleAPI()) { (success, data, error) in
            guard let topLavel = data as? TopLevel, success else {
                print(error.debugDescription)
                return
            }
            print(topLavel.title)
        }
    }
    @IBAction func apiObservableCall(_ sender: Any) {
        apiClient.send(api: API.sampleAPI())
            .subscribe(onNext: { (success, data, error) in
                guard let topLavel = data as? TopLevel, success else {
                    let errorCode = error?.asAFError?.errorCode
                    print(errorCode.debugDescription)
                    return
                }
                print(topLavel.title)
            })
            .disposed(by: rx.disposeBag)
    }
    @IBAction func apiZipCall(_ sender: Any) {
        let apiList = [
            apiClient.send(api: API.sampleAPI()),
            apiClient.send(api: API.sampleAPI2())
        ]
        apiClient.sendZip(api: apiList)
            .subscribe(onNext: { (completion) in
                print(completion)
            })
            .disposed(by: rx.disposeBag)
    }
}

