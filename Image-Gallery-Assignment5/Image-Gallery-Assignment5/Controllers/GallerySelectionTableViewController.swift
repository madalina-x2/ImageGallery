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
    private enum Section: Int {
        case available = 0
        case deleted
    }
    private var allGalleries: [[ImageGallery]] {
        get { return [availableGalleries, recentlyDeletedGalleries] }
    }
    
    // Mark: - Overriden Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapToEdit))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.tableView.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    // MARK: - Actions
    
    @IBAction func didTapAddMore(_ sender: UIBarButtonItem) {
        addNewGallery()
        tableView.reloadData()
    }
    
    @objc func didDoubleTapToEdit(_ sender: UITapGestureRecognizer) {
        if let indexPath = tableView.indexPathForRow(at: sender.location(in: tableView)) {
            if let cell = tableView.cellForRow(at: indexPath) as? GallerySelectionTableViewCell {
                cell.isEditing = true
            }
        }
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
    
    // MARK: - UITableViewDataSource Overriden Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allGalleries.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGalleries[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "galleryCell",
                                                 for: indexPath)
        if let galleryCell = cell as? GallerySelectionTableViewCell {
            galleryCell.isEditing = false
            galleryCell.galleryTitleTextField.text = allGalleries[indexPath.section][indexPath.row].title
            galleryCell.galleryTitleTextField.delegate = galleryCell
        }
        return cell
    }
}
