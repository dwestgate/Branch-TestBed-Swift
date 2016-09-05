//
//  Dictionary+JSONDescription.swift
//  TestBed-Swift
//
//  Created by David Westgate on 9/5/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//

import Foundation

extension Dictionary {

    func JSONDescription() -> String {
        
        let data = self as! AnyObject
        var jsonString = "Error parsing dictionary"
        
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions.PrettyPrinted)
            jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
            
        } catch let error as NSError {
            print(error.description)
        }
        return jsonString
    }
    
}