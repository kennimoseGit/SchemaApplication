//
//  SchemaApplicationTests.swift
//  SchemaApplicationTests
//
//  Created by Mads Rasmussen on 19/11/2017.
//  Copyright © 2017 kenni. All rights reserved.
//

import XCTest
@testable import SchemaApplication

// hey

class SchemaApplicationTests: XCTestCase {
    
    let signUpVC: SignUpVC = SignUpVC()
    let textfield: UITextField = UITextField()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }
    
    func testUsernameTextfieldNotEmpty() {
        
        textfield.text = "Test"
        
        let isInputValid = signUpVC.checkTextfield(textfield: textfield)
        
        if isInputValid == true{
            XCTFail()
        }
    }
    
    func testUsernameTextfieldEmpty() {
        
        textfield.text = ""
        
        let isInputValid = signUpVC.checkTextfield(textfield: textfield)
        
        if isInputValid == false{
            XCTFail()
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
