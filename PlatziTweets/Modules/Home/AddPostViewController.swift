//
//  AddPostViewController.swift
//  PlatziTweets
//
//  Created by Jackson Cuevas on 12/8/24.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift

class AddPostViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var postTextView: UITextView!
    
    // MARK: - IBActions
    @IBAction func addPostAction() {
        savePost()
    }
    
    @IBAction func dismissAction() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    private func savePost() {
        //1. Crear request
        let request = PostRequest(text: postTextView.text, imageUrl: nil, videoUrl: nil, location: nil)
        
        //2. Indicar carga al usuario
        SVProgressHUD.show()
        
        //3. LLamar al servicio del post
        SN.post(endpoint: Endpoints.post, model: request) {(response: SNResultWithEntity<Post, ErrorResponse>) in
            
            //4. Cerrar indicador de carga
            SVProgressHUD.dismiss()
            
            switch  response {
            case .success:
                self.dismiss(animated: true, completion: nil)
            case .error(let error):
                NotificationBanner(subtitle: error.localizedDescription, style: .danger).show()
            case .errorResult(let entity):
                NotificationBanner(subtitle: entity.error, style: .danger).show()
            }
        }
    }
}
