//
//  Constants.swift
//  OnTheMap
//
//  Created by JohnFandrey on 5/15/18.
//  Copyright © 2018 JohnFandrey. All rights reserved.
//

import Foundation
import UIKit

extension ParseClient {
        
        // MARK: General
        static let parseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let parseAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
        // MARK: Parameters for Udacity Methods
    
    static let udacityParameters = ["baseURL":"https://www.udacity.com/", "acceptHeaderField":"Accept", "acceptHeaderFieldValue":"application/json", "contentTypeHeaderField":"Content-Type", "apiSession":"api/session", "users":"users"]
    
    // MARK: Parameters for Parse Methods
    
    static let parseParameters = ["baseURL":"https://parse.udacity.com/parse/classes/StudentLocation", "contentTypeHeaderField":"Content-Type", "contentType":"application/json", "applicationIDHeaderField":"X-Parse-Application-Id", "apiKeyHeaderField":"X-Parse-REST-API-Key", "dataKey":"results"]
    
    }
