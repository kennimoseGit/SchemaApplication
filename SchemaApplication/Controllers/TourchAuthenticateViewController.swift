//
//  TourchAuthenticateViewController.swift
//  schematest
//
//  Created by Kenni Mose on 20/11/2017.
//  Copyright © 2017 kenni. All rights reserved.
//

import UIKit
import LocalAuthentication

class TourchAuthenticateViewController: UIViewController {

    var errorPointer:NSError?
    let reason = NSLocalizedString(" ", comment: "authReason")
    
    @IBOutlet weak var retryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        touchIDAuthentication()
    }
    
    func touchIDAuthentication() {
        let context = LAContext() //1
        
        //2
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &errorPointer) {
            //3
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        //Authentication was successful
                        print("authenticated successfully")
                        
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SchemeVC") as! SchemeVC
                        self.present(newViewController, animated: true, completion: nil)
                        
                    }
                    
                }else {
                    DispatchQueue.main.async {
                        //Authentication failed. Show alert indicating what error occurred
                        self.displayErrorMessage(error: error as! LAError )
                    }
                    
                }
            })
        }else {
            //Touch ID is not available on Device, use password.
            self.showAlertWith(title: "Error", message: (errorPointer?.localizedDescription)!)
        }
    }
    
    
    func displayErrorMessage(error:LAError) {
        var message = ""
        switch error.code {
        case LAError.authenticationFailed:
            message = "Authentication was not successful because the user failed to provide valid credentials."
            break
        case LAError.userCancel:
            message = "Authentication was canceled by the user"
            break
        case LAError.userFallback:
            message = "Authentication was canceled because the user tapped the fallback button"
            break
        case LAError.biometryNotEnrolled:
            message = "Authentication could not start because Touch ID has no enrolled fingers."
        case LAError.passcodeNotSet:
            message = "Passcode is not set on the device."
            break
        case LAError.systemCancel:
            message = "Authentication was canceled by system"
            break
        default:
            message = error.localizedDescription
        }
        
        self.showAlertWith(title: "Authentication Failed", message: message)
    }


    @IBAction func retryButtonAction(_ sender: Any) {
        self.touchIDAuthentication()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
}



extension UIViewController {
    func showAlertWith(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(actionButton)
        self.present(alertController, animated: true, completion: nil)
    }

    
    
}
