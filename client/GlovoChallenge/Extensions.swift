//
//  UIViewExtension.swift
//  GlovoChallengeDev
//
//  Created by Ben Smith on 19/06/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//

import Foundation
import UIKit
// MARK: - Calculate percentage of a view - say the main bound
extension UIView {
    
    func setRadiusWithShadow(radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.7
        self.layer.masksToBounds = false
    }
}


extension UIViewController {
    
    func showPopUpView(msg: String,
                       actionButtonTitle: String,
                       closeButtonTitle: String,
                       actionCode: (()->Void)?) {
        let popUpStoryboard = UIStoryboard(name: R.storyboard.popupVC.name, bundle: nil)
        if let popupVC = popUpStoryboard.instantiateViewController(withIdentifier: R.storyboard.popupVC.popupVC.identifier) as? PopupViewController {
            popupVC.actionCode = actionCode
            popupVC.actionButtonTitle = actionButtonTitle
            popupVC.message = msg
            popupVC.closeButtonTitle = closeButtonTitle
            
            self.present(popupVC, animated: true, completion: nil)
        }
        
    }
}
