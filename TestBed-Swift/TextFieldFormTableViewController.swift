//
//  TextFieldFormTableViewController.swift
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
class TextFieldFormTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: -
    // MARK: Control Outlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: Variables
    var sender = ""
    var incumbantValue = ""
    var viewTitle = "Default Title"
    var placeholder = "Default Placeholder"
    var header = "Default Header"
    var footer = "Default Footer"
    var keyboardType = UIKeyboardType.Default
    
    // MARK: Overridden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewTitle
        textField.placeholder = placeholder
        textField.text = incumbantValue
        textField.keyboardType = keyboardType
        textField.text = incumbantValue
        textField.becomeFirstResponder()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header
    }
    
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return footer
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
        if ((saveButton === sender) && (textField != "")) {
            // don't need this if using unwind
        }
    }
    
}
