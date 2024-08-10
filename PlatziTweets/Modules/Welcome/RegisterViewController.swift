//
//  RegisterViewController.swift
//  PlatziTweets
//
//  Created by Jackson Cuevas on 3/8/24.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD

class RegisterViewController: UIViewController {
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var namesTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        registerButton.layer.cornerRadius = 25
    }
    
    // MARK: - IBActions
    @IBAction func registerButtonAction() {
        view.endEditing(true)
        performRegister()
    }
    
    private func performRegister() {
        guard let email = emailTextField.text, !email.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especifivar un correo.", style: .warning).show()
            return
        }
        
        guard let names = namesTextField.text, !names.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especificar tu nombre y apellido.", style: .warning).show()
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especifivar una contraseña.", style: .warning).show()
            return
        }
        
        //Crear request
        let request = RegisterRequest(email: email, password: password, names: names)
        
        // Indicar la carga a usuario
        SVProgressHUD.show()
        
        // Llamar a la libreria de red
        SN.post(endpoint: Endpoints.register, model: request) {(response: SNResultWithEntity<LoginResponse, ErrorResponse>) in
            
            // Cerrar la cargar de usuario
            SVProgressHUD.dismiss()
            
            switch  response {
            case .success(let user) :
                self.performSegue(withIdentifier: "showHome", sender: nil)
                SimpleNetworking.setAuthenticationHeader(prefix: "", token: user.token)
            case .error(let error):
                NotificationBanner(subtitle: error.localizedDescription, style: .danger).show()
                return
            case .errorResult(let entity):
                NotificationBanner(subtitle: entity.error, style: .danger).show()
                return
            }
        }
        
    }

}
