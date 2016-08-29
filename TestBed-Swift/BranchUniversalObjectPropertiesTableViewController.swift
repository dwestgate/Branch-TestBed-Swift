//
//  BranchUniversalObjectPropertiesTableViewController.swift
//  TestBed-Swift
//
//  Created by David Westgate on 8/7/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//

import UIKit

class BranchUniversalObjectPropertiesTableViewController: UITableViewController {
    
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
    
    var universalObjectProperties = [String: AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITableViewCell.appearance().backgroundColor = UIColor.whiteColor()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        refreshControls()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
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
        
        switch segue.identifier! {
            case "ShowCustomData":
                let vc = (segue.destinationViewController as! DictionaryTableViewController)
            case "ShowKeywords":
                let vc = segue.destinationViewController as! ArrayTableViewController
                if let keywords = universalObjectProperties["keywords"] as? [String] {
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
    /*
    @IBAction func unwindCustomDataTableViewController(segue:UIStoryboardSegue) {
        if let vc = segue.sourceViewController as? CustomDataTableViewController {
            customData = vc.keyValuePairs
        }
    }*/
    
    
    @IBAction func unwindArrayTableViewController(segue:UIStoryboardSegue) {
        if let vc = segue.sourceViewController as? ArrayTableViewController {
            let keywords = vc.array
            universalObjectProperties["keywords"] = keywords
            if keywords.count > 0 {
                keywordsTextView.text = keywords.description
            } else {
                keywordsTextView.text = ""
            }
        }
    }
    
    
    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
