//
//  AddressAndRadiusViewController.swift
//  NoteworthAssignment
//
//  Created by Matthew Baron on 6/28/17.
//  Copyright © 2017 Matt Baron. All rights reserved.
//

import UIKit

class AddressAndRadiusViewController: UIViewController {

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var viewRestaurantsButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("Noteworth Lunch Options", comment: "Describes that the address and radius inputted will be used to look up lunch options.")
        
        self.viewRestaurantsButton.isEnabled = false
        
        // Do any additional setup after loading the view.
    }

}
