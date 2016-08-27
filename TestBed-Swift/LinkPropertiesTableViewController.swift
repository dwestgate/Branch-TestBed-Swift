//
//  LinkPropertiesTableViewController.swift
//  TestBed-Swift
//
//  Created by David Westgate on 8/7/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//

import UIKit

class LinkPropertiesTableViewController: UITableViewController {
    
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var aliasTextField: UITextField!
    @IBOutlet weak var channelTextField: UITextField!
    @IBOutlet weak var featureTextField: UITextField!
    @IBOutlet weak var stageTextField: UITextField!
    @IBOutlet weak var tagsTextView: UITextView!
    @IBOutlet weak var deeplinkPathTextField: UITextField!
    @IBOutlet weak var androidDeeplinkPathTextField: UITextField!
    @IBOutlet weak var iosDeeplinkPathTextField: UITextField!
    @IBOutlet weak var iosWeChatURLTextField: UITextField!
    @IBOutlet weak var iosWeiboURLTextField: UITextField!
    @IBOutlet weak var alwaysDeeplinkSwitch: UISwitch!
    @IBOutlet weak var afterClickURLTextField: UITextField!
    @IBOutlet weak var matchDurationTextField: UITextField!
    @IBOutlet weak var fallbackURLTextField: UITextField!
    @IBOutlet weak var desktopURLTextField: UITextField!
    @IBOutlet weak var androidURLTextField: UITextField!
    @IBOutlet weak var iosURLTextField: UITextField!
    @IBOutlet weak var ipadURLTextField: UITextField!
    @IBOutlet weak var fireURLTextField: UITextField!
    @IBOutlet weak var blackberryURLTextField: UITextField!
    @IBOutlet weak var windowsPhoneURLTextField: UITextField!
    
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
        typeTextField.text = linkProperties["type"] as? String
        aliasTextField.text = linkProperties["alias"] as? String
        channelTextField.text = linkProperties["channel"] as? String
        featureTextField.text = linkProperties["feature"] as? String
        stageTextField.text = linkProperties["stage"] as? String
        
        let tags = linkProperties["tags"] as? [String]
        tagsTextView.text = tags?.description
        
        deeplinkPathTextField.text = linkProperties["deeplinkPath"] as? String
        androidDeeplinkPathTextField.text = linkProperties["androidDeeplinkPath"] as? String
        iosDeeplinkPathTextField.text = linkProperties["iosDeeplinkPath"] as? String
        iosWeChatURLTextField.text = linkProperties["iosWeChatURL"] as? String
        iosWeiboURLTextField.text = linkProperties["iosWeiboURL"] as? String

        let alwaysDeeplink = linkProperties["alwaysDeeplink"] as! Int
        if (alwaysDeeplink == 1) {
            alwaysDeeplinkSwitch.on = true
        } else {
            alwaysDeeplinkSwitch.on = false
        }

        afterClickURLTextField.text = linkProperties["afterClickURL"] as? String
        matchDurationTextField.text = linkProperties["matchDuration"] as? String
        fallbackURLTextField.text = linkProperties["fallbackURL"] as? String
        desktopURLTextField.text = linkProperties["desktopURL"] as? String
        androidURLTextField.text = linkProperties["androidURL"] as? String
        iosURLTextField.text = linkProperties["iosURL"] as? String
        ipadURLTextField.text = linkProperties["ipadURl"] as? String
        fireURLTextField.text = linkProperties["fireURL"] as? String
        blackberryURLTextField.text = linkProperties["blackberryURL"] as? String
        windowsPhoneURLTextField.text = linkProperties["windowsPhoneURL"] as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch(indexPath.section,indexPath.row) {
            case (4,0) :
                self.performSegueWithIdentifier("ShowLinkTagsViewController", sender: self)
            default : break
        }
        
    }
    
    
    
    @IBAction func unwindLinkTagsTableViewController(segue:UIStoryboardSegue) {
        if let vc = segue.sourceViewController as? LinkTagsTableViewController {
            tags = vc.tags
            self.tagsTextView.text = tags.description
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        linkProperties["type"] = typeTextField.text
        linkProperties["alias"] = aliasTextField.text
        linkProperties["channel"] = channelTextField.text
        linkProperties["feature"] = featureTextField.text
        linkProperties["stage"] = stageTextField.text
        linkProperties["tags"] = tags
        linkProperties["deeplinkPath"] = deeplinkPathTextField.text
        linkProperties["androidDeeplinkPath"] = androidDeeplinkPathTextField.text
        linkProperties["iosDeeplinkPath"] = iosDeeplinkPathTextField.text
        linkProperties["iosWeChatURL"] = iosWeChatURLTextField.text
        linkProperties["iosWeiboURL"] = iosWeiboURLTextField.text
        
        if alwaysDeeplinkSwitch.on {
            linkProperties["alwaysDeeplink"] = 1
        } else {
            linkProperties["alwaysDeeplink"] = 0
        }
        
        linkProperties["afterClickURL"] = afterClickURLTextField.text
        linkProperties["matchDuration"] = matchDurationTextField.text
        linkProperties["fallbackURL"] = fallbackURLTextField.text
        linkProperties["desktopURL"] = desktopURLTextField.text
        linkProperties["androidURL"] = androidURLTextField.text
        linkProperties["iosURL"] = iosURLTextField.text
        linkProperties["ipadURl"] = ipadURLTextField.text
        linkProperties["fireURL"] = fireURLTextField.text
        linkProperties["blackberryURL"] = blackberryURLTextField.text
        linkProperties["windowsPhoneURL"] = windowsPhoneURLTextField.text
    }
    

}
