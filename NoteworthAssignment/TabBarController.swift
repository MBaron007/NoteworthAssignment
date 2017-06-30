//
//  TabBarController.swift
//  NoteworthAssignment
//
//  Created by Matthew Baron on 6/29/17.
//  Copyright © 2017 Matt Baron. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate  {
    
    var address: String = ""
    var radius: String = ""

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

