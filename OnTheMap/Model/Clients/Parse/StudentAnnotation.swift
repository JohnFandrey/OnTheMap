//
//  StudentAnnotation.swift
//  OnTheMap
//
//  Created by Katie Fandrey on 6/8/18.
//  Copyright © 2018 JohnFandrey. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class StudentAnnotation: NSObject {
    
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    
    let annotation: MKAnnotation = 
    
    let pin: MKPointAnnotation
    
    init(_ studentStruct: StudentData.Student) {
        coordinate = studentStruct.coordinate
        title = studentStruct.firstName! + " " + studentStruct.lastName!
        subtitle = studentStruct.mediaURL!
    }
}

