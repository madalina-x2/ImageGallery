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
        guard let indexPath = tableView.indexPathForRow(at: sender.location(in: tableView)) else {
            fatalError("unknown index path")
        }
        guard let cell = tableView.cellForRow(at: indexPath) as? GallerySelectionTableViewCell else {
            fatalError("unknown cell")
        }
        cell.isEditing = true
        addGalleryButton.isEnabled = false
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectGallerySegue",
            let navigationController = segue.destination as? UINavigationController,
            let displayController = navigationController.visibleViewController as? GalleryDisplayCollectionViewController,
            let imageGalleryIndex = tableView.indexPathForSelectedRow?.row {
                displayController.imageGallery = allGalleries[0][imageGalleryIndex]
                displayController.imageGalleryHandler = imageGalleryHandler
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
        guard let galleryCell = tableView.dequeueReusableCell(withIdentifier: "galleryCell",
                                                              for: indexPath) as? GallerySelectionTableViewCell else {
                                                                fatalError("unknown cell")
        }
        let gallery = getGallery(at: indexPath)
        galleryCell.isEditing = false
        galleryCell.delegate = self
        galleryCell.title = gallery!.title
        return galleryCell
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
            guard let galleryToDelete = getGallery(at: indexPath) else { fatalError("could not find gallery to delete") }
            imageGalleryHandler.deleteGallery(galleryToDelete)
            tableView.reloadData()
            break
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let section = Section(rawValue: indexPath.section)
        if section == .deleted {
            var actions = [UIContextualAction]()
            let recoverAction = UIContextualAction(style: .normal, title: "Recover") { (action, view, _) in
                guard let deletedGallery = self.getGallery(at: indexPath) else { fatalError("could not find gallery to recover") }
                self.imageGalleryHandler.recoverGallery(deletedGallery)
                self.tableView.reloadData()
            }
            actions.append(recoverAction)
            return UISwipeActionsConfiguration(actions: actions)
        }
        return nil
    }
    
     // MARK: - Delegates
    
    func titleDidChange(_ title: String, in cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { fatalError("unknown index path") }
        if var gallery = getGallery(at: indexPath) {
            gallery.title = title
            imageGalleryHandler.updateGallery(gallery)
            tableView.reloadData()
        }
        addGalleryButton.isEnabled = true
    }
}
