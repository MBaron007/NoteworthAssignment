//
//  NetworkController.swift
//  NoteworthAssignment
//
//  Created by Matthew Baron on 7/1/17.
//  Copyright © 2017 Matt Baron. All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleMaps

/// Completion handler used for downloading GMSPlace objects
public typealias NearbyPlacesCompletion = ((PlacesResult) -> Void)

public typealias PlaceDetailCompletion = ((PlaceResult) -> Void)

public enum PlacesResult {
    case success([GMSPlace])
    case failure(Error)
}

public enum PlaceResult {
    case success(GMSPlace)
    case failure(Error)
}

public enum PlacesError: Error {
    case malformedURL
    case invalidData
}

class NetworkController {
    
    var googleNearbyPlacesSearchBaseURL: URL? {
        return URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json")
    }
    
    var googlePlaceDetailsBaseURL: URL? {
        return URL(string: "https://maps.googleapis.com/maps/api/place/details/json")
    }
    
    fileprivate let placesClient = GMSPlacesClient()
    
    /// Ensures that NetworkController is a singleton
    static let sharedInstance = NetworkController()
    
    /// Creates a urlSession that has default configuration
    lazy private var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    /// We make init fileprivate here since NetworkController is a singleton and shouldn't be initialized directly
    fileprivate init() {}
    
    public func fetchPlaces(for originalPlace: GMSPlace, and radius: Double, completion: @escaping NearbyPlacesCompletion) {
        guard let nearbySearchURL = self.googleNearbyPlacesSearchBaseURL else {
            // TODO: Present error here
            return
        }
        
        var parameters = [String: Any]()
        
        parameters["key"] = googleAPIKey
        parameters["location"] = "\(originalPlace.coordinate.latitude),\(originalPlace.coordinate.longitude)"
        parameters["radius"] = "\(radius)"
        parameters["type"] = "restaurant"
        
        let queryStringParameters = parameters.stringFromHttpParameters()
        
        guard let finalURLForNearbySearch = URL(string: "\(nearbySearchURL)?\(queryStringParameters)") else {
            // TODO: Error handling
            return
        }
        
        let nearbySearchURLRequest = URLRequest(url: finalURLForNearbySearch)
        
        let task = self.urlSession.dataTask(with: nearbySearchURLRequest) { (data, response, error) in
            self.processPlaces(data: data, error: error, completion: { (placesResult) in
                switch placesResult {
                case let .success(places):
                    completion(.success(places))
                case let .failure(error):
                    completion(.failure(error))
                }
            })
        }
        
        task.resume()
    }
    
    private func processPlaces(data: Data?, error: Error?, completion: @escaping NearbyPlacesCompletion) {
        guard let jsonData = data else {
            // TODO: Error handling
            return
        }
        
        self.places(fromJson: jsonData) { placesResult in
            completion(placesResult)
        }
    }
    
    fileprivate func places(fromJson data: Data, completion: @escaping NearbyPlacesCompletion) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            // Ensure we have a value for the key "locations", since that's where all the store data is meant to be
            guard let jsonDictionary = jsonObject as? [String: Any], let placesArray = jsonDictionary["results"] as? [[String: Any]]  else {
                completion(.failure(PlacesError.invalidData))
                return
            }
            
            var resultArray = [GMSPlace]()
            
            let group = DispatchGroup()
            
            for placesJson in placesArray {
                if let placeId = placesJson["place_id"] as? String {
                    group.enter()
                    self.getPlaceDetails(placeId: placeId, completion: { (placeResult) in
                        switch placeResult {
                        case let .success(place):
                            resultArray.append(place)
                        case let .failure(error):
                            // TODO: Handle error
                            break
                        }
                        group.leave()
                    })
                }
            }
            
            group.notify(queue: DispatchQueue.global(qos: .background)) {
                completion(.success(resultArray))
            }
            
        } catch {
            completion(.failure(error))
        }
    }
    
    fileprivate func getPlaceDetails(placeId: String, completion: @escaping PlaceDetailCompletion) {
        self.placesClient.lookUpPlaceID(placeId) { (place, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let existingPlace = place else {
                completion(.failure(PlacesError.invalidData))
                return
            }
            
            completion(.success(existingPlace))
        }
    }

}
