//
//  ContentViewController.swift
//  TestBed-Swift
//
//  Created by David Westgate on 8/29/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//
import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    
    var content: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        content = ""
        
        
        if let universalObject = Branch.getInstance().getLatestReferringBranchUniversalObject() {
            content = String(format:"\nLatestReferringBranchUniversalObject:\n\n%@", universalObject)
            print("Branch TestBed: nLatestReferringBranchUniversalObject:\n", content)
            
            if let imageURL = URL(string: universalObject.imageUrl!) {
                imageView.loadImageFromUrl(url: imageURL)
                print("ImageURL=\(imageURL)")
            }
            
            universalObject.userCompletedAction(BNCRegisterViewEvent)
        }
        if let latestReferringParams = Branch.getInstance().getLatestReferringParams() {
            content = String(format:"%@\n\nLatestReferringParams:\n\n%@", self.content, latestReferringParams.JSONDescription())
            print("Branch TestBed: LatestBranchUniversalObject:\n", content)
        }
        
        // setting scrollEnabled to false prevents a clipping bug
        contentTextView.isScrollEnabled = false
        contentTextView.text = content
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // re-enabling scrollEnabled after view is painted
        contentTextView.isScrollEnabled = true
    }

    
}
