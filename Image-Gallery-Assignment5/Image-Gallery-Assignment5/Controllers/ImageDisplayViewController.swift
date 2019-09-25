//
//  ImageDisplayViewController.swift
//  Image-Gallery-Assignment5
//
//  Created by Madalina Sinca on 17/09/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

class ImageDisplayViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var image: Image!
    
    // MARK: - Lifecycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        URLSession(configuration: .default).dataTask(with: image.imagePath!) { (data, response, error) in
            if let imageData = data {
                self.imageView?.image = UIImage(data: imageData)
            }
        }
    }
}

// MARK: - ScrollView Delegate Extension

extension ImageDisplayViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
