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
    
    @IBOutlet weak var scrollView: UIScrollView!
    private var imageView = UIImageView()
    private var fetcher: ImageFetcher!
    
    // MARK: - Lifecycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1 / 10
        scrollView.maximumZoomScale = 5
    }
    
    func fitImageViewToWindow(image: UIImage) {
        let rect: CGRect
        if image.size.height > image.size.width {
            let newWidth = view.bounds.size.height * CGFloat(image.aspectRatio)
            rect = CGRect(x: (view.bounds.size.width - newWidth) / 2, y: 0, width: newWidth, height: view.bounds.size.height - view.safeAreaInsets.top)
        } else {
            let newHeight = view.bounds.size.width / CGFloat(image.aspectRatio)
            rect = CGRect(x: 0, y: (view.bounds.size.height - view.safeAreaInsets.top - newHeight) / 2, width: view.bounds.size.width, height: newHeight)
        }
        imageView.frame = rect
    }
    
    func downloadImageFrom(url: URL) {
        fetcher = ImageFetcher(fetch: url) { (url, image) in
            DispatchQueue.main.async {
                self.imageView.image = image
                self.fitImageViewToWindow(image: image)
                self.scrollView.addSubview(self.imageView)
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
