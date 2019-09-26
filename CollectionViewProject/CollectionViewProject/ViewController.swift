//
//  ViewController.swift
//  CollectionViewProject
//
//  Created by Madalina Sinca on 25/09/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let datasource = ["title1", "title2", "title3"]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            guard let vc = segue.destination as? DetailsViewController else {
                return
            }
            
            guard let cell = sender as? UITableViewCell else {
                return
            }
            
            guard let indexPath = tableView.indexPath(for: cell) else {
                return
            }
            
            vc.details = datasource[indexPath.row]
        }
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            fatalError("bad")
        }
        
        cell.textLabel?.text = datasource[indexPath.row]
        
        return cell
    }
}
