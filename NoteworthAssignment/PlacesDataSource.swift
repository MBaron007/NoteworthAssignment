//
//  PlacesDataSource.swift
//  NoteworthAssignment
//
//  Created by Matthew Baron on 7/3/17.
//  Copyright © 2017 Matt Baron. All rights reserved.
//

import Foundation
import GooglePlaces

class PlacesDataSource {
    open var places = [GMSPlace]()
    
    let initialPlace: GMSPlace
    let radius: Double
    
    init(initialPlace: GMSPlace, radius: Double) {
        self.initialPlace = initialPlace
        self.radius = radius
    }
    
    public func nearbyPlaces(completion: @escaping NearbyPlacesCompletion) {
        
        if !self.places.isEmpty {
            completion(.success(self.places))
        } else {
            NetworkController.sharedInstance.fetchPlaces(for: self.initialPlace, and: self.radius) { (placesResult) in
                switch placesResult {
                case let .success(places):
                    self.add(places: places)
                case .failure(_):
                    break
                }
                
                
                completion(placesResult)
            }
        }
    }
    
    public func add(places: [GMSPlace]) {
        for place in places {
            self.add(place: place)
        }
    }
    
    public func add(place: GMSPlace) {
        if !self.places.contains(place) {
            self.places.append(place)
        }
    }
    
    
}
