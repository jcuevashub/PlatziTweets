//
//  RegisterViewController.swift
//  PlatziTweets
//
//  Created by Jackson Cuevas on 3/8/24.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        registerButton.layer.cornerRadius = 25
    }

}
