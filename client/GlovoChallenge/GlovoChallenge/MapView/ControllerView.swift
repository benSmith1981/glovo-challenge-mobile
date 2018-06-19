//
//  ControllerView.swift
//  GlovoChallenge
//
//  Created by Ben Smith on 18/06/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//

import Foundation
import UIKit
import ISHPullUp

protocol controllerViewCallBack {
    func updateMap()
    func updateDetails(city: String)
    
}
class ControllerView: ISHPullUpViewController {
    
    var countries:[Countries]?
    var mapContentVC: MapViewController?
    var detailScreenBottomVC: DetailsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func commonInit() {
        loadViewControllers()
        setupSHPullUpController()
        getCities()
        getCountries()
        
    }
    
    func setupSHPullUpController() {
        contentViewController = mapContentVC
        contentDelegate = mapContentVC
        bottomViewController = detailScreenBottomVC
        sizingDelegate = detailScreenBottomVC
        stateDelegate = detailScreenBottomVC
        mapContentVC?.delegate = self
        detailScreenBottomVC?.delegate = self
        detailScreenBottomVC?.pullUpController = self

    }
    
    func loadViewControllers(){
        let searchStoryBoard = UIStoryboard(name: R.storyboard.main.name, bundle: nil)
        mapContentVC = searchStoryBoard.instantiateViewController(withIdentifier: R.storyboard.main.map.identifier) as? MapViewController
        detailScreenBottomVC = searchStoryBoard.instantiateViewController(withIdentifier: R.storyboard.main.detail.identifier) as? DetailsViewController
    }
    
}

//Data layer access
extension ControllerView {
    func getCityDetail(cityCode: String) {
        APIManager.shared.getCityDetail(cityCode: cityCode,success: { (city, data) in
            self.detailScreenBottomVC?.city = city
        }) { (message) in
            print("Failed")
        }
    }
    func getCountries() {
        APIManager.shared.getCountries(success: { (countries, data) in
            self.countries = countries
        }) { (message) in
            print("Failed")
        }
    }
    
    func getCities() {
        APIManager.shared.getCities(success: { (cities, data) in
            self.mapContentVC?.cities = cities
        }) { (message) in
            print("Failed")
        }
    }
}


extension ControllerView: controllerViewCallBack {
    func updateMap() {
        
    }
    
    func updateDetails(city: String) {
        if city == "Not Found" {
            let city = CityDetail.init(code: "", name: "Out of Bounds", currency: "", country_code: "", enabled: false, time_zone: "", working_area: [], busy: false, language_code: "")
            self.detailScreenBottomVC?.city = city
        } else {
            self.getCityDetail(cityCode: city)
        }
    }
}
