//
//  ViewController.swift
//  SchemaApplication
//
//  Created by Kenni Mose on 13/11/2017.
//  Copyright © 2017 kenni. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    // test
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var usrnameTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        self.loginButton.layer.cornerRadius = 15
        self.loginButton.clipsToBounds = true
        
        self.usrnameTextfield.delegate = self;
        self.passwordTextfield.delegate = self;

    }


    @IBAction func loginButtonAction(_ sender: Any) {
        
        if(usrnameTextfield.text != "" && passwordTextfield.text != ""){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "TourchAuthenticateViewController") as! TourchAuthenticateViewController
            self.present(newViewController, animated: true, completion: nil)
        }
        else{
            errorLabel.text = "Please fill in username and password"
        }
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
   
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func usernamefieldDidBegin(_ sender: Any) {
        errorLabel.text = ""
    }
    
    @IBAction func passwordDidBegin(_ sender: Any) {
        errorLabel.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

