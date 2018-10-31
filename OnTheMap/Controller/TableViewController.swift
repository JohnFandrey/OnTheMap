//
//  TableViewController.swift
//  OnTheMap
//
//  Created by JohnFandrey on 6/14/18.
//  Copyright © 2018 JohnFandrey. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class TableViewController: UITableViewController {
    
    @IBOutlet var locationTableView: UITableView!       // Create an outlet for the table View.
    var previousPost: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var annotations = [MKPointAnnotation]()     // Create an array of type MKPointAnnotation.
        annotations = MyClassmates.sharedInstance().myClassmatesAnnotations
    }
    
    @IBAction func refreshResults(_ sender: Any) {
        ParseClient.sharedInstance().getStudentData(){ data, error in  // Call the getStudentData function with the appropriate completion handler.
            if error != nil {
                DispatchQueue.main.async { // Display an error message on the main queue.
                    ParseClient.sharedInstance().displayError(error!, self)
                }
            } else {
                if let studentData = data as? [String:[[String:AnyObject]]] {  // Parse the date retrieved from the Udacity server.
                    if let studentArray = studentData[ParseClient.parseParameters["dataKey"]!]{
                        MyClassmates.sharedInstance().initializeClassmates(dictionary: studentArray)
                        MyClassmates.sharedInstance().initializeClassmatesAnnotations(array: MyClassmates.sharedInstance().myClassmates)
                    } else {
                        ParseClient.sharedInstance().displayError("The data retrieved from the Udacity server was not able to be stored in an array as expected.  Please contact Udacity and the app developer to report this issue.", self)
                    }
                } else {
                    ParseClient.sharedInstance().displayError("The app was unable to store the data retrieved from the server in the expected dictionary format. Please contact the developer or Udacity to report this problem.",  self)
                }
            }
            DispatchQueue.main.async {
                self.locationTableView.reloadData() // reload the data in the table.
        }
        }
    }
    
    @IBAction func logoutUdacity(_ sender: Any) {
        ParseClient.sharedInstance().logOutUdacity { data, error in
            let loginView = (self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController"))
            // I found example code for instantiating a ViewController at https://stackoverflow.com/questions/26306557/how-can-i-present-a-uitabbarcontroller-in-swift?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa in a post by Mick MacCallum dated October 10, 2014.
            if error != nil {
                ParseClient.sharedInstance().displayError(error!, self)
            }
            if let myData = data as? [String:[String:AnyObject]] {
                let sessionData = myData["session"]
                if let expiration = sessionData!["expiration"] {
                    DispatchQueue.main.async {
                        self.present(loginView!, animated: true, completion: nil)
                    }
                } else {
                        ParseClient.sharedInstance().displayError("We were unable to log you out.  Please try again.", self)
                    }
            } else {
                ParseClient.sharedInstance().displayError("We were unable to log you out because we could not retrieve and store data from the Udacity server.", self)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyClassmates.sharedInstance().myClassmatesAnnotations.count      // sets the number of rows to the number of items in the myClassmates array.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationCell", for: indexPath) // create a constant 'cell' and set it equal to the value returned by the function 'tableView.dequeReusableCell(withIdentifier: "StudentLocationCell", for: indexPath).
        let cellAnnotation = MyClassmates.sharedInstance().myClassmatesAnnotations[indexPath.row]  // create a constant 'cellAnnotation' and set it equal to an annotation in the myClassmatesAnnotations array using the row number of the 'indexPath' to access the correct meme.
        cell.textLabel?.textAlignment = NSTextAlignment.center  // Set the alignment of the cell textLabel to center.
        cell.textLabel?.text = cellAnnotation.title // Sets the content of the 'cell' textLabel.
        return cell  // returns the cell.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         // reveal the tabBar.
        refreshResults(self)  // reloads the tableView data.  This function is called to ensure that once a user navigates back to the tableView, the most recent data is show in the table.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {  // This function calls the SentMemeDetailViewController and displays the meme that is represented by the selected row.
        let app = UIApplication.shared
        if let toOpen = MyClassmates.sharedInstance().myClassmatesAnnotations[indexPath.row].subtitle {
            app.openURL(URL(string: toOpen)!)
        }
    }
    
    func overwriteLocation(){
        let addLocationView = (self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController"))
        show(addLocationView!, sender: self)
    }
    
    func displayError(_ info: String, _ sender: UIViewController, previousPost: Bool) {         // Code for displaying an alert notification was obtained at https://www.ioscreator.com/tutorials/display-alert-ios-tutorial-ios10.  The tutorial for displaying this type of alert was posted by Arthur Knopper on January 10, 2017.
        if previousPost{
            let alertController = UIAlertController(title: "Previously Posted Location", message: info, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: nil))
            let addLocation = UIAlertAction(title:"Overwrite", style: UIAlertActionStyle.default, handler: {action in self.overwriteLocation()})
            alertController.addAction(addLocation)
            sender.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func addLocation(_ sender: Any) {
        // Checks for previous location and displays a message if the user previously posted a location.  
        if ParseClient.sharedInstance().objectID != "" {
            displayError("You have previously posted a location.  Would you to like to cancel the operation and keep your previously posted location or would you like to overwrite your previously posted location?", self, previousPost: true)
        } else {
            overwriteLocation() // Call the 'overwriteLocation' function if there is no previous post.  
        }
    }
    

    
    
}
