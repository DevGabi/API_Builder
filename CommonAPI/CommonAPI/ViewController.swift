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
                print(error)
                return
            }
        }
    }
}

