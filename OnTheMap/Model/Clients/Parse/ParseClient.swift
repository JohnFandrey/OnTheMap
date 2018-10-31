//
//  ParseClient.swift
//  OnTheMap
//
//  Created by JohnFandrey on 5/15/18.
//  Copyright © 2018 JohnFandrey. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ParseClient: NSObject {
    
    var sessionID: String = ""
    var uniqueKey: String = ""
    let tabBarController = UITabBarController()
    let navigationController = UINavigationController()
    var myMediaURL: String = ""
    var myLocation: CLLocationCoordinate2D? = nil
    var myAnnotation = MKPointAnnotation()
    var myFirstName: String = ""
    var myLastName: String = ""
    var myMapString: String = ""
    var previousPost: Bool = false
    var objectID: String = ""
    var myLatitude: String = ""
    var myLongitude: String = ""

    class func sharedInstance() -> ParseClient {  // Declare a function that creates an instance of ParseClient.  This function returns an instance of ParseClient, thus the other objects can access the functions in ParseClient through this function.
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
    func getUserData(_ completionHandlerForGetUserData: @escaping (_ data: AnyObject?, _ error: String?) -> Void){
        // This function retrieves data on the user such as the user's first name and last name.
        let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/\(uniqueKey)")!) // Creates a request using the user's uniqueKey.
        let session = URLSession.shared
        _ = taskForMethod(true, request, completionHandlerForGetUserData) // Calls the 'taskForMethod' function with the appropriate parameters.
    }
    
    func postStudentData(_ completionHandlerForPostStudentData: @escaping (_ data: AnyObject?, _ error: String?) -> Void){
        // This function is called when the user has not previously posted a location.
        // The code for this request can be found at https://classroom.udacity.com/nanodegrees/nd003/parts/99f2246b-fb9e-41a9-9834-3b7db87f7628/modules/undefined/lessons/3071699113239847/concepts/25771065-aba2-4a3d-b424-2f21fe83d5ce
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue(ParseClient.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.parseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(myFirstName)\", \"lastName\": \"\(myLastName)\",\"mapString\": \"\(myMapString)\", \"mediaURL\": \"\(myMediaURL)\",\"latitude\": \(myLatitude), \"longitude\": \(myLongitude)}".data(using: .utf8)
        let session = URLSession.shared
        _ = taskForMethod(false, request, completionHandlerForPostStudentData)
    }
    
    func putStudentData(_ completionHandlerForPutStudentData: @ escaping (_ data: AnyObject?, _ error: String?) -> Void) {
        // This function should be called when the user has previously posted a location.
        // The code for this function can be found at https://classroom.udacity.com/nanodegrees/nd003/parts/99f2246b-fb9e-41a9-9834-3b7db87f7628/modules/undefined/lessons/3071699113239847/concepts/62282f95-6d40-4b1e-bc99-8db9dfa5bd6c.
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/\(objectID)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue(ParseClient.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.parseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(myFirstName)\", \"lastName\": \"\(myLastName)\",\"mapString\": \"\(myMapString)\", \"mediaURL\": \"\(myMediaURL)\",\"latitude\": \(myLatitude), \"longitude\": \(myLongitude)}".data(using: .utf8)
        let session = URLSession.shared
        _ = taskForMethod(false, request, completionHandlerForPutStudentData)
    }
    
    func getStudentData(_ completionHandlerForGetStudentData: @escaping (_ data: AnyObject?, _ error: String?) -> Void){
        // This function requests data from the udacity server and populates an array of Student structs in the MyClassmates class. The code can be found at
        // https://classroom.udacity.com/nanodegrees/nd003/parts/99f2246b-fb9e-41a9-9834-3b7db87f7628/modules/undefined/lessons/3071699113239847/concepts/69583d10-d1d5-4249-892e-cc845832eacc
        MyClassmates.sharedInstance().myClassmates = [MyClassmates.StudentInformation]() // Iniatialize an array of Student structs.
        MyClassmates.sharedInstance().myClassmatesAnnotations = [MKPointAnnotation]()
        var myClassmatesAnnotations = [MKPointAnnotation]() // Initialize an array of MKPointAnnotation.
        let limit = "100"
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=\(limit)&order=-updatedAt")!)
        request.addValue(ParseClient.parseApplicationID, forHTTPHeaderField: ParseClient.parseParameters["applicationIDHeaderField"]!)
        request.addValue(ParseClient.parseAPIKey, forHTTPHeaderField: ParseClient.parseParameters["apiKeyHeaderField"]!)
        request.addValue(ParseClient.parseParameters["contentType"]!, forHTTPHeaderField: ParseClient.parseParameters["contentTypeHeaderField"]!)
        _ = self.taskForMethod(false, request, completionHandlerForGetStudentData)
    }
    
    func taskForMethod(_ udacityMethod: Bool, _ request: URLRequest, _ completionHandlerForMethod: @escaping (_ data: AnyObject?, _ error: String?) -> Void) -> URLSessionDataTask {
        // This function returns a URLSessionDataTask
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard (error == nil) else {
                self.checkError(error, completionHandler: completionHandlerForMethod) // calls a function to check the error returned.
                return
            }
            guard (((response as? HTTPURLResponse)?.statusCode)! >= 200 && ((response as? HTTPURLResponse)?.statusCode)! <= 299) // Check that the status code returned by the server is >= 200 and <= 299.
                else {
                    self.checkResponse(response: response as! HTTPURLResponse, completionHandler: completionHandlerForMethod) // calls a function to check the response returned.
                return
            }
            guard (data == nil) else {
                self.convertData(udacityMethod, data!, completionHandler: completionHandlerForMethod) // calls a function to conver the data returned by the function.
                return
            }
        }
        task.resume()
        return task
    }
    
    
    func convertData(_ udacityMethod: Bool, _ data: Data, completionHandler: @escaping (_ data: AnyObject?, _ error: String?) -> Void) {
        // Function for converting JSON data to usable dictionary.
        var newData: Data = data
        if udacityMethod {      // If the method is a udacity method then the first 5 characters must be excluded.
            let range = Range(5..<data.count)
            newData = data.subdata(in: range)
        }
        var parsedData: AnyObject! = nil                                                                                                // Initialize object for storing parsed JSON data.
        do {
            parsedData = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject                            // Attempt to store parsed JSON data in parsedData object.
            completionHandler(parsedData, nil) // Calls the completionHandler wit the parsed data.
        } catch {
           completionHandler(nil, "The app was unable to parse the data returned by the server.  Please contact Udacity to report this issue.")
            // Calls the completion handler with an error message if the data could not be parsed.
        }
    }
    
    func checkError(_ error: Error?, completionHandler: @escaping (_ data: AnyObject?, _ error: String?) -> Void) {
        if let errorText: String = error as? String {                                                                   // If there was an error check to see if it can be stored as a string.
            completionHandler(nil, "There was an error with your request: \(errorText)")    // If the error can be stored as a string, then call the completion handler with the error string.
            return
        } else {                                                                        // If the error cannot be stored as a string, then check to see if it can be respresented as an NSError.
            if let error = error as NSError? {                          // If the error can represented as an NSerror then check to see if the error.code value is -1001 or -999.
                if error.code == -1001 || error.code == -999 {                                        // If the error.code value is -1001 or -999 then call the completion handler with the appropriate error message.
                    completionHandler(nil, "The request timed out.  Please check your internet connection and try again.")
                    return
                } else {
                    completionHandler(nil, "Your request produced the following error code: \(error.code). Please contact the developer to inform them that you received this code.") // If the error code is not -1001 or -999 then call the completion handler with the code returned.
                    return
                }
            }
            return
        }
    }
    
    func checkResponse(response: HTTPURLResponse, completionHandler: @escaping ((_ data: AnyObject?, _ error: String?) -> Void)) {
        if response.statusCode == 403 {                                                          // Check if the code = 403, indicating invalid credentials.
            let errorString = "Your account was not found.  Please verify that you are registered and that you correctly entered your username and password."
            completionHandler(nil, errorString)  // Call completion handler with message indicating invalid credentials.
            return
        } else {
            let errorString = "Your request produced the following response code: \(response.statusCode).  Please contact the developer to inform them that you received the following response code."
            completionHandler(nil, errorString)
            return
            }
    }
    
    func obtainSessionID (_ username: String, _ password: String, _ completionHandler: @escaping (_ data: AnyObject?, _ error: String?) -> Void) {
        // Function for creating request to obtain session ID.
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)  // Initialize variable for storing URL request.
        request.httpMethod = "POST"                                                        // Set method to POST.
        request.addValue("application/json", forHTTPHeaderField: "Accept")                // Add values for headers.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        // Set the request body using the credentials obtained from the user.
        _ = taskForMethod(true, request, completionHandler)
    }
    
    func displayError(_ info: String, _ sender: UIViewController) {         // Code for displaying an alert notification was obtained at https://www.ioscreator.com/tutorials/display-alert-ios-tutorial-ios10.  The tutorial for displaying this type of alert was posted by Arthur Knopper on January 10, 2017.
        let alertController = UIAlertController(title: "Error", message: info, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        sender.present(alertController, animated: true, completion: nil)
    }
    
    func logOutUdacity(completionHandler: @escaping (_ data: AnyObject?, _ error: String?) -> Void){
        // The code for logging out of the app was provided by Udacity and can be found at https://classroom.udacity.com/nanodegrees/nd003/parts/99f2246b-fb9e-41a9-9834-3b7db87f7628/modules/undefined/lessons/3071699113239847/concepts/32465f80-b475-44bb-82a8-677ca1c808b2.
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let _ = self.taskForMethod(true, request, completionHandler)
    }
    
    func getUserLocation(completionHandlerForGetUserLocation: @escaping (_ data: AnyObject?, _ error: String?) -> Void){
        // The code for obtaining a single userlocation can be found at https://classroom.udacity.com/nanodegrees/nd003/parts/99f2246b-fb9e-41a9-9834-3b7db87f7628/modules/undefined/lessons/3071699113239847/concepts/2c05d615-848c-48af-ae47-20ae59c11150.
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(uniqueKey)%22%7D"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        _ = taskForMethod(false, request, completionHandlerForGetUserLocation)
    }
    
    

}
