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
    }
    
    //Test if a user can sign in
    func testSignInViewController(){
        app.launch()
        
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("Test")
        
        let passwordTextField = app.textFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("Test")
        
        app.buttons["Login"].tap()
    }
}
