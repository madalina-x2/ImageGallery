//
//  ImageGallery.swift
//  Image-Gallery-Assignment5
//
//  Created by Madalina Sinca on 17/09/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import Foundation

struct ImageGallery: Hashable {
    
    // MARK: - Properties
    
    let identifier: String = UUID().uuidString
    var images: [Image]
    var title: String
    var hashValue: Int { return identifier.hashValue }
    
    // MARK: - Hashable
    
    static func ==(lhs: ImageGallery, rhs: ImageGallery) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
