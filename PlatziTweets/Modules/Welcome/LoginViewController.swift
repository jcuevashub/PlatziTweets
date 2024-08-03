//
//  LoginViewController.swift
//  PlatziTweets
//
//  Created by Jackson Cuevas on 3/8/24.
//

import UIKit
import NotificationBannerSwift

class LoginViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - IBActions
    @IBAction func loginButtonAction() {
        performLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        loginButton.layer.cornerRadius = 25
    }
    
    private func performLogin() {
        guard let email = emailTextField.text, !email.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especifivar un correo.", style: .warning).show()
            return
        }
    }

}
