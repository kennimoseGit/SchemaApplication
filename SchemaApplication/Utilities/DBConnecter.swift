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
                
                guard let data = data, let _:URLResponse = response, error == nil else {
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
    func getDepartments(){
        
    }
    
    // get courses from specific department
    func getCourses(){
        
    }
    
    // create a user in database
    func createUser(token:String, studentObject:NSMutableDictionary, completion: @escaping (_ status:Int) -> Void){
        
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
                completion(401)
                return
            }
            
            if(error != nil){
                completion(400)
                return
            }
            else{
                
                guard let data = data, let _:URLResponse = response, error == nil else {
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
    func getScheme(){
        
    }
    
 
}
