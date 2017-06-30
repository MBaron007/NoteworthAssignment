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
        
        self.viewRestaurantsButton.addTarget(self, action: #selector(viewRestaurantsButtonTapped(_:)), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    func viewRestaurantsButtonTapped(_ sender: Any?) {
        guard let existingAddress = self.addressTextField.text, let existingRadius = self.radiusTextField.text, !existingAddress.isEmpty, !existingRadius.isEmpty else {
            // TODO: Throw error here 
            return
        }
        
        let newTabBarController = TabBarController()
        self.show(newTabBarController, sender: self)
        
//        AIzaSyCxMwYasW7hd4qzsKGuCyLm1TlcZpQs3P8
        
        
    }
}


