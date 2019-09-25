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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addInteraction(UIDropInteraction(delegate: self))
        
        print("entered gallery \(imageGallery?.title)")
    }
    
    // MARK: - Auxiliary
    
    private func getImage(at indexPath: IndexPath) -> Image? {
        return imageGallery?.images[indexPath.item]
    }
    
    // MARK: - Collection View DataSource Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageGallery?.images.count ?? 0
    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//
//        guard let galleryImage = getImage(at: indexPath) else { return cell }
//
//        if let imageCell = cell as? ImageCollectionViewCell {
//            imageCell.isLoading = true
//            URLSession(configuration: .default).dataTask(with: galleryImage.imagePath!) { (data, response, error) in
//                if let imageData = data {
//                    let currentImage = UIImage(data: imageData)
//                    imageCell.imageView.image = currentImage
//                    imageCell.isLoading = false
//                }
//            }
//        }
//        return cell
//    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        guard let galleryImage = getImage(at: indexPath) else { return cell }

        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.isLoading = true
            URLSession(configuration: .default).dataTask(with: galleryImage.imagePath!) { (data, response, error) in
                if let imageData = data {
                    let currentImage = UIImage(data: imageData)
                    imageCell.imageView.image = currentImage
                    imageCell.isLoading = false
                }
            }
        }
        return cell
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
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        if collectionView.hasActiveDrag {
            return session.canLoadObjects(ofClass: URL.self)
        } else {
            return session.canLoadObjects(ofClass: URL.self) && session.canLoadObjects(ofClass: UIImage.self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        
        for item in coordinator.items {
            // item originates from this collection view
            if let sourceIndexPath = item.sourceIndexPath {
                // rearrange items in gallery AND in view
            } else {// drag&drop from outside the app
                
                // create a dummy image to replace the one to be dropped until it appears in the view
                var draggedImage = Image(imagePath: nil, aspectRatio: 1)
                
                // load actual image and get its aspect ratio
                let itemProviderCopy = item.dragItem.itemProvider.copy() as? NSItemProvider
                _ = item.dragItem.itemProvider.loadObject(ofClass: UIImage.self){ (provider, error) in
                    if let image = provider as? UIImage {
                        draggedImage.aspectRatio = image.aspectRatio
                        
                        // load the URL
                        _ = itemProviderCopy?.loadObject(ofClass: URL.self) { (provider, error) in
                            if let url = provider?.imageURL {
                                draggedImage.imagePath = url
                                self.imageGallery.images.append(draggedImage)
                            }
                        }
                    }
                }
                

            }
        }
    }
}

// MARK: - UIDropInteraction Delegate Extension

extension GalleryDisplayCollectionViewController: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: URL.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
}
