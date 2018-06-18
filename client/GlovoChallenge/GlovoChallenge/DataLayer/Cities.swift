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
    //["", "lqiqCxcvyGkPbg@kN`u@iFhaAu^qHyNgh@u`BqOaPsb@n@_ZIeYcBeFiZmMlB}R~LvCny@jDtD{RtFkKptC}nBpi@WfMzBbJqEpCdFpI`PpLrXzA|KiCzNcIrK{_@`G_]z_@wNdS"],
    var code: String? // ": "SAN",
    var name: String? // "name": "Santos",
    var country_code: String //"country_code": "BR"
}
