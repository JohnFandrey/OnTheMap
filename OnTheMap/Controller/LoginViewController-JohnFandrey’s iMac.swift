//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by JohnFandrey on 5/14/18.
//  Copyright © 2018 JohnFandrey. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {

   
  
    @IBOutlet weak var passwordTextField: UITextField!          // Create an outlet for the passwordTextField.
    @IBOutlet weak var usernameTextField: UITextField!          // Create an outlet for the usernameTextField.
    
    var sessionID: String? = nil                                // Initialize an optional value to store the session ID.
    var username: String? = nil                                   // Initialize a string to store the username input by the user.
    var password: String? = nil                                   // Initialize a string to store the password input by the user.
    
    // Need to add activity view to LoginViewController.
    // Need to ensure that after a user logs out that the username and password are set to nil.  
    @IBAction func loginToUdacity(_ sender: Any) {              // Declare a function called when a user presses the 'login' button.
        if let username = usernameTextField.text, let password = passwordTextField.text {
            ParseClient.sharedInstance().userID = self.usernameTextField.text! // Check to see that the user has entered a username and password.
            ParseClient.sharedInstance().obtainSessionID(username, password){ (data: AnyObject?, error: String?) in   // Call the function obtainSessionID using the sharedInstance function.  Use a trailing closure to define the completion handler with two parameters: 'data' of type AnyObject? and 'error' of type String.
                if error != nil {           // If error is not equal to nil then update the loginInfoTextField with the error.
                    let errorText: String = error!
                    DispatchQueue.main.async  // Perform updates on the main queue.
                        {
                            ParseClient.sharedInstance().displayError(errorText, self)
                        }
                    return
                } else {
                    if let sessionData = data as! [String:[String:Any]]? {  // Check that the sessionData can be set equal to a Dictionary of type [String:[String:Any]].
                        let sessionDictionary = sessionData["session"] as! [String:String]  // Set a dictionary of type [String:String] equal to sessionData["session"].
                        self.sessionID = sessionDictionary["id"]         // Set the sessionID equal to sessionDictionary["id"].
                        ParseClient.sharedInstance().uniqueKey = sessionData["account"]!["key"] as! String
                        ParseClient.sharedInstance().sessionID = self.sessionID!
                        ParseClient.sharedInstance().getStudentData() { data, error in
                            DispatchQueue.main.async {
                                ParseClient.sharedInstance().getStudentData(){ data, error in
                                    if error != nil {
                                        DispatchQueue.main.async {
                                            ParseClient.sharedInstance().displayError(error!, self)
                                        }
                                    } else {
                                        if let studentData = data as? [String:[[String:AnyObject]]] {
                                            if let studentArray = studentData[ParseClient.parseParameters["dataKey"]!]{
                                                MyClassmates.sharedInstance().initializeClassmates(dictionary: studentArray)
                                                MyClassmates.sharedInstance().initializeClassmatesAnnotations(array: MyClassmates.sharedInstance().myClassmates)
                                                let tabView = (self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController)
                                                // I found example code for instantiating a ViewController at https://stackoverflow.com/questions/26306557/how-can-i-present-a-uitabbarcontroller-in-swift?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa in a post by Mick MacCallum dated October 10, 2014.  
                                                print(MyClassmates.sharedInstance().myClassmates)
                                                DispatchQueue.main.async {
                                                    self.present(tabView!, animated: true, completion: nil)
                                                }
                                            } else {
                                                ParseClient.sharedInstance().displayError("The data retrieved from the Udacity server was not able to be stored in an array as expected.  Please contact Udacity and the app developer to report this issue.", self)
                                            }
                                        } else {
                                            ParseClient.sharedInstance().displayError("The app was unable to store the data retrieved from the server in the expected dictionary format. Please contact the developer or Udacity to report this problem.",  self)
                                        }
                                    }
                                }
                            }
                        }
                    }
            }
        }
        } else {
            DispatchQueue.main.async {
               ParseClient.sharedInstance().displayError("Please enter your username and password.", self)
            }
        }
    }
    
}

