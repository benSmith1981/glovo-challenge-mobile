//
//  ApiManager.swift
//  GlovoChallenge
//
//  Created by Ben Smith on 18/06/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MapKit
import UIKit

class APIResponse {
    var json:Data;
    var errorMessage:String?;
    init(json:Data) {
        self.json = json
    }
}

class APIManager {
    static let shared = APIManager()
    let url: URL = URL(string: Config.shared.getStr("ApiBase"))!
    
    private init() {
        print("Initializing APIEngine with base url: \(url)")
    }
    
    func getCityDetail(success:@escaping ((CityDetail, Data) -> Void), failure:@escaping ((String) -> Void)) {
        Alamofire.request("\(url)cities/",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default).responseData { (response) in
                response.result.ifSuccess({
                    if let jsonData = response.data {
                        let res = APIResponse(json: jsonData)
                        
                        print("success \(res)")
                        let decoder = JSONDecoder()
                        do {
                            let city = try decoder.decode(CityDetail.self, from: res.json)
                            print(city)
                            return success(city, res.json)
                        } catch {
                            print("Unexpected error: JSON parsing error")
                            return failure(res.errorMessage ?? "Unexpected error: Unknown error")
                        }
                        
                    } else {
                        failure("Unexpected error: Error parsing response")
                    }
                })
                response.result.ifFailure({
                    failure("Failed")
                    
                })
        }
    }
    
    func getCities(success:@escaping (([Cities], Data) -> Void), failure:@escaping ((String) -> Void)) {
        Alamofire.request("\(url)cities/",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default).responseData { (response) in
                response.result.ifSuccess({
                    if let jsonData = response.data {
                        let res = APIResponse(json: jsonData)
                        
                        print("success \(res)")
                        let decoder = JSONDecoder()
                        do {
                            let cities = try decoder.decode([Cities].self, from: res.json)
                            print(cities)
                            return success(cities, res.json)
                        } catch {
                            print("Unexpected error: JSON parsing error")
                            return failure(res.errorMessage ?? "Unexpected error: Unknown error")
                        }
                        
                    } else {
                        failure("Unexpected error: Error parsing response")
                    }
                })
                response.result.ifFailure({
                    failure("Failed")
                    
                })
        }
    }
    
    func getCountries(success:@escaping (([Countries], Data) -> Void), failure:@escaping ((String) -> Void)) {
        Alamofire.request("\(url)countries/",
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default).responseData { (response) in
                            response.result.ifSuccess({
                                if let jsonData = response.data {
                                    let res = APIResponse(json: jsonData)
                                    
                                    print("success \(res)")
                                    let decoder = JSONDecoder()
                                    do {
                                        let countries = try decoder.decode([Countries].self, from: res.json)
                                        print(countries)
                                        return success(countries, res.json)
                                    } catch {
                                        print("Unexpected error: JSON parsing error")
                                        return failure(res.errorMessage ?? "Unexpected error: Unknown error")
                                    }
                                    
                                } else {
                                    failure("Unexpected error: Error parsing response")
                                }
                            })
                            response.result.ifFailure({
                                failure("Failed")
                                
                            })
        }
    }
}
