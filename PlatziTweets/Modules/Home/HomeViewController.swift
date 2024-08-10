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
    
    private func setupUI() {
        // 1. Asginar datasource
        // 2. registar celda
        
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
        }
        
        return cell
    }
    
    
}
