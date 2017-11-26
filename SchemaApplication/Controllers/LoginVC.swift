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
    
    let dbConnecter = DBConnecter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        self.loginButton.layer.cornerRadius = 20
        self.loginButton.clipsToBounds = true
        
        self.usrnameTextfield.delegate = self;
        self.passwordTextfield.delegate = self;
        
    }


    @IBAction func loginButtonAction(_ sender: Any) {
        
        if(usrnameTextfield.text != "" && passwordTextfield.text != ""){
            
            ALLoadingView.manager.showLoadingView(ofType: .basic)
            
            var token:String?
            
            if(defaults.object(forKey: "token") == nil){
                
                token = "dummytoken"
            }
            else {
                token = defaults.object(forKey: "token") as! String
            }

            dbConnecter.LoginwithUsernameAndPassword(token: token!, email: usrnameTextfield.text!, password: passwordTextfield.text!, completion: { (status) in
            
                print(status)
                
                if(status == 401){
                    self.dbConnecter.createToken(completion: { (token) in
                        
                        self.dbConnecter.LoginwithUsernameAndPassword(token: token, email: self.usrnameTextfield.text!, password: self.passwordTextfield.text!, completion: { (status) in
                            
                            print(status)
                            
                            if(status != 200){
                                ALLoadingView.manager.hideLoadingView()
                                self.errorLabel.text = "Please check if username and password is correct"
                            }
                            else{
                                ALLoadingView.manager.hideLoadingView()
                                
                                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let newViewController = storyBoard.instantiateViewController(withIdentifier: "TourchAuthenticateViewController") as! TourchAuthenticateViewController
                                self.present(newViewController, animated: true, completion: nil)
                            }
                         })
                    })
                }
                else{
                    if(status != 200){
                        ALLoadingView.manager.hideLoadingView()
                        self.errorLabel.text = "Please check if username and password is correct"
                    }
                    else{
                        ALLoadingView.manager.hideLoadingView()
                        
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TourchAuthenticateViewController") as! TourchAuthenticateViewController
                        self.present(newViewController, animated: true, completion: nil)
                    }
                }
            })
        }
        else{
            self.errorLabel.text = "Please fill in username and password"
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

