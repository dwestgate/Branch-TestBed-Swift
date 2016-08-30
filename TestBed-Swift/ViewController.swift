//
//  ViewController.swift
//  TestBed-Swift
//
//  Created by David Westgate on 8/29/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//
import UIKit

class ViewController: UITableViewController {
    
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var rewardsBucketTextField: UITextField!
    @IBOutlet weak var rewardsBalanceOfBucketTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var rewardPointsToRedeemTextField: UITextField!
    @IBOutlet weak var customEventNameTextField: UITextField!
    @IBOutlet weak var customEventMetadataTextView: UITextView!
    
    var linkProperties = [String: AnyObject]()
    var universalObjectProperties = [String: AnyObject]()
    var creditHistory: Array<AnyObject>?
    var customEventMetadata = [String: AnyObject]()
    
    let branchLinkProperties = BranchLinkProperties()
    var branchUniversalObject = BranchUniversalObject()
    
    let feature = "Sharing Feature"
    let desktop_url = "http://branch.io"
    let ios_url = "https://dev.branch.io/getting-started/sdk-integration-guide/guide/ios/"
    let shareText = "Super amazing thing I want to share"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITableViewCell.appearance().backgroundColor = UIColor.whiteColor()
        
        linkTextField.text = ""
        refreshControlValues()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshControlValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch(indexPath.section, indexPath.row) {
        case (0,0) :
            self.performSegueWithIdentifier("ShowTextViewFormNavigationBar", sender: "userID")
        case (1,0) :
            guard linkTextField.text?.characters.count > 0 else {
                break
            }
            UIPasteboard.generalPasteboard().string = linkTextField.text
            showAlert("Link copied to clipboard", withDescription: linkTextField.text!)
        case (1,1) :
            self.performSegueWithIdentifier("ShowLinkPropertiesTableView", sender: "LinkProperties")
        case (1,2) :
            self.performSegueWithIdentifier("ShowBranchUniversalObjectPropertiesTableView", sender: "BranchUniversalObjectProperties")
        case (2,0) :
            self.performSegueWithIdentifier("ShowTextViewFormNavigationBar", sender: "RewardsBucket")
        case (2,3) :
            self.performSegueWithIdentifier("ShowTextViewFormNavigationBar", sender: "RewardPointsToRedeem")
        case (2,5) :
            let branch = Branch.getInstance()
            branch.getCreditHistoryWithCallback { (creditHistory, error) in
                if (error == nil) {
                    self.creditHistory = creditHistory as Array?
                    self.performSegueWithIdentifier("ShowCreditHistoryTableView", sender: "CreditHistory")
                } else {
                    print(String(format: "Branch TestBed: Error retrieving credit history: %@", error.localizedDescription))
                    self.showAlert("Error retrieving credit history", withDescription:error.localizedDescription)
                }
            }
        case (3,0) :
            self.performSegueWithIdentifier("ShowTextViewFormNavigationBar", sender: "CustomEventName")
        case (3,1) :
            self.performSegueWithIdentifier("ShowDictionaryTableView", sender: "CustomEventMetadata")
        case (4,0) :
            let branch = Branch.getInstance()
            let params = branch.getFirstReferringParams()
            let logOutput = String(format:"LatestReferringParams:\n\n%@", params.description)
            
            self.performSegueWithIdentifier("ShowLogOutputView", sender: logOutput)
            print("Branch TestBed: LatestReferringParams:\n", logOutput)
        case (4,1) :
            let branch = Branch.getInstance()
            let params = branch.getFirstReferringParams()
            let logOutput = String(format:"FirstReferringParams:\n\n%@", params.description)
            
            self.performSegueWithIdentifier("ShowLogOutputView", sender: logOutput)
            print("Branch TestBed: FirstReferringParams:\n", logOutput)
        default : break
        }
    }
    
    @IBAction func createBranchLinkButtonTouchUpInside(sender: AnyObject) {
        
        for key in linkProperties.keys {
            setBranchLinkProperty(key)
        }
        
        branchUniversalObject = BranchUniversalObject.init(canonicalIdentifier: universalObjectProperties["canonicalIdentifier"] as! String)
        
        for key in universalObjectProperties.keys {
            setBranchUniversalObjectProperty(key)
        }
        
        branchUniversalObject.getShortUrlWithLinkProperties(branchLinkProperties) { (url, error) in
            if (error == nil) {
                print(url)
                self.linkTextField.text = url
            } else {
                print(String(format: "Branch TestBed: %@", error))
                self.showAlert("Link Creation Failed", withDescription: error.localizedDescription)
            }
            
        }
    }
    
    @IBAction func redeemPointsButtonTouchUpInside(sender: AnyObject) {
        rewardsBalanceOfBucketTextField.hidden = true
        activityIndicator.startAnimating()
        var pointsToRedeem = 5
        
        if rewardPointsToRedeemTextField.text != "" {
            pointsToRedeem = Int(rewardPointsToRedeemTextField.text!)!
        }
        
        let branch = Branch.getInstance()
        branch.redeemRewards(pointsToRedeem, forBucket: rewardsBucketTextField.text) { (changed, error) in
            if (error != nil || !changed) {
                print(String(format: "Branch TestBed: Didn't redeem anything: %@", error))
                self.showAlert("Redemption Unsuccessful", withDescription: error.localizedDescription)
            } else {
                print("Branch TestBed: Five Points Redeemed!")
            }
        }
        rewardsBalanceOfBucketTextField.hidden = false
        activityIndicator.stopAnimating()
    }
    
    @IBAction func reloadBalanceButtonTouchUpInside(sender: AnyObject) {
        refreshRewardsBalanceOfBucket()
    }
    
    @IBAction func sendEventButtonTouchUpInside(sender: AnyObject) {
        var customEventName = "buy"
        let branch = Branch.getInstance()
        
        if customEventNameTextField.text != "" {
            customEventName = customEventNameTextField.text!
        }
        
        if customEventMetadata.count == 0 {
            branch.userCompletedAction(customEventName)
        } else {
            branch.userCompletedAction(customEventName, withState: customEventMetadata)
        }
        refreshRewardsBalanceOfBucket()
        self.showAlert(String(format: "Custom event '%@' dispatched", customEventName), withDescription: "")
    }
    
    @IBAction func showRewardsHistoryButtonTouchUpInside(sender: AnyObject) {
        let branch = Branch.getInstance()
        branch.getCreditHistoryWithCallback { (creditHistory, error) in
            if (error == nil) {
                self.creditHistory = creditHistory as Array?
                self.performSegueWithIdentifier("ShowCreditHistoryTableView", sender: nil)
            } else {
                print(String(format: "Branch TestBed: Error retrieving credit history: %@", error.localizedDescription))
                self.showAlert("Error retrieving credit history", withDescription:error.localizedDescription)
            }
        }
    }
    
    @IBAction func viewFirstReferringParamsButtonTouchUpInside(sender: AnyObject) {
        let branch = Branch.getInstance()
        let params = branch.getFirstReferringParams()
        let logOutput = String(format:"FirstReferringParams:\n\n%@", params.description)
        
        self.performSegueWithIdentifier("ShowLogOutputView", sender: logOutput)
        print("Branch TestBed: FirstReferringParams:\n", logOutput)
    }
    
    @IBAction func viewLatestReferringParamsButtonTouchUpInside(sender: AnyObject) {
        let branch = Branch.getInstance()
        let params = branch.getFirstReferringParams()
        let logOutput = String(format:"LatestReferringParams:\n\n%@", params.description)
        
        self.performSegueWithIdentifier("ShowLogOutputView", sender: logOutput)
        print("Branch TestBed: LatestReferringParams:\n", logOutput)
    }
    
    @IBAction func simulateContentAccessButtonTouchUpInside(sender: AnyObject) {
        self.branchUniversalObject.registerView()
        self.showAlert("Content Access Registered", withDescription: "")
    }
    
    @IBAction func actionButtonTouchUpInside(sender: AnyObject) {
        let linkProperties = BranchLinkProperties()
        linkProperties.feature = feature
        linkProperties.addControlParam("$desktop_url", withValue: desktop_url)
        linkProperties.addControlParam("$ios_url", withValue: ios_url)
        
        branchUniversalObject.addMetadataKey("deeplink_text", value: "This link was generated during Share Sheet sharing")
        
        branchUniversalObject.showShareSheetWithLinkProperties(linkProperties, andShareText: shareText, fromViewController: nil, anchor: actionButton) { (activityType, completed) in
            if (completed) {
                print(String(format: "Branch TestBed: Completed sharing to %@", activityType))
            } else {
                print("Branch TestBed: Link Sharing Failed\n")
                self.showAlert("Link Sharing Failed", withDescription: "")
            }
        }
    }
    
    @IBAction func registerWithSpotlightButtonTouchUpInside(sender: AnyObject) {
        branchUniversalObject.addMetadataKey("deeplink_text", value: "This link was generated for Spotlight registration")
        branchUniversalObject.listOnSpotlightWithIdentifierCallback { (url, spotlightIdentifier, error) in
            if (error == nil) {
                print("Branch TestBed: ShortURL: %@   spotlight ID: %@", url, spotlightIdentifier)
                self.showAlert("Spotlight Registration Succeeded", withDescription: String(format: "Branch Link:\n%@\n\nSpotlight ID:\n%@", url, spotlightIdentifier))
            } else {
                print("Branch TestBed: Error: %@", error.localizedDescription)
                self.showAlert("Spotlight Registration Failed", withDescription: error.localizedDescription)
            }
        }
    }
    
    func textFieldDidChange(sender:UITextField) {
        sender.resignFirstResponder()
    }
    
    func refreshRewardsBalanceOfBucket() {
        rewardsBalanceOfBucketTextField.hidden = true
        activityIndicator.startAnimating()
        let branch = Branch.getInstance()
        branch.loadRewardsWithCallback { (changed, error) in
            if (error == nil) {
                if self.rewardsBucketTextField.text == "" {
                    self.rewardsBalanceOfBucketTextField.text = String(format: "%ld", branch.getCredits())
                } else {
                    self.rewardsBalanceOfBucketTextField.text = String(format: "%ld", branch.getCreditsForBucket(self.rewardsBucketTextField.text))
                }
            }
        }
        activityIndicator.stopAnimating()
        rewardsBalanceOfBucketTextField.hidden = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        linkTextField.text = ""
        
        switch sender as! String {
        case "userID":
            let nc = segue.destinationViewController as! UINavigationController
            let vc = nc.topViewController as! TextViewFormTableViewController
            vc.sender = sender as! String
            vc.viewTitle = "User ID"
            vc.header = "User ID"
            vc.footer = "This User ID (or developer_id) is the application-assigned ID of the user. If not assigned, referrals from links created by the user will show up as 'Anonymous' in reporting."
            vc.keyboardType = UIKeyboardType.Alphabet
            vc.incumbantValue = userIDTextField.text!
        case "LinkProperties":
            let vc = (segue.destinationViewController as! LinkPropertiesTableViewController)
            vc.linkProperties = self.linkProperties
        case "BranchUniversalObjectProperties":
            let vc = (segue.destinationViewController as! BranchUniversalObjectPropertiesTableViewController)
            vc.universalObjectProperties = self.universalObjectProperties
        case "CreditHistory":
            let vc = (segue.destinationViewController as! CreditHistoryViewController)
            vc.creditTransactions = creditHistory
        case "RewardsBucket":
            let nc = segue.destinationViewController as! UINavigationController
            let vc = nc.topViewController as! TextViewFormTableViewController
            vc.sender = sender as! String
            vc.viewTitle = "Rewards Bucket"
            vc.header = "Rewards Bucket"
            vc.footer = "Rewards are granted via rules configured in the Rewards Rules section of the dashboard. Rewards are normally accumulated in a 'default' bucket, however any bucket name can be specified in rewards rules. Use this setting to specify the name of a non-default rewards bucket."
            vc.keyboardType = UIKeyboardType.Alphabet
            vc.incumbantValue = rewardsBucketTextField.text!
        case "RewardPointsToRedeem":
            let nc = segue.destinationViewController as! UINavigationController
            let vc = nc.topViewController as! TextViewFormTableViewController
            vc.sender = sender as! String
            vc.viewTitle = "Reward Points"
            vc.header = "Number of Reward Points to Redeem"
            vc.footer = "This is the quantity of points to subtract from the selected bucket's balance."
            vc.keyboardType = UIKeyboardType.NumberPad
            vc.incumbantValue = rewardPointsToRedeemTextField.text!
        case "CustomEventName":
            let nc = segue.destinationViewController as! UINavigationController
            let vc = nc.topViewController as! TextViewFormTableViewController
            vc.sender = sender as! String
            vc.viewTitle = "Custom Event"
            vc.header = "Custom Event Name"
            vc.footer = "This is the name of the event that is referenced when creating rewards rules and webhooks."
            vc.keyboardType = UIKeyboardType.Alphabet
            vc.incumbantValue = customEventNameTextField.text!
        case "CustomEventMetadata":
            let vc = segue.destinationViewController as! DictionaryTableViewController
            customEventMetadata = TestData.getCustomEventMetadata()
            vc.dictionary = customEventMetadata
        default:
            let vc = (segue.destinationViewController as! LogOutputViewController)
            vc.logOutput = sender as! String
            
        }
    }
    
    @IBAction func unwindTextViewFormTableViewController(segue:UIStoryboardSegue) {

        if let vc = segue.sourceViewController as? TextViewFormTableViewController {
            
            switch vc.sender {
            case "userID":
                    
                if let userID = vc.textView.text {
                    
                    guard self.userIDTextField.text != userID else {
                        return
                    }
                    
                    let branch = Branch.getInstance()
                    
                    guard userID != "" else {
                        
                        branch.logoutWithCallback { (changed, error) in
                            if (error != nil || !changed) {
                                print(String(format: "Branch TestBed: Unable to clear User ID: %@", error))
                                self.showAlert("Error simulating logout", withDescription: error.localizedDescription)
                            } else {
                                print("Branch TestBed: User ID cleared")
                                self.userIDTextField.text = userID
                                self.refreshRewardsBalanceOfBucket()
                            }
                        }
                        return
                    }
                    
                    branch.setIdentity(userID) { (params, error) in
                        if (error == nil) {
                            print(String(format: "Branch TestBed: Identity set: %@", userID))
                            self.userIDTextField.text = userID
                            self.refreshRewardsBalanceOfBucket()
                            
                            let defaultContainer = NSUserDefaults.standardUserDefaults()
                            defaultContainer.setValue(userID, forKey: "userID")
                            
                        } else {
                            print(String(format: "Branch TestBed: Error setting identity: %@", error))
                            self.showAlert("Unable to Set Identity", withDescription:error.localizedDescription)
                        }
                    }
                    
                }
            case "RewardsBucket":
                if let rewardsBucket = vc.textView.text {
                    
                    guard self.rewardsBucketTextField.text != rewardsBucket else {
                        return
                    }
                    TestData.setRewardsBucket(rewardsBucket)
                    self.rewardsBucketTextField.text = rewardsBucket
                    self.refreshRewardsBalanceOfBucket()
                    
                }
            case "RewardPointsToRedeem":
                if let rewardPointsToRedeem = vc.textView.text {
                    
                    guard self.rewardPointsToRedeemTextField.text != rewardPointsToRedeem else {
                        return
                    }
                    TestData.setRewardPointsToRedeem(rewardPointsToRedeem)
                    self.rewardPointsToRedeemTextField.text = rewardPointsToRedeem
                }
            case "CustomEventName":
                if let customEventName = vc.textView.text {
                    
                    guard self.customEventNameTextField.text != customEventName else {
                        return
                    }
                    TestData.setCustomEventName(customEventName)
                    self.customEventNameTextField.text = customEventName
                }
            default: break
            }
        }
    }
    
    @IBAction func unwindByCancelling(segue:UIStoryboardSegue) { }
    
    @IBAction func unwindDictionaryTableViewController(segue:UIStoryboardSegue) {
        if let vc = segue.sourceViewController as? DictionaryTableViewController {
            customEventMetadata = vc.dictionary
            TestData.setCustomEventMetadata(customEventMetadata)
            if customEventMetadata.count > 0 {
                customEventMetadataTextView.text = customEventMetadata.description
            } else {
                customEventMetadataTextView.text = ""
            }
        }
    }
    
    @IBAction func unwindLinkPropertiesTableViewController(segue:UIStoryboardSegue) {
        if let vc = segue.sourceViewController as? LinkPropertiesTableViewController {
            linkProperties = vc.linkProperties
            TestData.setLinkProperties(linkProperties)
        }
    }
    
    @IBAction func unwindBranchUniversalObjectTableViewController(segue:UIStoryboardSegue) {
        if let vc = segue.sourceViewController as? BranchUniversalObjectPropertiesTableViewController {
            universalObjectProperties = vc.universalObjectProperties
            TestData.setUniversalObjectProperties(universalObjectProperties)
        }
    }
    
    func setBranchLinkProperty(key: String) {
        
        guard linkProperties[key] != nil else {
            return
        }
        print(key)
        switch key {
        case "alias":
            branchLinkProperties.alias = linkProperties[key] as! String
        case "channel":
            branchLinkProperties.channel = linkProperties[key] as! String
        case "feature":
            branchLinkProperties.feature = linkProperties[key] as! String
        case "stage":
            branchLinkProperties.stage = linkProperties[key] as! String
        case "tags":
            branchLinkProperties.tags = linkProperties[key] as! [AnyObject]
        case "type":
            branchLinkProperties.addControlParam(BRANCH_LINK_DATA_KEY_TYPE, withValue: linkProperties[key] as! String)
        default:
            branchLinkProperties.addControlParam(key, withValue: linkProperties[key] as! String)
        }
    }
    
    func setBranchUniversalObjectProperty(key: String) {
        
        guard universalObjectProperties[key] != nil else {
            return
        }

        switch key {
        case "$canonical_identifier":
            branchUniversalObject.canonicalIdentifier = universalObjectProperties[key] as! String
        case "$canonical_url":
            branchUniversalObject.canonicalUrl = universalObjectProperties[key] as! String
        case "$content_description":
            branchUniversalObject.contentDescription = universalObjectProperties[key] as! String
        case "$exp_date":
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let expirationDate = dateFormatter.dateFromString(universalObjectProperties[key] as! String)
            branchUniversalObject.expirationDate = expirationDate
        case "$og_image_url":
            branchUniversalObject.imageUrl = universalObjectProperties[key] as! String
        case "$keywords":
            branchUniversalObject.keywords = universalObjectProperties[key] as! [AnyObject]
        case "$og_title":
            branchUniversalObject.title = universalObjectProperties[key] as! String
        case "$og_type":
            branchUniversalObject.type = universalObjectProperties[key] as! String
        case "customData":
            if let data = universalObjectProperties[key] as? [String: String] {
                for customDataKey in data.keys {
                    branchUniversalObject.addMetadataKey(customDataKey, value: data[customDataKey])
                }
            }
        default:
            branchUniversalObject.addMetadataKey(key, value: universalObjectProperties[key] as! String)
        }
    }
    
    func refreshControlValues() {
        // First load the three values required to refresh the rewards balance
        userIDTextField.text = TestData.getUserID()
        rewardsBucketTextField.text = TestData.getRewardsBucket()
        rewardsBalanceOfBucketTextField.text = TestData.getRewardsBalanceOfBucket()
        
        // Then initiate a refresh of the rewards balance
        refreshRewardsBalanceOfBucket()
        
        // Now get about populating the other controls
        linkProperties = TestData.getLinkProperties()
        universalObjectProperties = TestData.getUniversalObjectProperties()
        rewardPointsToRedeemTextField.text = TestData.getRewardPointsToRedeem()
        customEventNameTextField.text = TestData.getCustomEventName()
        customEventMetadata = TestData.getCustomEventMetadata()
        if (customEventMetadata.count > 0) {
            customEventMetadataTextView.text = customEventMetadata.description
        } else {
            customEventMetadataTextView.text = ""
        }
    }
    
    func showAlert(alertTitle: String, withDescription message: String) {
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            self.refreshRewardsBalanceOfBucket()
        }
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
}

