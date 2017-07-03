//
//  InputRadiusViewController.swift
//  NoteworthAssignment
//
//  Created by Matthew Baron on 6/30/17.
//  Copyright © 2017 Matt Baron. All rights reserved.
//

import UIKit
import GooglePlaces

class InputRadiusViewController: UIViewController {

    @IBOutlet weak var radiusTextField: UITextField!
    @IBAction func submitRadiusButtonTapped(_ sender: Any) {
        guard let inputtedText = self.radiusTextField.text, !inputtedText.isEmpty, let numberInputted = Double(inputtedText), numberInputted < 1500.0 else {
            // TODO: Display error here
            return
        }
        
        let tabBarController = TabBarController(place: self.chosenPlace, radius: numberInputted)
        
        self.show(tabBarController, sender: self)
    }
    
    let chosenPlace: GMSPlace
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.chosenPlace.name
    }
    
    init(place: GMSPlace) {
        self.chosenPlace = place
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
