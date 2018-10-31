//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by John Fandrey on 6/19/18.
//  Copyright © 2018 JohnFandrey. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
lazy var geocoder = CLGeocoder()
    
    @IBOutlet weak var activityView: UIActivityIndicatorView?
    @IBOutlet weak var locationTextField: UITextField?
    @IBOutlet weak var mediaURL: UITextField?
    
    
    // I relied on a tutorial by Bart Jacobs posted on September 26, 2016 at https://cocoacasts.com/forward-geocoding-with-clgeocoder to put together the code for forward geocoding an address into coordinates.  Jacob's tutorial was very helpful in understanding this concept and in putting the code together.  Samples of code provided by Mr. Jacobs were adapted to satisfy the requirements of the OnTheMap project.
    
    override func viewDidLoad() {
        activityView?.isHidden = true
    }
    
    
    @IBAction func checkLocation() {
        if locationTextField?.text != "" && mediaURL?.text != "" {
            revealActivityView(true)
            ParseClient.sharedInstance().myMapString = (locationTextField?.text)!
            ParseClient.sharedInstance().myMediaURL = (mediaURL?.text)!
            geocoder.geocodeAddressString((locationTextField?.text)!) { (placemarks, error) in
                // Need to check the response obtained from the geocoder.
                self.checkGeocodingResponse(withPlacemarks: placemarks, error: error)
                DispatchQueue.main.async{
                    self.revealActivityView(false)
                    let AddLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyLocationViewController") as! VerifyLocationViewController
                    self.show(AddLocationViewController, sender: self)
                }
            }
        } else {
            ParseClient.sharedInstance().displayError("Please enter a location (City, State or City, Country) and a URL starting with 'http://'", self)
        }
    }
    
    // I relied on a tutorial by Bart Jacobs posted on September 26, 2016 at https://cocoacasts.com/forward-geocoding-with-clgeocoder to put together the code for forward geocoding an address into coordinates.  Jacob's tutorial was very helpful in understanding this concept and in putting the code together.  Samples of code provided by Mr. Jacobs were adapted to satisfy the requirements of the OnTheMap project.
    
    func checkGeocodingResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if error != nil {
            ParseClient.sharedInstance().displayError("We were unable to find that location.  Please try another location.", self)
        } else {
            var location: CLLocation?
            if let placemarks = placemarks {
                if placemarks.count > 0 {
                  location = placemarks.first?.location
                } else {
                    location = placemarks[0].location
                }
            }
            if let location = location {
                ParseClient.sharedInstance().myAnnotation.coordinate = location.coordinate
                ParseClient.sharedInstance().myLatitude = String(location.coordinate.latitude)
                ParseClient.sharedInstance().myLongitude = String(location.coordinate.longitude)
            } else {
                ParseClient.sharedInstance().displayError("We were unable to find that location.  Please try another location.", self)
            }
        }
    }
    
    func revealActivityView(_ start: Bool){         // This function allows a user to hide / reveal and start / stop animating the activity indicator view.  Using this function prevents code from being repeated multiple times.  
        if start {
            activityView?.isHidden = false
            activityView?.startAnimating()
        } else {
            activityView?.isHidden = true
            activityView?.stopAnimating()
        }
    }
    
}
