//
//  ImageGalleryHandler.swift
//  Image-Gallery-Assignment5
//
//  Created by Madalina Sinca on 23/09/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import Foundation

class ImageGalleryHandler {
    
    // MARK: - Read-Only Properties
    
    private(set) var availableGalleries: [ImageGallery]
    private(set) var recentlyDeletedGalleries: [ImageGallery]
    
    // MARK: - Initializer
    
    init() {
        availableGalleries = []
        recentlyDeletedGalleries = []
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
    
    func updateGallery(_ gallery: ImageGallery) {
        if let galleryIndex = availableGalleries.index(of: gallery) {
            availableGalleries[galleryIndex] = gallery
            
            // make a notification?
        }
    }
    
    func deleteGallery(_ gallery: ImageGallery) {
        if let galleryIndex = availableGalleries.index(of: gallery) {
            recentlyDeletedGalleries.append(availableGalleries.remove(at: galleryIndex))
        } else if let deletedGalleryIndex = recentlyDeletedGalleries.index(of: gallery) {
            recentlyDeletedGalleries.remove(at: deletedGalleryIndex)
        }
    }
    
    func recoverGallery(_ gallery: ImageGallery) {
        if let deletedIndex = recentlyDeletedGalleries.index(of: gallery) {
            availableGalleries.append(recentlyDeletedGalleries.remove(at: deletedIndex))
        }
    }
}
