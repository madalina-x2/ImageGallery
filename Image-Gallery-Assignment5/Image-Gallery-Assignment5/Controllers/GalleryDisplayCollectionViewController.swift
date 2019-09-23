//
//  GalleryDisplayCollectionViewController.swift
//  Image-Gallery-Assignment5
//
//  Created by Madalina Sinca on 18/09/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

private let reuseIdentifier = "imageCell"

class GalleryDisplayCollectionViewController: UICollectionViewController {
    
    

    // MARK: - Properties

    var imageGallery: ImageGallery! {
        didSet { collectionView?.reloadData() }
    }
    
    private var maximumItemWidth: CGFloat? {
        return collectionView?.frame.size.width
    }
    
    private var minimumItemWidth: CGFloat? {
        guard let collectionView = collectionView else { return nil }
        return (collectionView.frame.size.width / 3)
    }
    
    private var flowLayout: UICollectionViewFlowLayout? {
        return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    // MARK: - Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        collectionView!.dragDelegate = self
        collectionView!.dropDelegate = self
    }
    
    // MARK: - Collection View DataSource Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageGallery?.images.count ?? 0
    }
}

// MARK: - CollectionView Drag Delegate Extension

extension GalleryDisplayCollectionViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        // ?
        return [UIDragItem]()
    }
}

// MARK: - CollectionView Drop Delegate Extension

extension GalleryDisplayCollectionViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        // ?
    }
}

// MARK: - UIDropInteraction Delegate Extension

extension GalleryDisplayCollectionViewController: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: URL.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
}
