//
//  ImageGallery.swift
//  Image-Gallery-Assignment5
//
//  Created by Madalina Sinca on 17/09/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import Foundation

struct ImageGallery: Hashable, Codable {
    
    // MARK: - Properties
    
    let identifier: String = UUID().uuidString
    var images: [Image]
    var title: String
    var hashValue: Int { return identifier.hashValue }
    var json: Data? { return try? JSONEncoder().encode(self) }
    
    // MARK: - Hashable
    
    static func ==(lhs: ImageGallery, rhs: ImageGallery) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    // MARK: - Initializers
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(ImageGallery.self, from: json) {
            self.images = newValue.images
            self.title = newValue.title
        } else {
            return nil
        }
    }
    
    init(images: [Image], title: String) {
        self.images = images
        self.title = title
    }
}
