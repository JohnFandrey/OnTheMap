//
//  MapViewController.swift
//  OnTheMap
//
//  Created by JohnFandrey on 6/6/18.
//  Copyright © 2018 JohnFandrey. All rights reserved.
//

import Foundation
import MapKit
import UIKit

    // I found looked at a tutorial found at https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started to initially get the mapView set up.  The original post was by Ray Wenderlich and was updated by Audrey Tam on June 27, 2017. I also used the Udacity PinSample app to find the appropriate functions for the MKMapViewDelegate.

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBAction func addLocation(_ sender: Any) {
        if ParseClient.sharedInstance().objectID != "" {
        displayError("You have previously posted a location.  Would you to like to cancel the operation and keep your previously posted location or would you like to overwrite your previously posted location?", self, previousPost: true)
        } else {
        overwriteLocation()
        }
    }
    var previousPost: Bool = false
    
    // I found the code for setting up the viewDidLoad function as seen below at https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started.  The original post was by Ray Wenderlich and was updated by Audrey Tam on June 27, 2017.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        var annotations = [MKPointAnnotation]()
        annotations = MyClassmates.sharedInstance().myClassmatesAnnotations
        let initialLocation = CLLocation(latitude: 41.2774647, longitude: -89.3286386)
        centerMapOnLocation(location: initialLocation)
        self.mapView.addAnnotations(annotations)
        mapView.delegate = self
        activityView.isHidden = true
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray // I found an example for setting the UIActivityIndicatorViewStyle at http://www.thomashanning.com/uiactivityindicatorview/ in a post by Thomas Hanning dated February 8, 2016.
        
        ParseClient.sharedInstance().getUserData(){data, error in
            // This function obtains public user data and is used to populate the "first_name" and "last_name" of the user.
            if let myData = data as? [String:[String:AnyObject]] {
                let userData = myData["user"]
                ParseClient.sharedInstance().myFirstName = (userData?["first_name"] as? String)!
                ParseClient.sharedInstance().myLastName = (userData?["last_name"] as? String)!
            } else if let myData = data as? [String:[[String:AnyObject]]] {
                let userData = myData["user"]
                ParseClient.sharedInstance().myFirstName = (userData![0]["first_name"] as? String)!
                ParseClient.sharedInstance().myLastName = (userData![0]["last_name"] as? String)!
            } else {
                self.displayError("We were unable to obtain your user data.  Please contact Udacity and the app developer to report this issue.", self, previousPost: false)
            }
        }
    }
   
    // I found the code for setting the initial map location as seen below at https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started.  The original post was by Ray Wenderlich and was updated by Audrey Tam on June 27, 2017.
    
    let regionRadius: CLLocationDistance = 5000000  // Sets a region radius
    
    func centerMapOnLocation(location: CLLocation) {
        // I found the code for setting the initial map location as seen below at https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started.  The original post was by Ray Wenderlich and was updated by Audrey Tam on June 27, 2017.
        // This function sets a coordinateRegion and sets Region for the mapView.
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.delegate = self
        mapView.setRegion(coordinateRegion, animated: true)
        }
    
// I used the PinSample App and the Ray Wenderlich tutorial updated by Audrey Tam to get the delegate function below to work properly.  I was having issues with getting pins to be displayed instead of balloons or markers.
  
    
    func mapView(_: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // I used the PinSample App and the Ray Wenderlich tutorial updated by Audrey Tam to get the delegate function below to work properly.  I was having issues with getting pins to be displayed instead of balloons or markers.
        let identifier = "marker"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }


// This delegate method is implemented to respond to taps. It opens the system browser
// to the URL specified in the annotationViews subtitle property.
func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    if control == view.rightCalloutAccessoryView {
        let app = UIApplication.shared
        if let toOpen = view.annotation?.subtitle! {
            app.openURL(URL(string: toOpen)!)
        }
    }
}
    
    @IBAction func logOut(_ sender: Any) {
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
    
    @IBAction func refreshLocations(_ sender: Any) {
        // This function refreshes the map view to add any recently added locations.
        activityView.isHidden = false
        activityView.startAnimating()
        ParseClient.sharedInstance().getStudentData(){ data, error in
            if error != nil {
                DispatchQueue.main.async {
                    ParseClient.sharedInstance().displayError(error!, self)
                    self.activityView.stopAnimating()
                }
            } else {
                if let studentData = data as? [String:[[String:AnyObject]]] {
                    if let studentArray = studentData[ParseClient.parseParameters["dataKey"]!]{
                        MyClassmates.sharedInstance().initializeClassmates(dictionary: studentArray)
                        MyClassmates.sharedInstance().initializeClassmatesAnnotations(array: MyClassmates.sharedInstance().myClassmates)
                        var annotations = [MKPointAnnotation]()
                        annotations = MyClassmates.sharedInstance().myClassmatesAnnotations
                        DispatchQueue.main.async {
                            self.mapView.addAnnotations(annotations)
                            self.activityView.stopAnimating()
                            self.activityView.isHidden = true
                        }
                    } else {
                        ParseClient.sharedInstance().displayError("The student data retrieved from the Udacity server was not able to be stored in an array as expected.  Please contact Udacity and the app developer to report this issue.", self)
                         self.activityView.stopAnimating()
                        }
                } else {
                    ParseClient.sharedInstance().displayError("The app was unable to store the student data retrieved from the server in the expected dictionary format. Please contact the developer or Udacity to report this problem.",  self)
                     self.activityView.stopAnimating()
                }
            }
        }
    }
    
    func overwriteLocation(){
        // This function displays the 'AddLocationViewController'.
        let addLocationView = (self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController"))
        show(addLocationView!, sender: self)
    }
    
    func displayError(_ info: String, _ sender: UIViewController, previousPost: Bool) {         // Code for displaying an alert notification was obtained at https://www.ioscreator.com/tutorials/display-alert-ios-tutorial-ios10.  The tutorial for displaying this type of alert was posted by Arthur Knopper on January 10, 2017.
        // This function provides an alert if there was a previously posted location.  
        if previousPost{
            let alertController = UIAlertController(title: "Previously Posted Location", message: info, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: nil))
            let addLocation = UIAlertAction(title:"Overwrite", style: UIAlertActionStyle.default, handler: {action in self.overwriteLocation()})
            alertController.addAction(addLocation)
            sender.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Cannot retrieve User Data", message: info, preferredStyle: UIAlertControllerStyle.alert)
            let dismissAlert = UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(dismissAlert)
            sender.present(alertController, animated: true, completion: nil)
        }
    }
}
