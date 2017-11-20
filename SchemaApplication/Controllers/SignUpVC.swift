//
//  SignUpViewController.swift
//  SchemaApplication
//
//  Created by Kenni Mose on 16/11/2017.
//  Copyright © 2017 kenni. All rights reserved.
//  

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var mailTextfield: UITextField!
    @IBOutlet weak var phoneTextfield: UITextField!
    
    let studentObject:NSMutableDictionary = NSMutableDictionary()
    
    var invalidInput = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextfield.delegate = self
        passwordTextfield.delegate = self
        mailTextfield.delegate = self
    }
    
    @IBAction func okAction(_ sender: Any) {
        invalidInput = false
        
        //Check the textfields
        invalidInput = checkTextfield(textfield: usernameTextfield)
        invalidInput = checkTextfield(textfield: passwordTextfield)
        invalidInput = checkTextfield(textfield: mailTextfield)
        
        //Loops the textfields through and resign them all
        for textField in self.view.subviews where textField is UITextField {
            textField.resignFirstResponder()
        }
        
        //Check if the the input is ok
        if invalidInput == false{
            //Create the JSON object
            studentObject.setValue(usernameTextfield.text!, forKey: "username")
            studentObject.setValue(passwordTextfield.text!, forKey: "password")
            studentObject.setValue(mailTextfield.text!, forKey: "mail")
            studentObject.setValue(phoneTextfield.text!, forKey: "phone")
            
            //TODO safe in database
        }
    }
    
    func checkTextfield(textfield: UITextField) -> Bool{
        if textfield.text == "" || textfield.text == "This is required"{
            setRequiredField(textField: textfield)
            return true
        }
        return false
    }
    
    func setRequiredField(textField: UITextField){
        textField.text = "This is required"
        textField.textColor = UIColor.red
    }
    
    //Go back
    @IBAction func backAction(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SignUpVC : UITextFieldDelegate {
    //This method get called when textfields begin editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == usernameTextfield{
            usernameTextfield.text = ""
            usernameTextfield.textColor = UIColor.black
        }
        
        if textField == passwordTextfield{
            passwordTextfield.text = ""
            passwordTextfield.textColor = UIColor.black
        }
        
        if textField == mailTextfield{
            mailTextfield.text = ""
            mailTextfield.textColor = UIColor.black
        }
    }
}
