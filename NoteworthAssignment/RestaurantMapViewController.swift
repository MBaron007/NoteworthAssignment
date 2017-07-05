//
//  RestaurantMapViewController.swift
//  NoteworthAssignment
//
//  Created by Matthew Baron on 7/3/17.
//  Copyright © 2017 Matt Baron. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class RestaurantMapViewController: UIViewController {
    
    let initialPlace: GMSPlace
    let placesDataSource: PlacesDataSource

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: self.initialPlace.coordinate.latitude, longitude: self.initialPlace.coordinate.longitude, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.initialPlace.coordinate.latitude, longitude: self.initialPlace.coordinate.longitude)
        marker.title = self.initialPlace.name
        marker.map = mapView
    }
    
    init(initialPlace: GMSPlace, placesDataSource: PlacesDataSource) {
        self.initialPlace = initialPlace
        self.placesDataSource = placesDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
