//
//  DBConnecter.swift
//  SchemaApplication
//
//  Created by Kenni Mose on 24/11/2017.
//  Copyright © 2017 kenni. All rights reserved.
//

import Foundation

var grant_type:String?
var client_secret:String?
var username:String?
var password:String?

let defaults = UserDefaults.standard

class DBConnecter: NSObject, URLSessionDelegate {
    
    // fetch secret values from file
    func getKeysFromPlist(){
        if let path = Bundle.main.path(forResource: "SecretKeys", ofType: "plist") {
            ////If your plist contain root as Dictionary
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                grant_type = dic["grant_type"] as? String
                client_secret = dic["client_secret"] as? String
                username = dic["username"] as? String
                password = dic["password"] as? String
            }
        }
    }
    
    // used to create a token -> completionhandler returns "" if error, or token if no error
    func createToken(completion: @escaping (_ token:String) -> Void){
        
        let url:URL = URL(string: "https://scheduleapplication.herokuapp.com/oauth/token")!
        
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 20
        urlconfig.timeoutIntervalForResource = 20
        
        let session = Foundation.URLSession(configuration: urlconfig, delegate: self, delegateQueue: OperationQueue.main)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // prepare json data
        let json: [String: String] = ["grant_type":grant_type!,
                                   "client_secret":client_secret!,
                                   "username":username!,
                                   "password":password!]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            if(error != nil){
                completion("")
            }
            else{
                
                guard let data = data, let _:URLResponse = response, error == nil else {
                    print("error")
                    completion("")
                    return
                }
                
                do{
                    let jsonData = (try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject])!
                    
                    let tokenFromRequest = jsonData["token"] as? String
                    defaults.set(tokenFromRequest, forKey: "token")
                    
                    completion(tokenFromRequest!)
                }
                catch _ as NSError {
                    // An error occurred while trying to convert the data into a Swift dictionary.
                    print("an error occured")
                }
            }
        }
        task.resume()
    }
        
    
    // check if values in database matches entered values -> completion returns false if not, true if yes
    func LoginwithUsernameAndPassword(token:String, email:String, password:String, completion: @escaping (_ status:Int) -> Void){
        
        let url:URL = URL(string: "https://scheduleapplication.herokuapp.com/student/login")!
        
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 20
        urlconfig.timeoutIntervalForResource = 20
        
        let session = Foundation.URLSession(configuration: urlconfig, delegate: self, delegateQueue: OperationQueue.main)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // prepare json data
        let json: [String: String] = ["email":email,
                                      "password":password]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            if(response?.getStatusCode() == 401){
                completion(401)
                return
            }
            
            if(response?.getStatusCode() == 500){
                completion(500)
                return
            }
            
            if(error != nil){
                completion(400)
                return
            }
            else{
                
                guard let _ = data, let _:URLResponse = response, error == nil else {
                    print("error")
                    completion(400)
                    return
                }
                
                do{
                    
                    completion(200)
                }
                
            }
        }
        
        task.resume()
        
    }
    
    
    // get departments
    func getDepartments(token:String, completion: @escaping (_ status:Int, _ arrayOfDepartments:NSArray) -> Void){
        
        var arrayOfDepartments = NSArray()
        
        let url:URL = URL(string: "https://scheduleapplication.herokuapp.com/departments")!

        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 20
        urlconfig.timeoutIntervalForResource = 20
        
        let session = Foundation.URLSession(configuration: urlconfig, delegate: self, delegateQueue: OperationQueue.main)

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            if(response?.getStatusCode() == 401){
                completion(401, arrayOfDepartments)
                return
            }
            
            if(error != nil){
                completion(400, arrayOfDepartments)
                return
            }
                
            if(response?.getStatusCode() == 500){
                completion(500, arrayOfDepartments)
                return
            }
                
            else{
                
                guard let data = data, let _:URLResponse = response, error == nil else {
                    print("error")
                    completion(400, arrayOfDepartments)
                    return
                }
                
                do{
                    let jsonData = (try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSArray)
                                        
                    arrayOfDepartments = jsonData!
                    completion(200, arrayOfDepartments)

                }
                catch _ as NSError {
                    // An error occurred while trying to convert the data into a Swift dictionary.
                    print("an error occured")
                }
            }
        }
        task.resume()
        
    }
    
    // get courses from specific department
    func getCourses(token:String, departmentId:Int, completion: @escaping (_ status:Int, _ arrayOfCourses:NSArray) -> Void){
       
        var arrayOfCourses = NSArray()

        let url:URL = URL(string: "https://scheduleapplication.herokuapp.com/courses/\(departmentId)")!
        
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 20
        urlconfig.timeoutIntervalForResource = 20
        
        let session = Foundation.URLSession(configuration: urlconfig, delegate: self, delegateQueue: OperationQueue.main)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            if(response?.getStatusCode() == 401){
                completion(401, arrayOfCourses)
                return
            }
            
            if(error != nil){
                completion(400, arrayOfCourses)
                return
            }
            
            if(response?.getStatusCode() == 500){
                completion(500, arrayOfCourses)
                return
            }
                
            else{
                
                guard let data = data, let _:URLResponse = response, error == nil else {
                    print("error")
                    completion(400, arrayOfCourses)
                    return
                }
                
                do{
                    let jsonData = (try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSArray)
                    
                    print(jsonData)
                    
                    arrayOfCourses = jsonData!
                    completion(200, arrayOfCourses)
                    
                }
                catch _ as NSError {
                    // An error occurred while trying to convert the data into a Swift dictionary.
                    print("an error occured")
                }
            }
        }
        task.resume()
    }
    
    // create a user in database
    func createUser(token:String, studentObject:NSMutableDictionary, completion: @escaping (_ status:Int, _ studentId:Int) -> Void){
        
        let studentId:Int = 0
        
        let url:URL = URL(string: "https://scheduleapplication.herokuapp.com/student/create")!

        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 20
        urlconfig.timeoutIntervalForResource = 20
        
        let session = Foundation.URLSession(configuration: urlconfig, delegate: self, delegateQueue: OperationQueue.main)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // prepare json data
        let json: [String: String] = ["name":studentObject.value(forKey: "name")! as! String,
                                      "email":studentObject.value(forKey: "email")! as! String,
                                      "password":studentObject.value(forKey: "password")! as! String]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            if(response?.getStatusCode() == 401){
                completion(401, studentId)
                return
            }
            
            if(error != nil){
                completion(400, studentId)
                return
            }
                
            if(response?.getStatusCode() == 500){
                completion(500, studentId)
                return
            }
                
            else{
                
                guard let data = data, let _:URLResponse = response, error == nil else {
                    print("error")
                    completion(400, studentId)
                    return
                }
                
                do{
                    let jsonData = (try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject])!

                    let id:Int = jsonData["student_id"] as! Int

                    completion(200, id)
                }
                catch _ as NSError {
                    // An error occurred while trying to convert the data into a Swift dictionary.
                    print("an error occured")
                }
           
            }
        }
        task.resume()
        
    }
    
    
    func postCourseToStudent(token:String, studentId:Int, courseId:Int, completion: @escaping (_ status:Int) -> Void){
        
        let url:URL = URL(string: "https://scheduleapplication.herokuapp.com/course")!

        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 20
        urlconfig.timeoutIntervalForResource = 20
        
        let session = Foundation.URLSession(configuration: urlconfig, delegate: self, delegateQueue: OperationQueue.main)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // prepare json data
        let json: [String: Int] = ["student_id":studentId,
                                      "course_id":courseId]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            if(response?.getStatusCode() == 401){
                completion(401)
                return
            }
            
            if(error != nil){
                completion(400)
                return
            }
            
            if(response?.getStatusCode() == 500){
                completion(500)
                return
            }
                
            else{
                
                guard let _ = data, let _:URLResponse = response, error == nil else {
                    print("error")
                    completion(400)
                    return
                }
                
                do{
                    completion(200)
                }
                
            }
        }
        task.resume()
        
    }
    
    
    
    
    // get scheme for specific user
    func getScheme(token:String, studentId:Int, completion: @escaping (_ status:Int, _ arrayOfSchedules:NSArray) -> Void){
        
        var arrayOfSchedules = NSArray()
        
        let url:URL = URL(string: "https://scheduleapplication.herokuapp.com/schedule/\(studentId)")!

        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 20
        urlconfig.timeoutIntervalForResource = 20
        
        let session = Foundation.URLSession(configuration: urlconfig, delegate: self, delegateQueue: OperationQueue.main)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            if(response?.getStatusCode() == 401){
                completion(401, arrayOfSchedules)
                return
            }
            
            if(error != nil){
                completion(400, arrayOfSchedules)
                return
            }
            
            if(response?.getStatusCode() == 500){
                completion(500, arrayOfSchedules)
                return
            }
                
            else{
                
                guard let data = data, let _:URLResponse = response, error == nil else {
                    print("error")
                    completion(400, arrayOfSchedules)
                    return
                }
                
                do{
                        let jsonData = (try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSArray)
                    
                    print(jsonData)
                    arrayOfSchedules = jsonData!
                    completion(200, arrayOfSchedules)
                }
                catch _ as NSError {
                    // An error occurred while trying to convert the data into a Swift dictionary.
                    print("an error occured")
                }
                
            }
        }
        task.resume()
        
        
    }
    
 
}

