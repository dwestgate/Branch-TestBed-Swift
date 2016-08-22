//
//  LinkPropertiesTableViewController.swift
//  TestBed-Swift
//
//  Created by David Westgate on 8/7/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//

import UIKit

class LinkPropertiesTableViewController: UITableViewController {
    
    @IBOutlet weak var aliasTextField: UITextField!
    @IBOutlet weak var channelTextField: UITextField!
    @IBOutlet weak var featureTextField: UITextField!
    @IBOutlet weak var stageTextField: UITextField!
    @IBOutlet weak var tagsTextField: UITextView!
    @IBOutlet weak var fallbackURLTextField: UITextField!
    @IBOutlet weak var desktopURLTextField: UITextField!
    @IBOutlet weak var androidURLTextField: UITextField!
    @IBOutlet weak var iosURLTextField: UITextField!
    @IBOutlet weak var ipadURLTextField: UITextField!
    @IBOutlet weak var fireURLTextField: UITextField!
    @IBOutlet weak var blackberryURLTextField: UITextField!
    @IBOutlet weak var windowsPhoneURLTextField: UITextField!
    @IBOutlet weak var afterClickURLTextField: UITextField!
    @IBOutlet weak var deeplinkPathTextField: UITextField!
    @IBOutlet weak var alwaysDeeplinkSwitch: UISwitch!
    @IBOutlet weak var matchDurationTextField: UITextField!
    
    var linkProperties = [String: AnyObject]()
    var tags = [String]()
    
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
        aliasTextField.text = linkProperties["alias"] as? String
        channelTextField.text = linkProperties["channel"] as? String
        featureTextField.text = linkProperties["feature"] as? String
        stageTextField.text = linkProperties["stage"] as? String
        // linkProperties["tags"] as! String tags
        fallbackURLTextField.text = linkProperties["fallbackURL"] as? String
        desktopURLTextField.text = linkProperties["desktopURL"] as? String
        androidURLTextField.text = linkProperties["androidURL"] as? String
        iosURLTextField.text = linkProperties["iosURL"] as? String
        ipadURLTextField.text = linkProperties["ipadURl"] as? String
        fireURLTextField.text = linkProperties["fireURL"] as? String
        blackberryURLTextField.text = linkProperties["blackberryURL"] as? String
        windowsPhoneURLTextField.text = linkProperties["windowsPhoneURL"] as? String
        afterClickURLTextField.text = linkProperties["afterClickURL"] as? String
        deeplinkPathTextField.text = linkProperties["deeplinkPath"] as? String
        // alwaysDeeplinkSwitch.on = linkProperties["alwaysDeeplink"] as! Bool
        matchDurationTextField.text = linkProperties["matchDuration"] as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch(indexPath.section,indexPath.row) {
            case (4,0) :
                self.performSegueWithIdentifier("ShowBranchLinkTagsViewController", sender: self)
            default : break
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
