//
//  CityDetail.swift
//  GlovoChallenge
//
//  Created by Ben Smith on 18/06/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//

import Foundation
import UIKit
struct CityDetail: Codable {
    var code: String? //: "BCN",
    var name: String? //: "Barcelona",
    var currency: String?  //: "EUR",
    var country_code: String? //: "ES",
    var enabled: Bool? //: true,
    var time_zone: String? //: "CET",
    var working_area: [String]?
    var busy: Bool? //: false,
    var language_code: String? //: "es"
}
