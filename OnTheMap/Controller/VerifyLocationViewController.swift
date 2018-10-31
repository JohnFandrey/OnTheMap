//
//  VerifyLocationViewController.swift
//  OnTheMap
//
//  Created by JohnFandrey on 6/19/18.
//  Copyright © 2018 JohnFandrey. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class VerifyLocationViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView?
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    
    func revealActivityView(start: Bool){ // This function controls the visibility and animation of the activityIndicatorView.
        if start {
            activityView.isHidden = false
            activityView.startAnimating()
        } else {
            activityView.isHidden = true
            activityView.stopAnimating()
        }
    }
    
    @IBAction func submitLocation(){        // This function calls either a POST or PUT function depending on whether the user has previously posted a view.
        self.revealActivityView(start: true)
        if ParseClient.sharedInstance().previousPost == false {
            postStudentData()
        }
        if ParseClient.sharedInstance().previousPost == true {
            putStudentData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let annotation = ParseClient.sharedInstance().myAnnotation
        let initialLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        centerMapOnLocation(location: initialLocation)
        self.mapView?.addAnnotation(annotation)
        mapView?.delegate = self
        activityView.isHidden = true
    }
    
    // I found the code for setting the initial map location as seen below at https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started.  The original post was by Ray Wenderlich and was updated by Audrey Tam on June 27, 2017.
    
    let regionRadius: CLLocationDistance = 1000000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView?.delegate = self
        mapView?.setRegion(coordinateRegion, animated: true)
    }
    
    // I used the PinSample App provided by Udacity and the Ray Wenderlich tutorial updated by Audrey Tam and mentioned above to get the delegate function below to work properly. I was originally having issues with markers or balloons appearing instead of pins.
    
    // 1
    func mapView(_: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 3
        let identifier = "marker"
        var view: MKPinAnnotationView
        // 4
        if let dequeuedView = mapView?.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func postStudentData(){  // This function calls a POST function with the appropriate completion handler.
        ParseClient.sharedInstance().postStudentData(){ data, error in
            if error != nil {
                DispatchQueue.main.async {
                    ParseClient.sharedInstance().displayError("We were unable to post your location.  Please contact the developer to report this issue.  The POST request returned the following error: \(error!)", self)
                    self.revealActivityView(start: false)
                }
            } else {
                if let data = data {
                    let tabView = (self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController)
                    // I found example code for instantiating a ViewController at https://stackoverflow.com/questions/26306557/how-can-i-present-a-uitabbarcontroller-in-swift?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa in a post by Mick MacCallum dated October 10, 2014.
                    DispatchQueue.main.async {
                        self.revealActivityView(start: false)
                        self.present(tabView!, animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        ParseClient.sharedInstance().displayError("There was an error when attempting to POST your location.  The data retrieved from the Udacity server was not able to be stored as expected.  Please contact Udacity and the app developer to report this issue.", self)
                        self.revealActivityView(start: false)
                        let tabView = (self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController)
                        // I found example code for instantiating a ViewController at https://stackoverflow.com/questions/26306557/how-can-i-present-a-uitabbarcontroller-in-swift?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa in a post by Mick MacCallum dated October 10, 2014.
                        self.present(tabView!, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func putStudentData(){ // This function calls a PUT function with the appropriate completion handler.  
        ParseClient.sharedInstance().putStudentData(){data, error in
            if error != nil {
                DispatchQueue.main.async {
                    ParseClient.sharedInstance().displayError("We were unable to post your location.  Please contact the developer to report this issue.  The POST request returned the following error: \(error!)", self)
                    self.revealActivityView(start: false)
                }
            } else {
                if let data = data {
                    let tabView = (self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController)
                    // I found example code for instantiating a ViewController at https://stackoverflow.com/questions/26306557/how-can-i-present-a-uitabbarcontroller-in-swift?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa in a post by Mick MacCallum dated October 10, 2014.
                    DispatchQueue.main.async {
                        self.revealActivityView(start: false)
                        self.present(tabView!, animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        ParseClient.sharedInstance().displayError("There was an error when attempting to PUT your location.  The data retrieved from the Udacity server was not able to be stored as expected.  Please contact Udacity and the app developer to report this issue.", self)
                        self.revealActivityView(start: false)
                        let tabView = (self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController)
                        // I found example code for instantiating a ViewController at https://stackoverflow.com/questions/26306557/how-can-i-present-a-uitabbarcontroller-in-swift?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa in a post by Mick MacCallum dated October 10, 2014.
                        self.present(tabView!, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
}

