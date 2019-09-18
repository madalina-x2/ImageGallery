//
//  GallerySelectionTableViewController.swift
//  Image-Gallery-Assignment5
//
//  Created by Madalina Sinca on 17/09/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

class GallerySelectionTableViewController: UITableViewController {

    // MARK: - Read-Only Properties
    
    private(set) var availableGalleries: [ImageGallery] = []
    private(set) var recentlyDeletedGalleries: [ImageGallery] = []
    
    // MARK: - Private Properties
    
    private var detailController: GalleryDisplayCollectionViewController? {
        return splitViewController?.viewControllers.last?.contents as? GalleryDisplayCollectionViewController
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
