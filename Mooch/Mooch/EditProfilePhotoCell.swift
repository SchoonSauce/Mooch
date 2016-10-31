//
//  EditProfilePhotoCell.swift
//  Mooch
//
//  Created by adam on 10/10/16.
//  Copyright © 2016 cse498. All rights reserved.
//

import UIKit

class EditProfilePhotoCell: UITableViewCell, EditProfileField {
    
    static let Identifier = "EditProfilePhotoCell"
    static let EstimatedHeight: CGFloat = 220
    
    @IBOutlet weak var photoAddingView: PhotoAddingView!
    @IBOutlet weak var bottomSeperator: UIView!
    
    var fieldType: EditProfileConfiguration.FieldType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bottomSeperator.backgroundColor = ThemeColors.formSeperator.color()
    }
}
