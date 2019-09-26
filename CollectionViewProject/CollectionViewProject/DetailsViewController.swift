//
//  DetailsViewController.swift
//  CollectionViewProject
//
//  Created by Madalina Sinca on 25/09/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    var details = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = details
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
