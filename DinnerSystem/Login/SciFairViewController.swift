//
//  SciFairViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2019/4/16.
//  Copyright © 2019 Sean.Inc. All rights reserved.
//

import UIKit

class SciFairViewController: UIViewController {

    @IBOutlet var ipText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func go(_ sender: Any) {
        dsIP = ipText.text!
        self.performSegue(withIdentifier: "goSegue", sender: self)
    }
    
    

}
