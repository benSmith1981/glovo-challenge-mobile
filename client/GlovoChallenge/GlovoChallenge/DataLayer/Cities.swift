//
//  Cities.swift
//  GlovoChallenge
//
//  Created by Ben Smith on 18/06/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//

import Foundation
import UIKit

struct Cities: Codable {
    var working_area: [String]?
    var code: String?
    var name: String?
    var country_code: String
}
