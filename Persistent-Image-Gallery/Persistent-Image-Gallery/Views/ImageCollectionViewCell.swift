//
//  ImageCollectionViewCell.swift
//  Image-Gallery-Assignment5
//
//  Created by Madalina Sinca on 17/09/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var fetcher: ImageFetcher!
    var isLoading = true {
        didSet {
            if isLoading {
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
            }
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        isLoading = true
    }
    
    // MARK: - Class Methods
    
    func populateWithURLImage(url: URL) {
        fetcher = ImageFetcher(fetch: url) { (url, image) in
            DispatchQueue.main.async {
                self.imageView.image = image
                self.isLoading = false
            }
        }
    }
}
