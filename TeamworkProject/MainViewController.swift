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

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var hintsLabel: UILabel!
    @IBOutlet weak var authorizeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI(INPreferences.siriAuthorizationStatus())
    }

    fileprivate func updateUI(_ status: INSiriAuthorizationStatus) {
        mainLabel.isHidden = !(status == .authorized)
        authorizeButton.isHidden = (status == .authorized)
        hintsLabel.isHidden = !(status == .authorized)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Outlets

    @IBAction func authorizeSiriKit() {
        INPreferences.requestSiriAuthorization { status in
            switch status {
            case .authorized:
                #if DEBUG
                    print("Siri: Authorized")
                #endif
            default:
                #if DEBUG
                    print("Siri: Not authorized")
                #endif
            }
            self.updateUI(status)
        }
    }
}
