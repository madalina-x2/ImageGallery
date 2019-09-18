//
//  GallerySelectionTableViewCell.swift
//  Image-Gallery-Assignment5
//
//  Created by Madalina Sinca on 18/09/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

class GallerySelectionTableViewCell: UITableViewCell, UITextFieldDelegate {

    // MARK: - Properties
    
    internal var delegate: GallerySelectionTableViewCellDelegate?
    
    @IBOutlet weak var galleryTitleTextField: UITextField!
    
    var title: String {
        set {
            galleryTitleTextField?.text = newValue
        }
        get {
            return galleryTitleTextField.text ?? ""
        }
    }
    
    override internal var isEditing: Bool {
        didSet {
            galleryTitleTextField.isEnabled = isEditing
            
            if isEditing == true {
                galleryTitleTextField.becomeFirstResponder()
            } else {
                galleryTitleTextField.resignFirstResponder()
            }
        }
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    @objc internal func titleDidChange(_ sender: UITextField) {
        guard let title = sender.text, title != "" else {
            return
        }
        
        delegate?.titleDidChange(sender.text ?? "", in: self)
    }
    
    override internal var canBecomeFirstResponder: Bool {
        return isEditing
    }
    
    // use textFieldShouldEndEditing() to validate input from user ?
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        endEditing()
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
    
    // MARK: - Auxiliary Methods
    
    private func endEditing() {
        isEditing = false
    }
}

// MARK: - Protocols

protocol GallerySelectionTableViewCellDelegate {
    func titleDidChange(_ title: String, in cell: UITableViewCell)
}
