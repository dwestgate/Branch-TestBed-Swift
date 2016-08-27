//
//  EnterLinkTagViewController.swift
//  AdScrubber
//
//  Created by David Westgate on 12/31/15.
//  Copyright © 2016 David Westgate
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions: The above copyright
// notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE

import UIKit

/// Manages the user interface for updating the
/// valueTextView field of ViewController
class EnterLinkTagViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    // MARK: -
    // MARK: Control Outlets
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: Variables
    var incumbantTag: String!
    
    // MARK: Overridden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagTextField.text = incumbantTag
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // TestData.setCustomEventMetadataElement(valueTextView.text)
        
    }
    
    // MARK: Control Functions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if ((saveButton === sender) && (tagTextField != "")) {
            // don't need this if using unwind
        }
    }
    
}
