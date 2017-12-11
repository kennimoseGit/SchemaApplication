//
//  SchemaApplicationRequestTests.swift
//  SchemaApplicationTests
//
//  Created by Mads Rasmussen on 03/12/2017.
//  Copyright © 2017 kenni. All rights reserved.
//

import XCTest
@testable import SchemaApplication

//Run all tests by pressing button on line 13
class SchemaApplicationRequestTests: XCTestCase, URLSessionDelegate {
    
    //Testing the POST create token - status code 200 is expected
    func testAPIReturnsHTTPStatusCode200WhenCreatingToken() {
        let url:URL = URL(string: "https://scheduleapplication.herokuapp.com/oauth/token")!
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 20
        urlconfig.timeoutIntervalForResource = 20
        
        let session = Foundation.URLSession(configuration: urlconfig, delegate: self, delegateQueue: OperationQueue.main)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json: [String: String] = ["grant_type":grant_type!,
                                      "client_secret":client_secret!,
                                      "username":username!,
                                      "password":password!]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    do{
                        let jsonData = (try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject])!
                        
                        print(jsonData.description)
                        
                        let tokenFromRequest = jsonData["token"] as? String
                        defaults.set(tokenFromRequest, forKey: "token")
                        
                        //Promise is fulfilled if it returns statuscode 200
                        promise.fulfill()
                    }
                    catch _ as NSError {
                        // An error occurred while trying to convert the data into a Swift dictionary.
                        print("an error occured")
                    }
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        //waitForExceptaations is added to get the return
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //Testing the GET department - status code 200 is expected
    func testAPIReturnsHTTPStatusCode200WhenGettingTheDepartments() {
        var token:String?
        
        //Getting the token from userdefault
        if(defaults.object(forKey: "token") == nil){
            testAPIReturnsHTTPStatusCode200WhenCreatingToken()
        } else {
            token = defaults.object(forKey: "token") as? String
        }
        
        var arrayOfDepartments = NSArray()
        
        let url:URL = URL(string: "https://scheduleapplication.herokuapp.com/departments")!
        
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 20
        urlconfig.timeoutIntervalForResource = 20
        
        let session = Foundation.URLSession(configuration: urlconfig, delegate: self, delegateQueue: OperationQueue.main)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(token!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    do{
                        let jsonData = (try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSArray)
                        
                        arrayOfDepartments = jsonData!
                        
                        print(arrayOfDepartments.description)
                        
                        promise.fulfill()
                    }
                    catch _ as NSError {
                        // An error occurred while trying to convert the data into a Swift dictionary.
                        print("an error occured")
                    }
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        //waitForExceptaations is added to get the return
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //Testing the GET department, without a correct token - 401 is expected
    func testAPIReturnsHTTPStatusCode401WhenNotGettingTheDepartments() {
        let url:URL = URL(string: "https://scheduleapplication.herokuapp.com/departments")!
        
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 20
        urlconfig.timeoutIntervalForResource = 20
        
        let session = Foundation.URLSession(configuration: urlconfig, delegate: self, delegateQueue: OperationQueue.main)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("empty", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let promise = expectation(description: "Status code: 401")
        
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 401 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        //waitForExceptaations is added to get the return
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //Testing the GET courses - is expected to be above 0
    func testAPIReturnsJSONObjectGettingTheCourses() {
        let departmentId = 7 //Department: KEA Lygten 37
        
        var token:String?
        
        //Getting the token from userdefault
        if(defaults.object(forKey: "token") == nil){
            testAPIReturnsHTTPStatusCode200WhenCreatingToken()
        } else {
            token = defaults.object(forKey: "token") as? String
        }
        
        var arrayOfCourses = NSArray()
        
        let url:URL = URL(string: "https://scheduleapplication.herokuapp.com/courses/\(departmentId)")!
        
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 20
        urlconfig.timeoutIntervalForResource = 20
        
        let session = Foundation.URLSession(configuration: urlconfig, delegate: self, delegateQueue: OperationQueue.main)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(token!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    do{
                        let jsonData = (try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSArray)
                        
                        arrayOfCourses = jsonData!
                        
                        print(arrayOfCourses.description)
                        
                        let count = arrayOfCourses.count
                        
                        if count > 0{
                            promise.fulfill()
                        } else {
                            XCTFail()
                        }
                    }
                    catch _ as NSError {
                        // An error occurred while trying to convert the data into a Swift dictionary.
                        print("an error occured")
                    }
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        //waitForExceptaations is added to get the return
        waitForExpectations(timeout: 5, handler: nil)
    }
}
