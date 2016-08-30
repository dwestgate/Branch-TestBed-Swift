//
//  LinkPropertiesTableViewController.swift
//  TestBed-Swift
//
//  Created by David Westgate on 8/29/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//
import UIKit

class LinkPropertiesTableViewController: UITableViewController {
    
    // MARK: - Controls
    
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
    @IBOutlet weak var typeTextField: UITextField!
    
    var linkProperties = [String: AnyObject]()
    
    // MARK: - Core View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UITableViewCell.appearance().backgroundColor = UIColor.whiteColor()
        refreshControls()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch(indexPath.section) {
            case 4 :
                self.performSegueWithIdentifier("ShowTags", sender: "Tags")
            default : break
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        refreshLinkProperties()
        
        if segue.identifier! == "ShowTags" {
            let vc = segue.destinationViewController as! ArrayTableViewController
            if let tags = linkProperties["tags"] as? [String] {
                vc.array = tags
            }
            vc.viewTitle = "Link Tags"
            vc.sender = sender as! String
            vc.header = "Tag"
            vc.placeholder = "tag"
            vc.footer = "Enter a new tag to associate with the link."
            vc.keyboardType = UIKeyboardType.Default
        }
    }
    
    @IBAction func unwindByCancelling(segue:UIStoryboardSegue) { }
    
    @IBAction func unwindArrayTableViewController(segue:UIStoryboardSegue) {
        if let vc = segue.sourceViewController as? ArrayTableViewController {
            let tags = vc.array
            linkProperties["tags"] = tags
            if tags.count > 0 {
                tagsTextView.text = tags.description
            } else {
                tagsTextView.text = ""
            }
        }
    }
    
    // MARK: - Refresh Functions
    
    func refreshControls() {
        aliasTextField.text = linkProperties["alias"] as? String
        channelTextField.text = linkProperties["channel"] as? String
        featureTextField.text = linkProperties["feature"] as? String
        stageTextField.text = linkProperties["stage"] as? String
        
        if let tags = linkProperties["tags"] as? [String] {
            if tags.count > 0 {
                tagsTextView.text = tags.description
            }
        }
        
        deeplinkPathTextField.text = linkProperties["$deeplink_path"] as? String
        androidDeeplinkPathTextField.text = linkProperties["$android_deeplink_path"] as? String
        iosDeeplinkPathTextField.text = linkProperties["$ios_deeplink_path"] as? String
        iosWeChatURLTextField.text = linkProperties["$ios_wechat_url"] as? String
        iosWeiboURLTextField.text = linkProperties["$ios_weibo_url"] as? String
        
        alwaysDeeplinkSwitch.on = false
        if let alwaysDeeplink = linkProperties["$always_deeplink"] as? String {
            if alwaysDeeplink == "1" {
                alwaysDeeplinkSwitch.on = true
            }
        }
        
        afterClickURLTextField.text = linkProperties["$after_click_url"] as? String
        matchDurationTextField.text = linkProperties["$match_duration"] as? String
        fallbackURLTextField.text = linkProperties["$fallback_url"] as? String
        desktopURLTextField.text = linkProperties["$desktop_url"] as? String
        androidURLTextField.text = linkProperties["$android_url"] as? String
        iosURLTextField.text = linkProperties["$ios_url"] as? String
        ipadURLTextField.text = linkProperties["$ipad_url"] as? String
        fireURLTextField.text = linkProperties["$fire_url"] as? String
        blackberryURLTextField.text = linkProperties["$blackberry_url"] as? String
        windowsPhoneURLTextField.text = linkProperties["$windows_phone_url"] as? String
        typeTextField.text = linkProperties["type"] as? String
    }
    
    func refreshLinkProperties() {
        linkProperties["alias"] = aliasTextField.text
        linkProperties["channel"] = channelTextField.text
        linkProperties["feature"] = featureTextField.text
        linkProperties["stage"] = stageTextField.text
        
        linkProperties["$deeplink_path"] = deeplinkPathTextField.text
        linkProperties["$android_deeplink_path"] = androidDeeplinkPathTextField.text
        linkProperties["$ios_deeplink_path"] = iosDeeplinkPathTextField.text
        linkProperties["$ios_wechat_url"] = iosWeChatURLTextField.text
        linkProperties["$ios_weibo_url"] = iosWeiboURLTextField.text
        
        if alwaysDeeplinkSwitch.on {
            linkProperties["$always_deeplink"] = "1"
        } else {
            linkProperties["$always_deeplink"] = "0"
        }
        
        linkProperties["$after_click_url"] = afterClickURLTextField.text
        linkProperties["$match_duration"] = matchDurationTextField.text
        linkProperties["$fallback_url"] = fallbackURLTextField.text
        linkProperties["$desktop_url"] = desktopURLTextField.text
        linkProperties["$android_url"] = androidURLTextField.text
        linkProperties["$ios_url"] = iosURLTextField.text
        linkProperties["$ipad_url"] = ipadURLTextField.text
        linkProperties["$fire_url"] = fireURLTextField.text
        linkProperties["$blackberry_url"] = blackberryURLTextField.text
        linkProperties["$windows_phone_url"] = windowsPhoneURLTextField.text
        linkProperties["type"] = typeTextField.text
    }
    
}
