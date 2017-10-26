//
//  MainViewController.swift
//  TeamworkProject
//
//  Created by Nikolay Derkach on 10/26/17.
//  Copyright © 2017 Nikolay Derkach. All rights reserved.
//

import UIKit
import Intents

class MainViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI(INPreferences.siriAuthorizationStatus())
    }

    fileprivate func updateUI(_ status: INSiriAuthorizationStatus) {
        label.isHidden = !(status == .authorized)
        button.isHidden = (status == .authorized)
    }

    // MARK: - Outlets

    @IBAction func authorizeSiriKit() {
        INPreferences.requestSiriAuthorization { status in
            switch status {
            case .authorized:
                print("Siri: Authorized")
            default:
                print("Siri: Not authorized")
            }
            self.updateUI(status)
        }
    }
}
