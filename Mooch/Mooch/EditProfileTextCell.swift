//
//  EditProfileTextCell.swift
//  Mooch
//
//  Created by adam on 10/10/16.
//  Copyright © 2016 cse498. All rights reserved.
//

import UIKit

class EditProfileTextCell: UITableViewCell, EditProfileField {
    
    static let Identifier = "EditProfileTextCell"
    static let EstimatedHeight: CGFloat = 40
    
    
    @IBOutlet weak var topSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var textField: EditProfileTextField!
    @IBOutlet weak var bottomSeperator: UIView!
    
    var fieldType: EditProfileConfiguration.FieldType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bottomSeperator.backgroundColor = ThemeColors.formSeperator.color()
    }
}
