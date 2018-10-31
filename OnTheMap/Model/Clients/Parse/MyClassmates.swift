//
//  MyClassmates.swift
//  OnTheMap
//
//  Created by John Fandrey on 6/12/18.
//  Copyright © 2018 JohnFandrey. All rights reserved.
//

import Foundation
import MapKit

class MyClassmates: NSObject {
    
    var myClassmates = [StudentInformation]()  // Iniatialize an array of Student structs.
    var myClassmatesAnnotations = [MKPointAnnotation]() // Initialize an array of MKPointAnnotation.
    
    class func sharedInstance() -> MyClassmates {  // Declare a function that creates an instance of MyClassmates.  This function returns an instance of MyClassmates, thus the other objects can access objects in MyClassmates through this function.
        struct Singleton {
            static var sharedInstance = MyClassmates()
        }
        return Singleton.sharedInstance
    }
    
    struct StudentInformation {            // Create a student struct with the necessary properties.
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
        
        init(_ studentDictionary: [String:AnyObject]) {             // Create an initializer that accepts a dictionary.
            firstName = studentDictionary["firstName"] as! String? ?? "No first name."
            lastName = studentDictionary["lastName"] as! String? ?? "No last name."
            objectID = studentDictionary["objectID"] as! String? ?? "No objectID."
            if studentDictionary["uniqueKey"] is NSNull || studentDictionary["uniqueKey"] == nil {
                uniqueKey = "No unique key."
            } else {
                uniqueKey = studentDictionary["uniqueKey"] as? String
            }
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
    
    func initializeClassmates(dictionary: [[String:AnyObject]]){        // Populates the array myClassmates
        // Sets a counter to check for nil values.
        for student in dictionary {
            if checkForNilValue(dictionary: student) == false {   // calls a function 'checkForNilValue' using 'student'.  If the function returns false, then there was no nil value and the 'student' should be added to the table.
            myClassmates.append(StudentInformation(student)) // appends a 'Student' struct to the array 'myClassmates' by calling the initializer for the 'Student' struct with the 'student' value.
            }
        } // If the 'checkForNilValue' function returns false then the student is not added to the array.
    }
    
    func initializeClassmatesAnnotations(array: [StudentInformation]){     // Populates the 'myClassmatesAnnotations' array.
        for student in array {                      // loops through the 'array' passed to the function.
            let annotation = MKPointAnnotation()    // creates a value of type MKPointAnnotation().
            annotation.coordinate = student.coordinate
            annotation.title = student.firstName! + " " + student.lastName!
            annotation.subtitle = student.mediaURL
            myClassmatesAnnotations.append((annotation)) //append the annotation to the 'myClassmatesAnnotations' array.
        }
    }
    
    func checkForNilValue(dictionary: [String:AnyObject]) -> Bool {  // Checks for nil values and returns a boolean value.
        for value in arrayOfKeys {
            if dictionary[value] is NSNull || dictionary[value] == nil {
                return true  // returns true if the student had a nil value.
            }
        }
        return false
    }
    
    let arrayOfKeys = ["firstName", "lastName", "mediaURL", "updatedAt", "longitude", "latitude"]  // sets an array of keys needed for displaying a student location in on the map.  
    
}
