//
//  Image.swift
//  Image-Gallery-Assignment5
//
//  Created by Madalina Sinca on 17/09/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import Foundation

struct Image: Hashable, Codable {
    
    // MARK: - Properties
    
    var imagePath: URL?
    var aspectRatio: Double
    let identifier: String = UUID().uuidString
    var hashValue: Int { return identifier.hashValue }
    
    /// MARK: - Initializer
    
    init(imagePath: URL?, aspectRatio: Double) {
        self.imagePath = imagePath
        self.aspectRatio = aspectRatio
    }
}
