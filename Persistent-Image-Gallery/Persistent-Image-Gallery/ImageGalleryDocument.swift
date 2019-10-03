//
//  Document.swift
//  Persistent-Image-Gallery
//
//  Created by Madalina Sinca on 02/10/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

class ImageGalleryDocument: UIDocument {
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        return Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
    }
}

