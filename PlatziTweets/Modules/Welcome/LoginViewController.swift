//
//  LoginViewController.swift
//  PlatziTweets
//
//  Created by Jackson Cuevas on 3/8/24.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD

class LoginViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - IBActions
    @IBAction func loginButtonAction() {
        view.endEditing(true)
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
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especifivar una contraseña.", style: .warning).show()
            return
        }
        
        //Crear request
//       let request = LoginRequest(email: email, password: password)
//        
//        // Iniciamos la carga
//        SVProgressHUD.show()
//        
//        //LLamar a la libreria de red
//        SN.post(endpoint: Endpoints.login, model: request) {(response: SNResultWithEntity<LoginResponse, ErrorResponse>) in
//            
//            SVProgressHUD.dismiss()
//            
//            switch  response {
//            case .success(let user) :
//                NotificationBanner(subtitle: "Bienvenido \(user.user.names)", style: .success).show()
//                self.performSegue(withIdentifier: "showHome", sender: nil)
//                SimpleNetworking.setAuthenticationHeader(prefix: "", token: user.token)
//            case .error(let error):
//                NotificationBanner(subtitle: error.localizedDescription, style: .danger).show()
//                return
//            case .errorResult(let entity):
//                NotificationBanner(subtitle: entity.error, style: .danger).show()
//                return
//            }
//        }
        self.performSegue(withIdentifier: "showHome", sender: nil)

    }

}
