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
    
    var arrayOfDepartments = NSArray()
    
    var studentObject:NSMutableDictionary = NSMutableDictionary()

    let dbconnector = DBConnecter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionview.tableFooterView = UIView()

        getDepartmentsFromDBConnector()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        collectionview.isUserInteractionEnabled = true
    }
    
    func getDepartmentsFromDBConnector(){
        
        ALLoadingView.manager.showLoadingView(ofType: .basic)
        
        var token:String?
        
        if(defaults.object(forKey: "token") == nil){
            
            token = "dummytoken"
        }
        else {
            token = defaults.object(forKey: "token") as? String
        }
        
   
        dbconnector.getDepartments(token: token!) { (result, departments) in
            
            if(result == 401){
                
                self.dbconnector.createToken(completion: { (token) in
                    
                    self.dbconnector.getDepartments(token: token, completion: { (result, departments) in
                        
                        if(result != 200){
                            ALLoadingView.manager.hideLoadingView()
                            self.showAlertWith(title: "Error", message: "An error happened trying to fetch departments")
                        }
                        else{
                            self.arrayOfDepartments = departments
                            ALLoadingView.manager.hideLoadingView()
                            self.collectionview.reloadData()
                        }
                    })
                    
                })
            }
            else{
                if(result != 200){
                    ALLoadingView.manager.hideLoadingView()
                    self.showAlertWith(title: "Error", message: "An error happened trying to fetch departments")
                }
                else{
                    self.arrayOfDepartments = departments
                    ALLoadingView.manager.hideLoadingView()
                    self.collectionview.reloadData()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfDepartments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = collectionview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DepartmentTableViewCell
        
        var name: String? = (arrayOfDepartments[indexPath.row] as AnyObject).value(forKey: "name") as? String

        cell.departmentName.text = name
        
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
            
            var departmentId: Int? = (arrayOfDepartments[indexPath.row] as AnyObject).value(forKey: "id") as? Int
            
            defaults.set(departmentId, forKey: "departmentId")

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
