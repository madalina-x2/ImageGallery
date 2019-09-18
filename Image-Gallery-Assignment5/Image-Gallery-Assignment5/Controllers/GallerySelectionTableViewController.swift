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
    
    // MARK: - Actions
    
    @IBAction func didTapAddMore(_ sender: UIBarButtonItem) {
        addNewGallery()
        tableView.reloadData()
    }
    
    // MARK: - Class Methods
    
    func addNewGallery() {
        let galleryNames = (availableGalleries + recentlyDeletedGalleries).map { gallery in
            return gallery.title
        }
        let newImageGallery =  ImageGallery(
            images: [],
            title: "Empty".madeUnique(withRespectTo: galleryNames)
        )
        availableGalleries.insert(newImageGallery, at: 0)
    }
}
