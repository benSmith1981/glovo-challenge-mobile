//
//  PopupViewController.swift
//  TransitiongPopupView
//
//  Created by ben on 26/10/2017.
//  Copyright © 2017 ben. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController, UIViewControllerTransitioningDelegate {
    @IBOutlet var containerView: UIView!
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!

    @IBOutlet weak var messageLabel: UILabel!
    var message: String?
    var titleMessage: String?
    var closeButtonTitle: String?
    var actionButtonTitle: String?
    var actionCode: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.setRadiusWithShadow(radius: 15)
        closeButton.setRadiusWithShadow(radius: 15)
        actionButton.setRadiusWithShadow(radius: 15)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let actionCode = actionCode {
            self.actionCode = actionCode
            self.actionButton.setTitle(self.actionButtonTitle ?? "", for: UIControlState.normal)
            self.actionButton.setTitle(self.actionButtonTitle ?? "", for:  UIControlState.highlighted)
            self.actionButton.isHidden = false
        } else {
            self.actionButton.isHidden = true

        }
        self.messageLabel.text = message
        self.closeButton.setTitle(self.closeButtonTitle ?? "", for: UIControlState.normal)
        self.closeButton.setTitle(self.closeButtonTitle ?? "", for:  UIControlState.highlighted)

    }
    
    @IBAction func actionCode(_ sender: Any) {
        self.dismiss(animated: true) {
            self.actionCode?()
        }
    }

    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
