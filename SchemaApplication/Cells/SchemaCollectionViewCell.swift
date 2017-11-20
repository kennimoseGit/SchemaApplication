//
//  SchemaCollectionViewCell.swift
//  schematest
//
//  Created by Kenni Mose on 17/11/2017.
//  Copyright © 2017 kenni. All rights reserved.
//

import UIKit

class SchemaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var secondTextLabel: UILabel!
    @IBOutlet weak var thirdTextLabel: UILabel!
    
    override func awakeFromNib() {
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        
    }
    
}
