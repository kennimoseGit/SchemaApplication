//
//  Utilities.swift
//  SchemaApplication
//
//  Created by Kenni Mose on 16/11/2017.
//  Copyright © 2017 kenni. All rights reserved.
//


import Foundation
import UIKit

extension UIViewController{
    
    // hide keyboard when tapped anywhere
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension URLResponse {
    
    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
}
