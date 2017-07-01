//
//  TabBarController.swift
//  NoteworthAssignment
//
//  Created by Matthew Baron on 6/29/17.
//  Copyright © 2017 Matt Baron. All rights reserved.
//

import UIKit
import GooglePlaces

class TabBarController: UITabBarController, UITabBarControllerDelegate  {
    
    let chosenPlace: GMSPlace
    let radius: Double

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let storesListTab = StoreListTableViewController()
        let storesListTabItem = UITabBarItem(title: NSLocalizedString("List", comment: "Describes a list of stores"), image: nil, selectedImage: nil)
        storesListTab.tabBarItem = storesListTabItem
        
        self.viewControllers = [storesListTab]
    }

    init(place: GMSPlace, radius: Double) {
        self.chosenPlace = place
        self.radius = radius
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

