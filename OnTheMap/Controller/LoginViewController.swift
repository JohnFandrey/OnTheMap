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

    @IBOutlet weak var activityView: UIActivityIndicatorView!   // Create an outlet for the loginInfoTextField.
    @IBOutlet weak var passwordTextField: UITextField!          // Create an outlet for the passwordTextField.
    @IBOutlet weak var usernameTextField: UITextField!          // Create an outlet for the usernameTextField.
    
    var sessionID: String? = nil                                // Initialize an optional value to store the session ID.
    
    
    override func viewDidLoad() {
        activityView.isHidden = true                            // Set the activity view to hidden.
    }
    
    @IBAction func loginToUdacity(_ sender: Any) {              // Declare a function called when a user presses the 'login' button.
        if usernameTextField.text != "" && passwordTextField.text != "" {  // Check to see that the user has entered a username and password.
            revealActivityView(start: true)
            getSessionID()
        } else {
            DispatchQueue.main.async {
               ParseClient.sharedInstance().displayError("Please enter your username and password.", self) // Display an error with a message for the user to enter their name and password.
               self.revealActivityView(start: false)
            }
        }
    }
    
    func revealActivityView(start: Bool){
        // This function controls whether the activity view is visible and whether or not it is spinning.
        if start {
            activityView.isHidden = false
            activityView.startAnimating()
        } else {
            activityView.isHidden = true
            activityView.stopAnimating()
        }
    }
    
    func getUserLocationData(){
        // This funciton calls the 'ParseClient.sharedInstance().getUserLocation' function with the appropriate completion handler.
        // The purpose of this function is to get the objectID for the user's previous post.  This is done so that the user's previous post can be overwritten.  This prevents new posts from being created each time the user updates their location.
        ParseClient.sharedInstance().getUserLocation(){data, error in
            if error != nil {
                DispatchQueue.main.async {
                    ParseClient.sharedInstance().displayError(error!, self)
                    self.activityView.stopAnimating()
                }
            }
            if let myData = data as? [String:[[String:AnyObject]]] {  // If the user has more than one previous post then the data will need to be parsed as an array of dictionaries.
                    if let myResults = myData["results"] {
                            if let myObjectID = myResults[0]["objectId"] {
                                ParseClient.sharedInstance().objectID = (myObjectID as? String)!
                                ParseClient.sharedInstance().previousPost = true
                            }
                    }
            } else if let myData = data as? [String:[String:AnyObject]] { // If the user only has one previous post then the data will need to be parsed as a single dictionary.
                if let myResults = myData["results"] {
                    if let myObjectID = myResults["objectID"] {
                    ParseClient.sharedInstance().objectID = (myObjectID as? String)!
                    ParseClient.sharedInstance().previousPost = true
                    }
                }
            }
            self.getStudentData()
        }
    }
    
    func getStudentData(){
        // The function call below calls the function to populate the classmate data arrays.
        ParseClient.sharedInstance().getStudentData() { data, error in
            if error != nil {
                DispatchQueue.main.async {
                    ParseClient.sharedInstance().displayError(error!, self)
                    self.revealActivityView(start: false)
                }
            } else {
                if let studentData = data as? [String:[[String:AnyObject]]] {
                    if let studentArray = studentData[ParseClient.parseParameters["dataKey"]!]{
                        MyClassmates.sharedInstance().initializeClassmates(dictionary: studentArray)
                        MyClassmates.sharedInstance().initializeClassmatesAnnotations(array: MyClassmates.sharedInstance().myClassmates)
                        let tabView = (self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController)
                        // I found example code for instantiating a ViewController at https://stackoverflow.com/questions/26306557/how-can-i-present-a-uitabbarcontroller-in-swift?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa in a post by Mick MacCallum dated October 10, 2014.
                        DispatchQueue.main.async {
                            self.revealActivityView(start: false)
                            self.present(tabView!, animated: true, completion: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            ParseClient.sharedInstance().displayError("The data retrieved from the Udacity server was not able to be stored in an array as expected.  Please contact Udacity and the app developer to report this issue.", self)
                            self.revealActivityView(start: false)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        ParseClient.sharedInstance().displayError("The app was unable to store the data retrieved from the server in the expected dictionary format. Please contact the developer or Udacity to report this problem.",  self)
                        self.revealActivityView(start: false)
                    }
                }
            }
        }
    }
    
    func getSessionID(){
        //This function authenticates the user and obtains the user's unique key.  
        ParseClient.sharedInstance().obtainSessionID(usernameTextField.text!, passwordTextField.text!){ (data: AnyObject?, error: String?) in
            if error != nil {
                let errorText: String = error!
                DispatchQueue.main.async  {
                    ParseClient.sharedInstance().displayError(errorText, self)
                    self.revealActivityView(start: false)
                }
                return
            } else {
                if let sessionData = data as! [String:[String:Any]]? {  // Check that the sessionData can be set equal to a Dictionary of type [String:[String:Any]].
                    let sessionDictionary = sessionData["session"] as! [String:String]  // Set a dictionary of type [String:String] equal to sessionData["session"].
                    self.sessionID = sessionDictionary["id"]         // Set the sessionID equal to sessionDictionary["id"].
                    ParseClient.sharedInstance().uniqueKey = sessionData["account"]!["key"] as! String
                    self.getUserLocationData()
                    ParseClient.sharedInstance().sessionID = self.sessionID!
                    }
                }
            }
        }

}

