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
    
    let dbConnector = DBConnecter()
    
    var arrayOfSchedule = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let value = UIInterfaceOrientation.landscapeLeft.rawValue
        //UIDevice.current.setValue(value, forKey: "orientation")
        
        getScheduleForStudent()
    }
    
    /*private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeLeft
    }
    private func shouldAutorotate() -> Bool {
        return true
    }*/
    
    func getScheduleForStudent(){
        
        ALLoadingView.manager.showLoadingView(ofType: .basic)
        
        var token:String?
        
        if(defaults.object(forKey: "token") == nil){
            
            token = "dummytoken"
        }
        else {
            token = defaults.object(forKey: "token") as? String
        }
        
        let studentId: Int? = defaults.object(forKey: "studentId") as? Int
        
        dbConnector.getScheme(token: token!, studentId: studentId!) { (result, array) in
            
            if(result == 401){
                
                self.dbConnector.createToken(completion: { (token) in
                    
                    self.dbConnector.getScheme(token: token, studentId: studentId!, completion: { (result, array) in
                        
                        if(result != 200){
                            ALLoadingView.manager.hideLoadingView()
                            self.showAlertWith(title: "Error", message: "An error happened trying to fetch Courses")
                        }
                        else{
                            self.arrayOfSchedule = array
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
                    self.arrayOfSchedule = array
                    ALLoadingView.manager.hideLoadingView()
                    DispatchQueue.main.async {
                        self.collectionview.reloadData()
                    }
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfSchedule.count
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SchemaCollectionViewCell
        
        var name:String? = ""
        var timeslot:String? = ""
        var teacher:String? = ""
        var weekday:String? = ""
        var classroom:String? = ""
        var ects:Int? = 0
        var type:String? = ""
        
        
        name = (arrayOfSchedule[indexPath.row] as AnyObject).value(forKey: "name") as? String
        if(name == nil){
            name = ""
        }
        
        timeslot = (arrayOfSchedule[indexPath.row] as AnyObject).value(forKey: "timeslot") as? String
        if(timeslot == nil){
            timeslot = ""
        }
        
        teacher = (arrayOfSchedule[indexPath.row] as AnyObject).value(forKey: "teacher_name") as? String
        if(teacher == nil){
            teacher = ""
        }
        
        weekday = (arrayOfSchedule[indexPath.row] as AnyObject).value(forKey: "weekday") as? String
        if(weekday == nil){
            weekday = ""
        }
        classroom = (arrayOfSchedule[indexPath.row] as AnyObject).value(forKey: "classroom") as? String
        if(classroom == nil){
            classroom = ""
        }
        ects = (arrayOfSchedule[indexPath.row] as AnyObject).value(forKey: "ects") as? Int
        if(ects == nil){
            ects = 0
        }
        type = (arrayOfSchedule[indexPath.row] as AnyObject).value(forKey: "type") as? String
        if(type == nil){
            type = ""
        }
        
        cell.weekday.text = "\(weekday!)"
        cell.titleTextLabel.text = "Course:  \(name!)"
        cell.secondTextLabel.text = "Time:  \(timeslot!)"
        cell.thirdTextLabel.text = "Teacher:  \(teacher!)"
        cell.ects.text = "Ects points:  \(ects!)"
        cell.type.text = "Type:  \(type!)"
        cell.classroom.text = "Classroom:  \(classroom!)"
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.invalidateLayout()
        
        return CGSize(width: (self.view.frame.width), height: (self.view.frame.width)/2 + (50))
    }
    
    @objc func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

