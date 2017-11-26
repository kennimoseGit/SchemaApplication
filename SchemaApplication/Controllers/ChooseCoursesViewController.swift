//
//  ChooseCoursesViewController.swift
//  SchemaApplication
//
//  Created by Kenni Mose on 24/11/2017.
//  Copyright © 2017 kenni. All rights reserved.
//

import UIKit

class ChooseCoursesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var collectionview: UITableView!
    @IBOutlet weak var okButton: UIButton!
    
    let arrayOfCourses:[String] = ["HCI", "Testing", "Database", "Crytographi"]
    
    var studentObject:NSMutableDictionary = NSMutableDictionary()
    
    let dbConnector = DBConnecter()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionview.tableFooterView = UIView()
        okButton.layer.cornerRadius = 20
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = collectionview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CoursesTableViewCell
        
        cell.coursesName.text = arrayOfCourses[indexPath.row]
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = collectionview.cellForRow(at: indexPath) as? CoursesTableViewCell {
            cell.didSelect(indexPath: indexPath as NSIndexPath)
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okButtonAction(_ sender: Any) {
    
        ALLoadingView.manager.showLoadingView(ofType: .basic)

        var token:String?
        
        if(defaults.object(forKey: "token") == nil){
            
            token = "dummytoken"
        }
        else {
            token = defaults.object(forKey: "token") as! String
        }
        
        dbConnector.createUser(token: token!, studentObject: studentObject) { (result) in
            
            if(result == 401){
                self.dbConnector.createToken(completion: { (token) in
                    
                    self.dbConnector.createUser(token: token, studentObject: self.studentObject, completion: { (result) in
                        
                        if(result != 200){
                            
                            ALLoadingView.manager.hideLoadingView()
                            
                            self.showAlertWith(title: "Error", message: "An error happened trying to create user")
                        }
                        else{
                            
                            ALLoadingView.manager.hideLoadingView()
                            
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                            self.present(loginViewController, animated: true, completion: nil)
                        }
                        
                    })
                })
            }
            else{
                if(result != 200){
                    
                    ALLoadingView.manager.hideLoadingView()
                    
                    self.showAlertWith(title: "Error", message: "An error happened trying to create user")
                }
                else{
                    
                    ALLoadingView.manager.hideLoadingView()
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.present(loginViewController, animated: true, completion: nil)
                }
            }
        }
    }
}
