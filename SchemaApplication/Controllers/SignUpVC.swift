//
//  SignUpViewController.swift
//  SchemaApplication
//
//  Created by Kenni Mose on 16/11/2017.
//  Copyright © 2017 kenni. All rights reserved.
//  Commit

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var mailTextfield: UITextField!
    @IBOutlet weak var phoneTextfield: UITextField!
    
    @IBOutlet weak var okButton: UIButton!
    var studentObject:NSMutableDictionary = NSMutableDictionary()
    
    var invalidInput = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        okButton.layer.cornerRadius = 20
        
        usernameTextfield.delegate = self
        passwordTextfield.delegate = self
        mailTextfield.delegate = self
        
        hideKeyboardWhenTappedAround()
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
            studentObject.setValue(usernameTextfield.text!, forKey: "name")
            studentObject.setValue(passwordTextfield.text!, forKey: "password")
            studentObject.setValue(mailTextfield.text!, forKey: "email")
            studentObject.setValue(phoneTextfield.text!, forKey: "phone")
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ChooseDepartmentViewController") as! ChooseDepartmentViewController
            
            vc.studentObject = self.studentObject
            
            self.present(vc, animated: true, completion: nil)
            
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
        self.dismiss(animated: true, completion: nil)
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
