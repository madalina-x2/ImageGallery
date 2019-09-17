//
//  ImageGalleryHandler.swift
//  Image-Gallery-Assignment5
//
//  Created by Madalina Sinca on 17/09/2019.
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
}
