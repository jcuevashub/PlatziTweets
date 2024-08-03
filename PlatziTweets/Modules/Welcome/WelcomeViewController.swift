//
//  WelcomeViewController.swift
//  PlatziTweets
//
//  Created by Jackson Cuevas on 3/8/24.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        loginButton.layer.cornerRadius = 25
    }

}
