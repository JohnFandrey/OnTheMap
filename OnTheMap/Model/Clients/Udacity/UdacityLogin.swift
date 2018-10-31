//
//  UdacityLogin.swift
//  OnTheMap
//
//  Created by JohnFandrey on 5/15/18.
//  Copyright © 2018 JohnFandrey. All rights reserved.
//

import Foundation
import UIKit

class UdacityLogin: NSObject {
    
    var sessionID: String
    var username: String
    var password: String
    
    override init() {
        super.init()
    }
    
    func obtainSessionId (username: String, password: String) -> String {
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
        return username
    }
    
}
