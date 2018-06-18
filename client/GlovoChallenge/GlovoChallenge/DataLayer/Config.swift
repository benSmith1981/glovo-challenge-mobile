//  Config.swift
//  GlovoChallenge
//
//  Created by Ben Smith on 18/06/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//


import Foundation

class Config {
    static let shared = Config()
    
    fileprivate var dict : Dictionary<String,String>!
    
    init() {
        if let url = Bundle.main.url(forResource: "Config", withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                if let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String,String> {
                    self.dict = dict
                    return
                }
            }
            
        }
        NSException(name: NSExceptionName(rawValue: "Missing Config.json for environment"), reason: "Cannot parse Config.json file", userInfo: nil).raise()
    }
    
    func getStr(_ key : String) -> String {
        if let str = dict[key] {
            return str
        }
        NSException(name: NSExceptionName(rawValue: "Config key not found"), reason: "Key \(key) nor found in config file", userInfo: nil).raise()
        return ""
    }
    
    func googleMapsAPIKey() -> String {
        return getStr("GoogleMapsKey")
    }
}
