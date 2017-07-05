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
    
    var nearbyPlaces = [Place]()
    let placesDataSource: PlacesDataSource

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        
        self.nearbyPlaces = self.placesDataSource.places
        
        let camera = GMSCameraPosition.camera(withLatitude: self.initialPlace.coordinate.latitude, longitude: self.initialPlace.coordinate.longitude, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.initialPlace.coordinate.latitude, longitude: self.initialPlace.coordinate.longitude)
        marker.title = self.initialPlace.name
        marker.map = mapView
        
        for place in self.nearbyPlaces {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: place.location.latitude, longitude: place.location.longitude)
            marker.title = place.name
            marker.map = mapView
            marker.icon = GMSMarker.markerImage(with: .blue)

        }
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
