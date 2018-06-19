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
    var code: String?
    var name: String?
    var currency: String?
    var country_code: String?
    var enabled: Bool?
    var time_zone: String?
    var working_area: [String]?
    var busy: Bool?
    var language_code: String?
}
