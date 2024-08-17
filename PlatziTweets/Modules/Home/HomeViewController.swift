//
//  HomeViewController.swift
//  PlatziTweets
//
//  Created by Jackson Cuevas on 9/8/24.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift
import AVKit

class HomeViewController: UIViewController {
    //MARK: - IBOutletss
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    private let cellId = "TweetHomeTableViewCell"
    private var dataSource = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //getPost()
    }
    
    private func setupUI() {
        // 1. Asginar datasource
        // 2. registar celda
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    private func getPost() {
        //1. Indicar cargar al usuario
        SVProgressHUD.show()
        
        //2. Comsumir el servicio
        SN.get(endpoint: Endpoints.getPosts) {(result: SNResultWithEntity<[Post], ErrorResponse>) in
            switch  result {
            case .success(let posts) :
                self.dataSource = posts
                self.tableView.reloadData()
                
            case .error(let error):
                NotificationBanner(subtitle: error.localizedDescription, style: .danger).show()
            case .errorResult(let entity):
                NotificationBanner(subtitle: entity.error, style: .danger).show()
            }
            
        }
    }
    
    private func deletePostAt(indexPath: IndexPath) {
        // 1. Indicar carga al usuario
        SVProgressHUD.show()
        
        // 2. Obtener ID del post que vamos a borrar
        let postId = dataSource[indexPath.row].id
        
        // 3. Preparamos el endpoint para borrar
        let endpoint = Endpoints.delete + postId
        
        // 4. Consumir el servicio para borrar el post
        SN.delete(endpoint: endpoint) { (result: SNResultWithEntity<GeneralResponse, ErrorResponse>) in
            //1. Indicar cargar al usuario
            SVProgressHUD.show()
            
            switch  result {
            case .success:
                // 1. Borrar el post del datasource
                self.dataSource.remove(at: indexPath.row)
                
                // 2. Borrar la celda de la table
                self.tableView.deleteRows(at: [indexPath], with: .left)
                
            case .error(let error):
                NotificationBanner(subtitle: error.localizedDescription, style: .danger).show()
            case .errorResult(let entity):
                NotificationBanner(subtitle: entity.error, style: .danger).show()
            }
        }
    }
}

//MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Borrar") {(_,_) in
            // Aquí borramos el tweet
            self.deletePostAt(indexPath: indexPath)
        }
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return dataSource[indexPath.row].author.email != "test@test.com"
    }
}

extension HomeViewController: UITableViewDataSource {
    //número taotl de celdas
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    // Configuar celda deseada
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let cell = cell as? TweetHomeTableViewCell {
            // configurar la celda
            cell.setupCellWith(post: dataSource[indexPath.row])
            cell.needsToShowVideo = {url in
                // Aquí SI deveríamos abrir un ViewController
                
                let avPlayer = AVPlayer(url: url)
                
                let avPlayerController = AVPlayerViewController()
                avPlayerController.player = avPlayer
                
                self.present(avPlayerController, animated: true) {
                    avPlayerController.player?.play()
                }
            }
            
        }
        
        return cell
    }
    
    
}


// MARK: - Navigation
extension HomeViewController {
    
    // Este método se llamará cuando hagamos transiciones entre pantallas (Sólo con Storyboards)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1. Validar que el segue sea el esperado
        
        if segue.identifier == "showMap", let mapViewController = segue.destination as? MapViewController {
            // Ya sabemos que si vamos a la pantalla del mapa
            mapViewController.posts = dataSource.filter {
                $0.hasLocation
            }
            
        }
    }
}
