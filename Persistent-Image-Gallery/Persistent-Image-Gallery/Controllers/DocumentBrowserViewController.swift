//
//  DocumentBrowserViewController.swift
//  Persistent-Image-Gallery
//
//  Created by Madalina Sinca on 02/10/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit


class DocumentBrowserViewController: UIDocumentBrowserViewController {
    
    // MARK: - Private Properties
    
    private var template: URL?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        if UIDevice.current.userInterfaceIdiom == .pad {
            setupForPad()
        }
    }
    
    // MARK: - Auxiliary Methods
    
    func setupForPad() {
        template = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
            ).appendingPathComponent("Untitled.json")
        if template != nil {
            allowsDocumentCreation = FileManager.default.createFile(atPath: template!.path, contents: Data())
        }
    }
}

    // MARK: UIDocumentBrowserViewControllerDelegate Extension

extension DocumentBrowserViewController: UIDocumentBrowserViewControllerDelegate {
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        importHandler(template, .copy)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
    }
    
    // MARK: - Document Presentation
    
    func presentDocument(at documentURL: URL) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let documentVC = storyBoard.instantiateViewController(withIdentifier: "ImageGalleryEntryPoint")
        if let galleryDisplayCollectionViewController = documentVC.contents as? GalleryDisplayCollectionViewController {
            galleryDisplayCollectionViewController.imageGalleryDocument = ImageGalleryDocument(fileURL: documentURL)
            present(documentVC, animated: true)
        }
    }
}

