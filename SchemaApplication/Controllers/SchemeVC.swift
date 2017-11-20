//
//  ViewController.swift
//  schematest
//
//  Created by Kenni Mose on 17/11/2017.
//  Copyright © 2017 kenni. All rights reserved.
//

import UIKit

class SchemeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionview: UICollectionView!
    //let backButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        /*backButton.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
         backButton.layer.cornerRadius = 0.5 * backButton.bounds.size.width
         backButton.clipsToBounds = true
         backButton.setTitle("Logout", for: .normal)
         backButton.setTitleColor(UIColor.red, for: .normal)
         backButton.titleLabel?.font = UIFont(name: "Arial-MT", size: 2)
         
         backButton.backgroundColor = UIColor.white
         backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
         view.addSubview(backButton)*/
    }
    
    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeLeft
    }
    private func shouldAutorotate() -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SchemaCollectionViewCell
        
        switch indexPath.row {
        case 0:
            cell.titleTextLabel.text = ""
            cell.secondTextLabel.text = "Monday"
            cell.thirdTextLabel.text = ""
        case 1:
            cell.titleTextLabel.text = ""
            cell.secondTextLabel.text = "Tuesday"
            cell.thirdTextLabel.text = ""
        case 2:
            cell.titleTextLabel.text = ""
            cell.secondTextLabel.text = "Wednesday"
            cell.thirdTextLabel.text = ""
        case 3:
            cell.titleTextLabel.text = ""
            cell.secondTextLabel.text = "Thursday"
            cell.thirdTextLabel.text = ""
        case 4:
            cell.titleTextLabel.text = ""
            cell.secondTextLabel.text = "Friday"
            cell.thirdTextLabel.text = ""
        case 5:
            cell.titleTextLabel.text = "HCI"
            cell.secondTextLabel.text = "08.30 - 12.00"
            cell.thirdTextLabel.text = "Dora Todorka"
        case 6:
            cell.titleTextLabel.text = ""
            cell.secondTextLabel.text = ""
            cell.thirdTextLabel.text = ""
        case 7:
            cell.titleTextLabel.text = ""
            cell.secondTextLabel.text = ""
            cell.thirdTextLabel.text = ""
        case 8:
            cell.titleTextLabel.text = "Testing"
            cell.secondTextLabel.text = "08.30 - 12.00"
            cell.thirdTextLabel.text = "Jarl Tuxen"
        case 9:
            cell.titleTextLabel.text = "Database"
            cell.secondTextLabel.text = "09.15 - 12.00"
            cell.thirdTextLabel.text = "Dora Todorka"
        case 10:
            cell.titleTextLabel.text = ""
            cell.secondTextLabel.text = ""
            cell.thirdTextLabel.text = ""
        case 11:
            cell.titleTextLabel.text = "Web Security"
            cell.secondTextLabel.text = "12.00 - 16.00"
            cell.thirdTextLabel.text = "Lars Friberg"
        case 12:
            cell.titleTextLabel.text = ""
            cell.secondTextLabel.text = ""
            cell.thirdTextLabel.text = ""
        case 13:
            cell.titleTextLabel.text = "Cryptographi"
            cell.secondTextLabel.text = "12.30 - 16.00"
            cell.thirdTextLabel.text = "Lorena Madridista"
        case 14:
            cell.titleTextLabel.text = "Testing"
            cell.secondTextLabel.text = "12.30 - 15.00"
            cell.thirdTextLabel.text = "Jarl Tuxen"
        default:
            break
        }
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.invalidateLayout()
        
        return CGSize(width: (self.view.frame.width/5), height: (self.view.frame.height/3))
    }
    
    @objc func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

