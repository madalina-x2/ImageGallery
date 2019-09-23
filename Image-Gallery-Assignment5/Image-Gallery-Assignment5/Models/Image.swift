//
//  Image.swift
//  Image-Gallery-Assignment5
//
//  Created by Madalina Sinca on 17/09/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import Foundation

struct Image {
    
    // MARK: - Properties
    
    var imagePath: URL?
    var aspectRatio: Double
    var imageData: Data?
    
    /// MARK: - Initializer
    
    init(imagePath: URL?, aspectRatio: Double) {
        self.imagePath = imagePath
        self.aspectRatio = aspectRatio
    }
}
