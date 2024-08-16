//
//  MapViewController.swift
//  PlatziTweets
//
//  Created by Jackson Cuevas on 15/8/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var mapContainer: UIView!
    
    // MARK: - Properties
    private var posts = [Post]()
    private var map: MKMapView?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMap()
    }
    
    private func setupMap() {
        map = MKMapView(frame: mapContainer.bounds)
        
        mapContainer.addSubview(map ?? UIView())
    }
    
}
