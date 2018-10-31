//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Katie Fandrey on 6/19/18.
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
    
    // Need to add comments for source of geocoding code.
    
    override func viewDidLoad() {
        activityView?.isHidden = true
    }
    
    
    @IBAction func checkLocation() {
        if locationTextField?.text != "" && mediaURL?.text != "" {
            revealActivityView(true)
            ParseClient.sharedInstance().mediaURL = mediaURL?.text
            geocoder.geocodeAddressString((locationTextField?.text)!) { (placemarks, error) in
                // Need to check the response obtained from the geocoder.
                self.checkGeocodingResponse(withPlacemarks: placemarks, error: error)
                self.revealActivityView(false)
                DispatchQueue.main.async{
                    let AddLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyLocationViewController") as! VerifyLocationViewController
                    self.show(AddLocationViewController, sender: true)
                }
            }
        } else {
            ParseClient.sharedInstance().displayError("Please enter a location (City, State or City, Country) and a URL starting with 'http://'", self)
        }
    }
    
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
            } else {
                ParseClient.sharedInstance().displayError("We were unable to find that location.  Please try another location.", self)
            }
        }
    }
    
    func revealActivityView(_ start: Bool){
        if start {
            activityView?.isHidden = false
            activityView?.startAnimating()
        } else {
            activityView?.isHidden = true
            activityView?.stopAnimating()
        }
    }
    
}
