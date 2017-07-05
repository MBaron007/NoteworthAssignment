//
//  TabBarController.swift
//  NoteworthAssignment
//
//  Created by Matthew Baron on 6/29/17.
//  Copyright © 2017 Matt Baron. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker

class TabBarController: UITabBarController, UITabBarControllerDelegate  {
    
    fileprivate let placesDataSource: PlacesDataSource
    
    let chosenPlace: GMSPlace
    let radius: Double

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        self.placesDataSource.nearbyPlaces { (placesResult) in
            switch placesResult {
            case let .success(places):
               break
            case .failure(_):
                // TODO: Add error handling
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let storesListTab = RestaurantListTableViewController(placesDataSource: self.placesDataSource)
        let storesListTabItem = UITabBarItem(title: NSLocalizedString("List", comment: "Describes a list of stores"), image: nil, selectedImage: nil)
        storesListTab.tabBarItem = storesListTabItem

        let mapTab = RestaurantMapViewController(initialPlace: self.chosenPlace, placesDataSource: self.placesDataSource)
        let mapTabItem = UITabBarItem(title: NSLocalizedString("Map", comment: "Describes a map of stores"), image: nil, selectedImage: nil)
        mapTab.tabBarItem = mapTabItem
        
        self.viewControllers = [storesListTab, mapTab]
    }

    init(place: GMSPlace, radius: Double) {
        self.chosenPlace = place
        self.radius = radius
        self.placesDataSource = PlacesDataSource(initialPlace: self.chosenPlace, radius: self.radius)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TabBarController: GMSPlacePickerViewControllerDelegate {
    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("Place name \(place.name)")
        print("Place address \(place.formattedAddress)")
        print("Place attributions \(place.attributions)")
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
}

