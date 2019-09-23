//
//  GallerySelectionTableViewController.swift
//  Image-Gallery-Assignment5
//
//  Created by Madalina Sinca on 17/09/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

class GallerySelectionTableViewController: UITableViewController, GallerySelectionTableViewCellDelegate {
    
    // MARK: - Private Properties
    
    private var imageGalleryHandler = ImageGalleryHandler()
    
    private var detailController: GalleryDisplayCollectionViewController? {
        return splitViewController?.viewControllers.last?.contents as? GalleryDisplayCollectionViewController
    }
    private enum Section: Int {
        case available = 0
        case deleted
    }
    private var allGalleries: [[ImageGallery]] {
        get {
            return [imageGalleryHandler.availableGalleries, imageGalleryHandler.recentlyDeletedGalleries]
        }
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
    
    // MARK: Class Methods
    
    func getGallery(at indexPath: IndexPath) -> ImageGallery? {
        return allGalleries[indexPath.section][indexPath.row]
    }
    
    // MARK: - Actions
    
    @IBAction func didTapAddMore(_ sender: UIBarButtonItem) {
        imageGalleryHandler.addNewGallery()
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            if let galleryToDelete = getGallery(at: indexPath) {
                imageGalleryHandler.deleteGallery(galleryToDelete)
                tableView.reloadData()
            }
            break
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let section = Section(rawValue: indexPath.section)
        if section == .deleted {
            var actions = [UIContextualAction]()
            let recoverAction = UIContextualAction(style: .normal, title: "Recover") { (action, view, _) in
                if let deletedGallery = self.getGallery(at: indexPath) {
                    self.imageGalleryHandler.recoverGallery(deletedGallery)
                    self.tableView.reloadData()
                }
            }
            actions.append(recoverAction)
            return UISwipeActionsConfiguration(actions: actions)
        }
        return nil
    }
    
     // MARK: - Delegates
    
    func titleDidChange(_ title: String, in cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            if var gallery = getGallery(at: indexPath) {
                gallery.title = title
                imageGalleryHandler.updateGallery(gallery)
                tableView.reloadData()
            }
        }
        addGalleryButton.isEnabled = true
    }
}
