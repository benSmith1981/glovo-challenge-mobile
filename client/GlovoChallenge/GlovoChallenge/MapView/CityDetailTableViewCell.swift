//
//  CityDetailTableViewCell.swift
//  GlovoChallengeDev
//
//  Created by Ben Smith on 19/06/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//

import UIKit

class CityDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var enabled: UILabel!
    @IBOutlet weak var busy: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(city: CityDetail) {
        self.name.text = city.name
        self.currency.text = city.currency
        if let enabled = city.enabled {
            self.enabled.text = enabled ? "Enabled" : "Not Enabled"
        }
        if let busy = city.busy {
            self.busy.text = busy ? "Busy!" : "Not Busy"
        }

    }
    
}
