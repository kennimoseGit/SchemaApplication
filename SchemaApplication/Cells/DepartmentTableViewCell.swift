//
//  DepartmentTableViewCell.swift
//  SchemaApplication
//
//  Created by Kenni Mose on 24/11/2017.
//  Copyright © 2017 kenni. All rights reserved.
//

import UIKit

class DepartmentTableViewCell: UITableViewCell {

    @IBOutlet weak var departmentName: UILabel!
    @IBOutlet weak var isChoosenImageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func didSelect(indexPath: NSIndexPath) {
        // perform some actions here
        isChoosenImageview.image = UIImage(named:"checkmark")
    }
    
    func didDeSelect(indexPath: NSIndexPath) {
        // perform some actions here
        isChoosenImageview.image = nil
    }

}
