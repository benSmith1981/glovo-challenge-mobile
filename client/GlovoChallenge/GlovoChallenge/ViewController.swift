//
//  ViewController.swift
//  GlovoChallenge
//
//  Created by Ben Smith on 18/06/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.shared.getCities(success: { (cities, data) in
            print(cities)
        }) { (message) in
            print("Failed")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

