//
//  SchemaApplicationTests.swift
//  SchemaApplicationTests
//
//  Created by Mads Rasmussen on 19/11/2017.
//  Copyright © 2017 kenni. All rights reserved.
//

import XCTest
@testable import SchemaApplication

//Run all tests by pressing button on line 13
class SchemaApplicationTests: XCTestCase {
    
    let signUpVC: SignUpVC = SignUpVC()
    let textfield: UITextField = UITextField()
    
    //Testing if the textfield have one letter
    func testUsernameTextfieldNotEmpty() {
        
        textfield.text = "A"
        
        let validInput = signUpVC.checkTextfield(textfield: textfield)
        
        XCTAssertTrue(validInput)
    }
    
    //Testing if the textfield is empty
    func testUsernameTextfieldEmpty() {
        
        textfield.text = ""
        
        let invalidInput = signUpVC.checkTextfield(textfield: textfield)
        
        XCTAssertFalse(invalidInput)
    }
    
    //Testing if the textfield has 21 letters
    func testUsernameTextfieldIs21Letters(){
        textfield.text = "abcdefghijklmnopqerst"
        
        let invalidInput = signUpVC.checkTextfield(textfield: textfield)
        
        XCTAssertFalse(invalidInput)
    }
    
    //Testing if the textfield has 20 letters
    func testUsernameTextfieldIs20Letters(){
        textfield.text = "abcdefghijklmnopqers"
        
        let validInput = signUpVC.checkTextfield(textfield: textfield)
        
        XCTAssertTrue(validInput)
    }
    
    //Testing if the syntax is correct - Invalid input
    func testMailSyntaxIsCorrectFail(){
        textfield.text = "abcde"
        
        let invalidInput = signUpVC.isEmailValid(textField: textfield)
        
        XCTAssertFalse(invalidInput)
    }
    
    //Testing if the syntax is correct - Valid input
    func testMailSyntaxIsCorrectApprove(){
        textfield.text = "abcde@abc.dk"
        
        let validInput = signUpVC.isEmailValid(textField: textfield)
        
        XCTAssertTrue(validInput)
    }
}
