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
    
    func configureControlWithData(params: [NSObject : AnyObject]!) {
        let logOutputViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LogOutput") as! LogOutputViewController
        self.pushViewController(logOutputViewController, animated: true)
        
        let dict = params as Dictionary
        let referringLink = dict["~referring_link"]
        let logOutput = String(format:"\nReferring link: \(referringLink)\n\nSessionDetails:\n\(dict.JSONDescription())")
        logOutputViewController.logOutput = logOutput
    }
}
