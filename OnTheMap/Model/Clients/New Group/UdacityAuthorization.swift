//
//  UdacityAuthentication.swift
//  OnTheMap
//
//  Created by JohnFandrey on 5/16/18.
//  Copyright © 2018 JohnFandrey. All rights reserved.
//

import Foundation
import UIKit

class UdacityAuthorization: NSObject {      // Create class with functions for obtaining Udacity sessionID.
    
    var sessionID: String = ""
    var uniqueKey: String = ""
    
    func convertData(_ data: Data, _ completionHandlerForConvertData: @escaping (_ data: AnyObject?, _ error: String?) -> Void) {       // Function for converting JSON data to usable dictionary.
        var parsedData: AnyObject! = nil                                                                                                // Initialize object for storing parsed JSON data.
        do {
            parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject                            // Attempt to store parsed JSON data in parsedData object.
        } catch {
            completionHandlerForConvertData(nil, "The app was unable to parse the data from the server.  Please contact Udacity for assistance.") // Call completion handler if unable to parse JSON data.
        }
        completionHandlerForConvertData(parsedData, nil)                                                                                // Call completion handler with parsed data.
    }
    
    func obtainSessionID (_ username: String, _ password: String, _ completionHandler: @escaping (_ data: AnyObject?, _ error: String?) -> Void) {  // Function for creating request to obtain session ID.
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)                                                          // Initialize variable for storing URL request.
        request.httpMethod = "POST"                                                                                                                 // Set method to POST.
        request.addValue("application/json", forHTTPHeaderField: "Accept")                                                                          // Add values for headers.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)      // Set the request body using the credentials obtained from the user.
        let session = URLSession.shared                                                                                            // Initialize a URL session.
        let task = session.dataTask(with: request) { data, response, error in                                                      // Create a 'task' constant to call the 'dataTask' function.
            
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {                                                                                         // Check to see if the data task returned an error.
                if let errorText: String = error as? String {                                                                   // If there was an error check to see if it can be stored as a string.
                completionHandler(nil, "There was an error with your request: \(errorText)")    // If the error can be stored as a string, then call the completion handler with the error string.
                return
                } else {                                                                        // If the error cannot be stored as a string, then check to see if it can be respresented as an NSError.
                    if let error = error as NSError? {
                        // If the error can be represented as an NSerror then check to see if the NSLocalizedDescription in the user info equals 'The request timed out.'  This will let us know that there is an issue with the internet connection.
                        if error.userInfo[NSLocalizedDescriptionKey] as? String == "The request timed out." {
                            completionHandler(nil, "The request timed out.  Please check your internet connection and try again.")
                        } else {
                            completionHandler(nil, "Your request produced the following error description: \(error.userInfo[NSLocalizedDescriptionKey])") // If the NSLocalizedDescription is not 'The request timed out.' Then display
                        }
                    }
                    return
                }
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {    // Check that the status code returned by the server is >= 200 and <= 299.
                if (response as? HTTPURLResponse)?.statusCode == 403 {                                                          // Check if the code = 403, indicating invalid credentials.
                    completionHandler(nil, "Your account was not found.  Please verify that you are registered and that you correctly entered your username and password.")  // Call completion handler with message indicating invalid credentials.
                return
                }
                return
            }
            /* GUARD: Was there any data returned? */
            guard let data = data else {                                                                    // Verify that the server returned data.
                completionHandler(nil, "The server did not return any data.  Please try again later.")  // If no data was returned, call the completion handler with the appropriate error message.
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            let range = Range(5..<data.count)                   // Set a range starting after the 5th character in the data and ending with the last character in the data.
            let newData = data.subdata(in: range)               // Set a constant 'newData' equal to the the data in the specified 'range' of data.
            self.convertData(newData, completionHandler)        // Call the converData function with the newData, and the completion handler passed in by the loginViewController.
        }
        task.resume()
    }

    
    class func sharedInstance() -> UdacityAuthorization {  // Declare a function that creates an instance of UdacityAuthorization.  This function returns an instance of UdacityAuthorization, thus the other objects can access the functions in UdacityAuthorization through this function.  
        struct Singleton {
            static var sharedInstance = UdacityAuthorization()
        }
        return Singleton.sharedInstance
    }
}
