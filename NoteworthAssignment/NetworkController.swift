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
    case success([Place])
    case failure(Error)
}

public enum PlaceResult {
    case success(Place)
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
        
        let result = self.places(fromJson: jsonData) { placesResult in
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
            
            var resultArray = [Place]()
            
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
        guard let placeDetailURL = self.googlePlaceDetailsBaseURL else {
            completion(.failure(PlacesError.malformedURL))
            return
        }
        
        var parameters = [String: Any]()
        
        parameters["key"] = googleAPIKey
        parameters["place_id"] = placeId
        
        let queryStringParameters = parameters.stringFromHttpParameters()
        
        guard let finalURLForPlaceDetail = URL(string: "\(placeDetailURL)?\(queryStringParameters)") else {
            completion(.failure(PlacesError.malformedURL))
            return
        }
        
        let placeDetailURLRequest = URLRequest(url: finalURLForPlaceDetail)
        
        let task = self.urlSession.dataTask(with: placeDetailURLRequest) { (data, response, error) in
            self.processPlace(data: data, error: error, completion: { (placeResult) in
                completion(placeResult)
            })
        }
        
        task.resume()
    }
    
    private func processPlace(data: Data?, error: Error?, completion: @escaping PlaceDetailCompletion) {
        guard let jsonData = data else {
            // TODO: Error handling
            return
        }
        
        let result = self.place(fromJson: jsonData)
        
        completion(result)
    }
    
    fileprivate func place(fromJson data: Data) -> PlaceResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            // Ensure we have a value for the key "locations", since that's where all the store data is meant to be
            guard let jsonDictionary = jsonObject as? [String: Any], let place = jsonDictionary["result"] as? [String: Any]  else {
                return .failure(PlacesError.invalidData)
            }
            
                
            if let name = place["name"] as? String, let geometry = place["geometry"] as? [String: Any], let location = geometry["location"] as? [String: Any], let latitude = location["lat"] as? Double, let longitude = location["lng"] as? Double {
                
                let newPlace = Place(location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), name: name)
                return .success(newPlace)
            }
            
            
            return .failure(PlacesError.invalidData)
            
        } catch {
            return .failure(error)
        }
    }

}
