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
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView?.reloadData()
            }
            print("entered gallery \(String(describing: imageGallery.title))")
        }
    }
    
    var imageGalleryHandler: ImageGalleryHandler!
    
    private var maximumItemWidth: CGFloat? {
        return collectionView?.frame.size.width
    }
    
    private var minimumItemWidth: CGFloat? {
        guard let collectionView = collectionView else { return nil }
        return (collectionView.frame.size.width / 3) - 5
    }
    
    private var flowLayout: UICollectionViewFlowLayout? {
        return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    private lazy var itemWidth: CGFloat = { return minimumItemWidth ?? 0 }()
    
    private var pinchGestureRecognizer: UIPinchGestureRecognizer!
    
    // MARK: - Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        collectionView!.dragDelegate = self
        collectionView!.dropDelegate = self
        flowLayout?.minimumLineSpacing = 5
        flowLayout?.minimumInteritemSpacing = 5
    }
    
    var fetcher: ImageFetcher!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addInteraction(UIDropInteraction(delegate: self))
        
        pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinchToScale))
        self.collectionView?.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectImage",
            let imageDisplayer = segue.destination as? ImageDisplayViewController,
            let imageCell = sender as? ImageCollectionViewCell,
            let imageIndex = collectionView?.indexPath(for: imageCell)?.row {
            imageDisplayer.downloadImageFrom(url: imageGallery.images[imageIndex].imagePath!)
        }
    }
    
    // MARK: - Auxiliary
    
    @objc func didPinchToScale() {
        guard let maximumItemWidth = maximumItemWidth else { return }
        guard let minimumItemWidth = minimumItemWidth else { return }
        guard itemWidth <= maximumItemWidth else { return }
        
        if pinchGestureRecognizer.state == .began || pinchGestureRecognizer.state == .changed {
            let scaledWidth = itemWidth * pinchGestureRecognizer.scale
            
            if scaledWidth <= maximumItemWidth,
                scaledWidth >= minimumItemWidth {
                itemWidth = scaledWidth
                flowLayout?.invalidateLayout()
            }
            
            pinchGestureRecognizer.scale = 1
        }
    }
    
    private func getImage(at indexPath: IndexPath) -> Image? {
        return imageGallery?.images[indexPath.item]
    }
    
    private func insertImage(_ image: Image, at indexPath: IndexPath) {
        imageGallery!.images.insert(image, at: indexPath.item)
        print("Updated \(imageGallery!.images.count)")
        imageGalleryHandler.updateGallery(imageGallery!)
    }
    
    // MARK: - Collection View DataSource Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageGallery?.images.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        guard let galleryImage = getImage(at: indexPath) else { return cell }

        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.isLoading = true
            guard let imageURL = galleryImage.imagePath else {
                fatalError("no URL found")
            }
            imageCell.populateWithURLImage(url: imageURL)
        } 
        return cell
    }
}

// MARK: - CollectionView FlowLayout Delegate Extension

extension GalleryDisplayCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let galleryImage = imageGallery.images[indexPath.item]
        let itemHeight = itemWidth / CGFloat(galleryImage.aspectRatio)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

// MARK: - CollectionView Drag Delegate Extension

extension GalleryDisplayCollectionViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return getDragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return getDragItems(at: indexPath)
    }
    
    private func getDragItems(at indexPath: IndexPath) -> [UIDragItem] {
        var dragItems = [UIDragItem]()
        
        if let galleryImage = getImage(at: indexPath) {
            if let imageURL = galleryImage.imagePath as NSURL? {
                let urlItem = UIDragItem(itemProvider: NSItemProvider(object: imageURL))
                urlItem.localObject = galleryImage
                dragItems.append(urlItem)
            }
        }
        
        return dragItems
    }
}

// MARK: - CollectionView Drop Delegate Extension

extension GalleryDisplayCollectionViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        dropSessionDidUpdate session: UIDropSession,
                        withDestinationIndexPath destinationIndexPath: IndexPath?
        ) -> UICollectionViewDropProposal {
        guard imageGallery != nil else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
        
        let isDragFromThisApp = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        
        return UICollectionViewDropProposal(operation: isDragFromThisApp ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
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
            if let sourceIndexPath = item.sourceIndexPath {
                if let galleryImage = item.dragItem.localObject as? Image {
                    collectionView.performBatchUpdates({
                        self.imageGallery.images.remove(at: sourceIndexPath.item)
                        self.imageGallery.images.insert(galleryImage, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            } else {
                
                var draggedImage = Image(imagePath: nil, aspectRatio: 1)
                
                let itemProviderCopy = item.dragItem.itemProvider.copy() as? NSItemProvider
                _ = item.dragItem.itemProvider.loadObject(ofClass: UIImage.self){ (provider, error) in
                    if let image = provider as? UIImage {
                        draggedImage.aspectRatio = image.aspectRatio
                        
                        _ = itemProviderCopy?.loadObject(ofClass: URL.self) { (provider, error) in
                            if let url = provider?.imageURL {
                                draggedImage.imagePath = url
                                self.imageGallery.images.append(draggedImage)
                                self.imageGalleryHandler.updateGallery(self.imageGallery)
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
        return UIDropProposal(operation: .move)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let item = session.items.first else { return }
        guard let droppedImage = item.localObject as? Image else { return }
        guard let index = imageGallery.images.index(of: droppedImage) else { return }
        
        imageGallery.images.remove(at: index)
        imageGalleryHandler.updateGallery(imageGallery)
    }
}
