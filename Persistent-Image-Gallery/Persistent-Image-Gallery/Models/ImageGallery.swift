//
//  ImageGallery.swift
//  Image-Gallery-Assignment5
//
//  Created by Madalina Sinca on 17/09/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import Foundation

struct ImageGallery: Codable {
    
    // MARK: - Properties
    
    var images: [Image]
    var title: String
    var json: Data? { return try? JSONEncoder().encode(self) }
    
    // MARK: - Initializers
    
    init?(json: Data) {
        if json.isEmpty {
            self =  ImageGallery(images: [], title: "Untitled")
            return
        }
        if let newValue = try? JSONDecoder().decode(ImageGallery.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    
    init(images: [Image], title: String) {
        self.images = images
        self.title = title
    }
    
}
