//
//  NavigationController.swift
//  OnTheMap
//
//  Created by Katie Fandrey on 6/12/18.
//  Copyright © 2018 JohnFandrey. All rights reserved.
//

import Foundation
import UIKit

class tabBarController: UITabBarController {
    
    var tabViewController: UITabBarController = storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as? UITabBarController
        
        presentViewController(tabViewController, animated: true, completion: nil)
}
