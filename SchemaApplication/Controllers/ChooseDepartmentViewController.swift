//
//  ChooseDepartmentViewController.swift
//  SchemaApplication
//
//  Created by Kenni Mose on 24/11/2017.
//  Copyright © 2017 kenni. All rights reserved.
//

import UIKit

class ChooseDepartmentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var collectionview: UITableView!
    
    let arrayOfDepartments:[String] = ["Kea Guldbergsgade", "Kea Lygten 16", "Kea Jagtvej", "Kea Lygten 37"]
    
    var studentObject:NSMutableDictionary = NSMutableDictionary()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionview.tableFooterView = UIView()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        collectionview.isUserInteractionEnabled = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfDepartments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = collectionview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DepartmentTableViewCell
        
        cell.departmentName.text = arrayOfDepartments[indexPath.row]
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = collectionview.cellForRow(at: indexPath) as? DepartmentTableViewCell {
            cell.didSelect(indexPath: indexPath as NSIndexPath)
            
            collectionview.isUserInteractionEnabled = false
            
            let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ChooseCoursesViewController") as! ChooseCoursesViewController
                
                vc.studentObject = self.studentObject
                
                self.present(vc, animated: true, completion: nil)
            }
        }
    }

    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = collectionview.cellForRow(at: indexPath) as? DepartmentTableViewCell {
            cell.didDeSelect(indexPath: indexPath as NSIndexPath)
        }
    }
  
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
