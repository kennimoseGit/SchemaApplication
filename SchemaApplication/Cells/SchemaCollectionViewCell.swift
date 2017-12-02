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
    
    @IBOutlet weak var classroom: UILabel!
    @IBOutlet weak var weekday: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var ects: UILabel!
    
    
    override func awakeFromNib() {

    }
    
}
