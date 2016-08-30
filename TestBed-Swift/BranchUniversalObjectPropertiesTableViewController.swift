//
//  BranchUniversalObjectPropertiesTableViewController.swift
//  TestBed-Swift
//
//  Created by David Westgate on 8/29/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//
import UIKit

class BranchUniversalObjectPropertiesTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Controls
    
    @IBOutlet weak var canonicalIdentifierTextField: UITextField!
    @IBOutlet weak var canonicalURLTextField: UITextField!
    @IBOutlet weak var customDataTextView: UITextView!
    @IBOutlet weak var keywordsTextView: UITextView!
    @IBOutlet weak var ogTitleTextField: UITextField!
    @IBOutlet weak var ogDescriptionTextField: UITextField!
    @IBOutlet weak var ogImageURLTextField: UITextField!
    @IBOutlet weak var ogImageWidthTextField: UITextField!
    @IBOutlet weak var ogImageHeightTextField: UITextField!
    @IBOutlet weak var contentTypeTextField: UITextField!
    @IBOutlet weak var ogVideoTextField: UITextField!
    @IBOutlet weak var ogURLTextField: UITextField!
    @IBOutlet weak var ogTypeTextField: UITextField!
    @IBOutlet weak var ogRedirectTextField: UITextField!
    @IBOutlet weak var ogAppIDTextField: UITextField!
    @IBOutlet weak var twitterCardTextField: UITextField!
    @IBOutlet weak var twitterTitleTextField: UITextField!
    @IBOutlet weak var twitterDescriptionTextField: UITextField!
    @IBOutlet weak var twitterSiteTextField: UITextField!
    @IBOutlet weak var twitterAppTextField: UITextField!
    @IBOutlet weak var twitterPlayerTextField: UITextField!
    @IBOutlet weak var twitterPlayerWidthTextField: UITextField!
    @IBOutlet weak var twitterPlayerHeightTextField: UITextField!
    @IBOutlet weak var publiclyIndexableSwitch: UISwitch!
    @IBOutlet weak var expDateTextField: UITextField!
    
    let datePicker = UIDatePicker()
    var universalObjectProperties = [String: AnyObject]()
    
    // MARK: - Core View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITableViewCell.appearance().backgroundColor = UIColor.whiteColor()
        
        datePicker.datePickerMode = .Date
        self.expDateTextField.inputView = datePicker
        self.expDateTextField.inputAccessoryView = createToolbar(true)
        
        refreshControls()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch(indexPath.section) {
        case 2 :
            self.performSegueWithIdentifier("ShowCustomData", sender: "CustomData")
        case 3 :
            self.performSegueWithIdentifier("ShowKeywords", sender: "Keywords")
        default : break
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        refreshUniversalObjectProperties()
        
        switch segue.identifier! {
            case "ShowCustomData":
                let vc = segue.destinationViewController as! DictionaryTableViewController
                if let customData = universalObjectProperties["customData"] as? [String: AnyObject] {
                    vc.dictionary = customData
                }
                // vc.viewTitle = "Custom Data"
                // vc.sender = sender as! String
                // vc.header = "Custom Data"
                // vc.placeholder = "tag"
                // vc.footer = "Enter a new tag to associate with the link."
                // vc.keyboardType = UIKeyboardType.Default
            
            case "ShowKeywords":
                let vc = segue.destinationViewController as! ArrayTableViewController
                if let keywords = universalObjectProperties["$keywords"] as? [String] {
                    vc.array = keywords
                }
                vc.viewTitle = "Keywords"
                vc.sender = sender as! String
                vc.header = "Keyword"
                vc.placeholder = "keyword"
                vc.footer = "Enter a new keyword that describes the content."
                vc.keyboardType = UIKeyboardType.Default
            default:
                break
        }
    }
    
    @IBAction func unwindByCancelling(segue:UIStoryboardSegue) { }
    
    @IBAction func unwindDictionaryTableViewController(segue:UIStoryboardSegue) {
        if let vc = segue.sourceViewController as? DictionaryTableViewController {
            let customData = vc.dictionary
            universalObjectProperties["customData"] = customData
            if customData.count > 0 {
                customDataTextView.text = customData.description
            } else {
                customDataTextView.text = ""
            }
        }
    }
    
    @IBAction func unwindArrayTableViewController(segue:UIStoryboardSegue) {
        if let vc = segue.sourceViewController as? ArrayTableViewController {
            let keywords = vc.array
            universalObjectProperties["$keywords"] = keywords
            if keywords.count > 0 {
                keywordsTextView.text = keywords.description
            } else {
                keywordsTextView.text = ""
            }
        }
    }
    
    //MARK: - Date Picker
    
    func createToolbar(withCancelButton: Bool) -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRectMake(0,0,self.view.frame.size.width,44))
        toolbar.tintColor = UIColor.grayColor()
        let donePickingButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(self.donePicking))
        let emptySpace = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        if (withCancelButton) {
            let cancelPickingButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(self.donePicking))
            toolbar.setItems([cancelPickingButton, emptySpace, donePickingButton], animated: true)
        } else {
            toolbar.setItems([emptySpace, donePickingButton], animated: true)
        }
        
        return toolbar
    }
    
    func createPicker() -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.showsSelectionIndicator = true
        
        return picker
    }
    
    func donePicking() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let expirationDate = datePicker.date
        self.expDateTextField.text = String(format:"%@", dateFormatter.stringFromDate(expirationDate))
        self.expDateTextField.resignFirstResponder()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
    
    func showAlert(alertTitle: String, withDescription message: String) {
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil));
        presentViewController(alert, animated: true, completion: nil);
    }
    
    func refreshControls() {
        canonicalIdentifierTextField.text = universalObjectProperties["$canonical_identifier"] as? String
        canonicalURLTextField.text = universalObjectProperties["$canonical_url"] as? String
        
        if let customData = universalObjectProperties["customData"] as? [String: String] {
            if customData.count > 0 {
                customDataTextView.text = customData.description
            }
        }
        
        if let contentKeywords = universalObjectProperties["$keywords"] as? [String] {
            if contentKeywords.count > 0 {
                keywordsTextView.text = contentKeywords.description
            }
        }
        
        ogTitleTextField.text = universalObjectProperties["$og_title"] as? String
        
        // contentDescriptionTextView: UITextView!
        
        ogImageURLTextField.text = universalObjectProperties["$og_image_url"] as? String
        ogImageWidthTextField.text = universalObjectProperties["$og_image_width"] as? String
        ogImageHeightTextField.text = universalObjectProperties["$og_image_height"] as? String
        contentTypeTextField.text = universalObjectProperties["$content_type"] as? String
        ogVideoTextField.text = universalObjectProperties["$og_video"] as? String
        ogURLTextField.text = universalObjectProperties["$og_url"] as? String
        ogTypeTextField.text = universalObjectProperties["$og_type"] as? String
        ogRedirectTextField.text = universalObjectProperties["$og_redirect"] as? String
        ogAppIDTextField.text = universalObjectProperties["$og_app_id"] as? String
        twitterCardTextField.text = universalObjectProperties["$twitter_card"] as? String
        twitterTitleTextField.text = universalObjectProperties["$twitter_title"] as? String
        twitterDescriptionTextField.text = universalObjectProperties["$twitter_description"] as? String
        twitterSiteTextField.text = universalObjectProperties["$twitter_site"] as? String
        twitterAppTextField.text = universalObjectProperties["$twitter_app_country"] as? String
        twitterPlayerTextField.text = universalObjectProperties["$twitter_player"] as? String
        twitterPlayerWidthTextField.text = universalObjectProperties["$twitter_player_width"] as? String
        twitterPlayerHeightTextField.text = universalObjectProperties["$twitter_player_height"] as? String
        
        publiclyIndexableSwitch.on = false
        if let publiclyIndexable = universalObjectProperties["$publicly_indexable"] as? String {
            if publiclyIndexable == "1" {
                publiclyIndexableSwitch.on = true
            }
        }
        
        expDateTextField.text = universalObjectProperties["$exp_date"] as? String
    }
    
    func refreshUniversalObjectProperties() {
        universalObjectProperties["$canonical_identifier"] = canonicalIdentifierTextField.text
        universalObjectProperties["$canonical_url"] = canonicalURLTextField.text
        
        universalObjectProperties["$og_title"] = ogTitleTextField.text
        
        // contentDescriptionTextView: UITextView!
        
        universalObjectProperties["$og_image_url"] = ogImageURLTextField.text
        universalObjectProperties["$og_image_width"] = ogImageWidthTextField.text
        universalObjectProperties["$og_image_height"] = ogImageHeightTextField.text
        universalObjectProperties["$content_type"] = contentTypeTextField.text
        universalObjectProperties["$og_video"] = ogVideoTextField.text
        universalObjectProperties["$og_url"] = ogURLTextField.text
        universalObjectProperties["$og_type"] = ogTypeTextField.text
        universalObjectProperties["$og_redirect"] = ogRedirectTextField.text
        universalObjectProperties["$og_app_id"] = ogAppIDTextField.text
        universalObjectProperties["$twitter_card"] = twitterCardTextField.text
        universalObjectProperties["$twitter_title"] = twitterTitleTextField.text
        universalObjectProperties["$twitter_description"] = twitterDescriptionTextField.text
        universalObjectProperties["$twitter_site"] = twitterSiteTextField.text
        universalObjectProperties["$twitter_app_country"] = twitterAppTextField.text
        universalObjectProperties["$twitter_player"] = twitterPlayerTextField.text
        universalObjectProperties["$twitter_player_width"] = twitterPlayerWidthTextField.text
        universalObjectProperties["$twitter_player_height"] = twitterPlayerHeightTextField.text
        
        if publiclyIndexableSwitch.on {
            
            universalObjectProperties["$publicly_indexable"] = "1"
        } else {
            universalObjectProperties["$publicly_indexable"] = "0"
        }
        
        universalObjectProperties["$exp_date"] = expDateTextField.text
    }
    
}
