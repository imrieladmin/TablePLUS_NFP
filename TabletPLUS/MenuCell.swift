//
//  MenuCell.swift
//  TabletPLUS
//
//  Created by Ruchi Salvi on 09/06/15.
//  Copyright (c) 2015 dhaval shah. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet var imgMenuIcon: UIImageView!
    @IBOutlet var lblMenuItem: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setMenuCell(menuTitle: String,menuIconImage: UIImage) {
        
        
        self.imgMenuIcon.image = menuIconImage
        self.lblMenuItem.text = menuTitle
       
        
    }

}