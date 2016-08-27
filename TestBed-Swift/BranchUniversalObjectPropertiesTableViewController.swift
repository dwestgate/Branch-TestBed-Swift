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
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentDescriptionTextView: UITextView!
    @IBOutlet weak var imageURLTextField: UITextField!
    @IBOutlet weak var ogImageWidth: UITextField!
    @IBOutlet weak var ogImageHeight: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
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
    @IBOutlet weak var expirationDateTextField: UITextField!
    
    var universalObjectProperties = [String: AnyObject]()
    var customData = [String: AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITableViewCell.appearance().backgroundColor = UIColor.whiteColor()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch(indexPath.section) {
        case 2 :
            self.performSegueWithIdentifier("ShowCustomData", sender: self)
        case 3 :
            self.performSegueWithIdentifier("ShowKeywordsViewController", sender: self)
        default : break
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            case "ShowCustomData":
                let vc = (segue.destinationViewController as! CustomEventMetadataTableViewController)
                vc.parameterName = "CustomData"
            default:
                let vc = (segue.destinationViewController as! LogOutputViewController)
                vc.logOutput = sender as! String
            
        }
        
    }
    
    @IBAction func unwindCustomEventMetadataTableViewController(segue:UIStoryboardSegue) {
        if let vc = segue.sourceViewController as? CustomEventMetadataTableViewController {
            if (vc.parameterName == "CustomData") {
                customData = vc.customEventMetadata
                self.customDataTextView.text = customData.description
            }
        }
    }
    
    @IBAction func unwindCustomDataTableViewController(segue:UIStoryboardSegue) {
        if let vc = segue.sourceViewController as? CustomDataTableViewController {
            customData = vc.keyValuePairs
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
