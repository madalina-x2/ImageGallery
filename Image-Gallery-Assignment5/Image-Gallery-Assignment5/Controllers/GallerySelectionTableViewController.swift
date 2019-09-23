//
//  GallerySelectionTableViewController.swift
//  Image-Gallery-Assignment5
//
//  Created by Madalina Sinca on 17/09/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

class GallerySelectionTableViewController: UITableViewController, GallerySelectionTableViewCellDelegate {

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
    
    // Mark: - Outlets
    
    @IBOutlet weak var addGalleryButton: UIBarButtonItem!
    
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
                addGalleryButton.isEnabled = false
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
            title: "Untitled".madeUnique(withRespectTo: galleryNames)
        )
        availableGalleries.insert(newImageGallery, at: 0)
    }
    
    private func getGallery(at indexPath: IndexPath) -> ImageGallery? {
        return allGalleries[indexPath.section][indexPath.row]
    }
    
    func updateGallery(_ gallery: ImageGallery) {
        if let galleryIndex = availableGalleries.index(of: gallery) {
            availableGalleries[galleryIndex] = gallery
            
            // make a notification?
        }
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
        let gallery = getGallery(at: indexPath)
        if let galleryCell = cell as? GallerySelectionTableViewCell {
            galleryCell.isEditing = false
            galleryCell.delegate = self
            galleryCell.title = gallery!.title
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let section = Section(rawValue: indexPath.section)
        return section == .available
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 { return "Recently Deleted" }
        return nil
    }
    
     // MARK: - Delegates
    
    func titleDidChange(_ title: String, in cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            if var gallery = getGallery(at: indexPath) {
                gallery.title = title
                updateGallery(gallery)
                tableView.reloadData()
            }
        }
        addGalleryButton.isEnabled = true
    }
}
