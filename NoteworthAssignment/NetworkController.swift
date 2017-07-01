//
//  NetworkController.swift
//  NoteworthAssignment
//
//  Created by Matthew Baron on 7/1/17.
//  Copyright © 2017 Matt Baron. All rights reserved.
//

import Foundation
import GooglePlaces

/// Completion handler used for downloading GMSPlace objects
public typealias NearbyPlacesCompletion = (([GMSPlace]) -> Void)

class NetworkController {
    
    
    var googleNearbyPlacesSearchBaseURL: URL? {
        return URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json")
    }
    
    /// Ensures that NetworkController is a singleton
    static let sharedInstance = NetworkController()
    
    /// Creates a urlSession that has default configuration
    lazy private var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    /// We make init fileprivate here since NetworkController is a singleton and shouldn't be initialized directly
    fileprivate init() {}
    
    public func fetchPlaces(for originalPlace: GMSPlace, and radius: Double, completion: NearbyPlacesCompletion) {
        guard let nearbySearchURL = self.googleNearbyPlacesSearchBaseURL else {
            // TODO: Present error here
            return
        }
        
        var parameters = [String: Any]()
        
        parameters["key"] = googleAPIKey
        parameters["location"] = "\(originalPlace.coordinate.latitude),\(originalPlace.coordinate.longitude)"
        parameters["radius"] = "\(radius)"
        
        let queryStringParameters = parameters.stringFromHttpParameters()
        
        guard let finalURLForNearbySearch = URL(string: "\(nearbySearchURL)?\(queryStringParameters)") else {
            // TODO: Error handling
            return
        }
        
        let nearbySearchURLRequest = URLRequest(url: finalURLForNearbySearch)
        
        let task = self.urlSession.dataTask(with: nearbySearchURLRequest) { (data, response, error) in
            print("RESULTS: \(data)")
        }
        
        task.resume()
    }
}
