//
//  MainTableViewCell.swift
//  SwiftShowcase
//
//  Created by cedro_nds on 07/12/16.
//  Copyright © 2016 Rafael Rezende Machado. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    //Outles
    @IBOutlet weak var viewContainerCell: UIView!
    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var titleLabelCell: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
