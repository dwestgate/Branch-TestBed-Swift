//
//  NavigationController.swift
//  TestBed-Swift
//
//  Created by David Westgate on 8/29/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//
import UIKit

class NavigationController: UINavigationController, BranchDeepLinkingController {

    
    var deepLinkingCompletionDelegate: BranchDeepLinkingControllerCompletionDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureControlWithData(data: [NSObject : AnyObject]!) {
        let logOutputViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LogOutput") as! LogOutputViewController
        print("Navigation Controller")
        self.pushViewController(logOutputViewController, animated: true)
        if let deeplinkText = data["$canonical_identifier"] as! String? {

            do {
                let jsonData = try NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions.PrettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
                let logOutput = String(format:"Successfully Deeplinked:\n\n%@\nSession Details:\n\n%@", deeplinkText, jsonString)
                logOutputViewController.logOutput = logOutput
            } catch let error as NSError {
                print(error.description)
            }
            
        }
    }
}
