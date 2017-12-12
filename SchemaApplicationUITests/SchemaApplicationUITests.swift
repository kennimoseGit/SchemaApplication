//
//  SchemaApplicationUITests.swift
//  SchemaApplicationUITests
//
//  Created by Mads Rasmussen on 19/11/2017.
//  Copyright © 2017 kenni. All rights reserved.
//

import XCTest

//Click line 12 to run the tests
class SchemaApplicationUITests: XCTestCase {
        
    var app: XCUIApplication!
    
    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        
        // Exit if a failure was encountered
        continueAfterFailure = false
        
        app = XCUIApplication()
    }
    
    // MARK: - Tests
    //Test if a user can sign up
    func testSignUpViewController() {
        app.launch()
        
        app.buttons["Sign up"].tap()
        
        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText("mads")
        
        let passwordTextField = app.textFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("password")
        
        let mailTextField = app.textFields["Mail"]
        mailTextField.tap()
        mailTextField.typeText("mads@mads.dk")
        
        app.buttons["Ok"].tap()
    }
}
