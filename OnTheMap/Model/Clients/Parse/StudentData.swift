//
//  StudentData.swift
//  OnTheMap
//
//  Created by JohnFandrey on 5/15/18.
//  Copyright © 2018 JohnFandrey. All rights reserved.
//

import Foundation
import MapKit

/* class StudentData: NSObject {
    
//    var students = [Student]()
//    var studentAnnotations = [StudentAnnotation]()
    
    
     init(_ studentDictionary: [[String:AnyObject]]) {
        for item in studentDictionary {
            MyClassmates.sharedInstance().myClassmates.append(Student(item))
        }
    }
    
    struct Student {
        var firstName: String?
        var lastName: String?
        var objectID: String?
        var uniqueKey: String?
        var mapString: String?
        var mediaURL: String?
        var latitude: NSNumber?
        var longitude: NSNumber?
        var createdAt: String?
        var updatedAt: String?
        var coordinate: CLLocationCoordinate2D
    
        init(_ studentDictionary: [String:AnyObject]) {
            firstName = studentDictionary["firstName"] as! String? ?? "No first name."
            lastName = studentDictionary["lastName"] as! String? ?? "No last name."
            objectID = studentDictionary["objectID"] as! String? ?? "No objectID."
            uniqueKey = studentDictionary["uniqueKey"] as! String? ?? "No unique key."
            mapString = studentDictionary["mapString"] as! String? ?? "No map string."
            mediaURL = studentDictionary["mediaURL"] as! String? ?? "No mediaURL"
            createdAt = studentDictionary["createdAt"] as! String? ?? "2018-01-01"
            updatedAt = studentDictionary["updatedAt"] as! String? ?? "2018-01-01"
            if studentDictionary["longitude"] is NSNull || studentDictionary["longitude"] == nil {
                longitude = -105
            } else {
                longitude = studentDictionary["longitude"] as! NSNumber?
            }
            if studentDictionary["latitude"] is NSNull || studentDictionary["latitude"] == nil {
                latitude = 39
            } else {
                latitude = studentDictionary["latitude"] as! NSNumber?
            }
            coordinate = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
        }
    }
}

 */
