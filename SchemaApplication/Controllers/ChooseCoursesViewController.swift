//
//  ChooseCoursesViewController.swift
//  SchemaApplication
//
//  Created by Kenni Mose on 24/11/2017.
//  Copyright © 2017 kenni. All rights reserved.
//

import UIKit

var arrayOfSelectedCourses = [Int]()

class ChooseCoursesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var collectionview: UITableView!
    @IBOutlet weak var okButton: UIButton!
    
    var arrayOfCourses = NSArray()
    
    var studentObject:NSMutableDictionary = NSMutableDictionary()
    
    let dbConnector = DBConnecter()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionview.tableFooterView = UIView()
        okButton.layer.cornerRadius = 20
        
        self.getCoursesFromDepartment()
    }
    
    func getCoursesFromDepartment(){
        
        ALLoadingView.manager.showLoadingView(ofType: .basic)
        
        var token:String?
        
        if(defaults.object(forKey: "token") == nil){
            
            token = "dummytoken"
        }
        else {
            token = defaults.object(forKey: "token") as? String
        }
        
        let departmentId = defaults.object(forKey: "departmentId") as? Int
        
        dbConnector.getCourses(token: token!, departmentId: departmentId!) { (result, array) in
            
            if(result == 401){
            
                self.dbConnector.createToken(completion: { (token) in
                    
                    self.dbConnector.getCourses(token: token, departmentId: departmentId!, completion: { (result, array) in
                        
                        if(result != 200){
                            ALLoadingView.manager.hideLoadingView()
                            self.showAlertWith(title: "Error", message: "An error happened trying to fetch Courses")
                        }
                        else{
                            self.arrayOfCourses = array
                            ALLoadingView.manager.hideLoadingView()
                            DispatchQueue.main.async {
                                self.collectionview.reloadData()
                            }
                        }
                    })
                })
            }
            else{
                
                if(result != 200){
                    ALLoadingView.manager.hideLoadingView()
                    self.showAlertWith(title: "Error", message: "An error happened trying to fetch Courses")
                }
                else{
                    self.arrayOfCourses = array
                    ALLoadingView.manager.hideLoadingView()
                    DispatchQueue.main.async {
                        self.collectionview.reloadData()
                    }
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = collectionview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CoursesTableViewCell
        
        let name: String? = (arrayOfCourses[indexPath.row] as AnyObject).value(forKey: "name") as? String
        let semester: String? = (arrayOfCourses[indexPath.row] as AnyObject).value(forKey: "semester") as? String
        
        cell.coursesName.text = name
        cell.semesterLabel.text = semester
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var courseId: Int? = (arrayOfCourses[indexPath.row] as AnyObject).value(forKey: "id") as? Int
    
        arrayOfSelectedCourses.append(courseId!)
        
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
            token = defaults.object(forKey: "token") as? String
        }
        
        dbConnector.createUser(token: token!, studentObject: studentObject) { (result, id) in
            
            if(result == 401){
                self.dbConnector.createToken(completion: { (token) in
                    
                    self.dbConnector.createUser(token: token, studentObject: self.studentObject, completion: { (result, id) in
                        
                        if(result != 200){
                            
                            ALLoadingView.manager.hideLoadingView()
                            
                            self.showAlertWith(title: "Error", message: "An error happened")
                        }
                        else{
                            
                            self.postCourseToStudent(studentIdParam: id, completion: { (result) in
                                
                                if(result == false){
                                    // if error
                                }
                                else{
                                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                                    self.present(loginViewController, animated: true, completion: nil)
                                }
                            })
                        }
                        
                    })
                })
            }
            else{
                if(result != 200){
                    
                    ALLoadingView.manager.hideLoadingView()
                    
                    self.showAlertWith(title: "Error", message: "An error happened")
                }
                else{
                    
                    ALLoadingView.manager.hideLoadingView()
                    
                    self.postCourseToStudent(studentIdParam: id, completion: { (result) in
                        
                        if(result == false){
                            // if error
                        }
                        else{
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                            self.present(loginViewController, animated: true, completion: nil)
                        }
                    })
                }
            }
        }
    }
    
    func postCourseToStudent(studentIdParam:Int, completion: @escaping (_ result:Bool) -> Void){
        
        var token:String?
        
        if(defaults.object(forKey: "token") == nil){
            
            token = "dummytoken"
        }
        else {
            token = defaults.object(forKey: "token") as? String
        }
        
        let studentId = studentIdParam
        defaults.set(studentId, forKey: "studentId")

        for course in arrayOfSelectedCourses {
            
            dbConnector.postCourseToStudent(token: token!, studentId: studentId, courseId: course, completion: { (result) in
                
                if(result == 401){
                    
                    self.dbConnector.createToken(completion: { (token) in
                        
                        self.dbConnector.postCourseToStudent(token: token, studentId: studentId, courseId: course, completion: { (result) in
                            
                            if(result != 200){
                                self.showAlertWith(title: "Error", message: "An error happened trying to create user courses")
                                completion(false)
                                return
                            }
                            else{
                                // do nothing
                            }
                        })
                        
                    })
                    
                }
                else{
                    if(result != 200){
                        self.showAlertWith(title: "Error", message: "An error happened trying to create user courses")
                        completion(false)
                        return
                    }
                    else{
                        // do nothing
                    }
                }
            })
        }
        
        completion(true)
        
    }
    
}
