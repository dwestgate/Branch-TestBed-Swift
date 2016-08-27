//
//  ViewController.swift
//  TestBed-Swift
//
//  Created by David Westgate on 5/26/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//
import UIKit

class ViewController: UITableViewController {
    
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var linkPropertiesTextView: UITextView!
    @IBOutlet weak var rewardsBucketTextField: UITextField!
    @IBOutlet weak var rewardsBalanceOfBucketTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var rewardPointsToRedeemTextField: UITextField!
    @IBOutlet weak var customEventNameTextField: UITextField!
    @IBOutlet weak var customEventMetadataTextView: UITextView!
    
    // let defaultContainer = NSUserDefaults.standardUserDefaults()
    var linkProperties = [String: AnyObject]()
    var universalObjectProperties = [String: AnyObject]()
    var creditHistory: Array<AnyObject>?
    var customEventMetadata = [String: AnyObject]()
    
    var branchUniversalObject = BranchUniversalObject()
    
    let canonicalIdentifier = "item/12345"
    let canonicalUrl = "https://dev.branch.io/getting-started/deep-link-routing/guide/ios/"
    let contentTitle = "Content Title"
    let contentDescription = "My Content Description"
    let imageUrl = "https://pbs.twimg.com/profile_images/658759610220703744/IO1HUADP.png"
    let feature = "Sharing Feature"
    let channel = "Distribution Channel"
    let desktop_url = "http://branch.io"
    let ios_url = "https://dev.branch.io/getting-started/sdk-integration-guide/guide/ios/"
    let shareText = "Super amazing thing I want to share"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITableViewCell.appearance().backgroundColor = UIColor.whiteColor()
        
        self.refreshControlValues()
        
        // let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        // self.tableView.addGestureRecognizer(gestureRecognizer)
        
        branchUniversalObject = BranchUniversalObject.init(canonicalIdentifier: canonicalIdentifier)
        branchUniversalObject.canonicalUrl = canonicalUrl
        branchUniversalObject.title = contentTitle
        branchUniversalObject.contentDescription = contentDescription
        branchUniversalObject.imageUrl  = imageUrl
        branchUniversalObject.addMetadataKey("deeplink_text", value: String(format: "This text was embedded as data in a Branch link with the following characteristics:\n\n  canonicalUrl: %@\n  title: %@\n  contentDescription: %@\n  imageUrl: %@\n", canonicalUrl, contentTitle, contentDescription, imageUrl))

        
        /* if let userID = defaultContainer.valueForKey("userID") as! String? {
            self.userIDTextField.text = userID
        }*/


        
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
        linkPropertiesTextView.text = linkProperties.description
        rewardPointsToRedeemTextField.text = TestData.getRewardPointsToRedeem()
        customEventNameTextField.text = TestData.getCustomEventName()
        customEventMetadata = TestData.getCustomEventMetadata()
        customEventMetadataTextView.text = customEventMetadata.description
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
            self.performSegueWithIdentifier("ShowRewardsBucketViewController", sender: "userID")
        case (1,0) :
            guard linkTextField.text?.characters.count > 0 else {
                break
            }
            UIPasteboard.generalPasteboard().string = linkTextField.text
            showAlert("Link copied to clipboard", withDescription: linkTextField.text!)
        case (1,1) :
            self.performSegueWithIdentifier("ShowLinkPropertiesTableViewController", sender: "LinkProperties")
        case (1,2) :
            self.performSegueWithIdentifier("ShowBranchUniversalObjectPropertiesTableViewController", sender: "BranchUniversalObjectProperties")
        case (2,0) :
            self.performSegueWithIdentifier("ShowRewardsBucketViewController", sender: "RewardsBucket")
        case (2,3) :
            self.performSegueWithIdentifier("ShowRewardsBucketViewController", sender: "RewardPointsToRedeem")
        case (2,5) :
            let branch = Branch.getInstance()
            branch.getCreditHistoryWithCallback { (creditHistory, error) in
                if (error == nil) {
                    self.creditHistory = creditHistory as Array?
                    self.performSegueWithIdentifier("ShowCreditHistoryViewController", sender: "CreditHistory")
                } else {
                    print(String(format: "Branch TestBed: Error retrieving credit history: %@", error.localizedDescription))
                    self.showAlert("Error retrieving credit history", withDescription:error.localizedDescription)
                }
            }
        case (3,0) :
            self.performSegueWithIdentifier("ShowRewardsBucketViewController", sender: "CustomEventName")
        case (3,1) :
            self.performSegueWithIdentifier("ShowCustomEventMetadataViewController", sender: "CustomEventMetadata")
        case (4,0) :
            let branch = Branch.getInstance()
            let params = branch.getFirstReferringParams()
            let logOutput = String(format:"LatestReferringParams:\n\n%@", params.description)
            
            self.performSegueWithIdentifier("ShowLogOutputViewController", sender: logOutput)
            print("Branch TestBed: LatestReferringParams:\n", logOutput)
        case (4,1) :
            let branch = Branch.getInstance()
            let params = branch.getFirstReferringParams()
            let logOutput = String(format:"FirstReferringParams:\n\n%@", params.description)
            
            self.performSegueWithIdentifier("ShowLogOutputViewController", sender: logOutput)
            print("Branch TestBed: FirstReferringParams:\n", logOutput)
        default : break
        }
        
    }

    
    @IBAction func createBranchLinkButtonTouchUpInside(sender: AnyObject) {
        let branchLinkProperties = BranchLinkProperties()

        branchLinkProperties.addControlParam("type", withValue: linkProperties["type"] as! String)
        branchLinkProperties.alias = linkProperties["alias"] as! String
        branchLinkProperties.channel = linkProperties["channel"] as! String
        branchLinkProperties.feature = linkProperties["feature"] as! String
        branchLinkProperties.stage = linkProperties["stage"] as! String
        branchLinkProperties.tags = linkProperties["tags"] as! [AnyObject]
        branchLinkProperties.addControlParam("$deeplink_path", withValue: linkProperties["deeplinkPath"] as! String)
        branchLinkProperties.addControlParam("$android_deeplink_path", withValue: linkProperties["androidDeeplinkPath"] as! String)
        branchLinkProperties.addControlParam("$ios_deeplink_path", withValue: linkProperties["iosDeeplinkPath"] as! String)
        branchLinkProperties.addControlParam("$ios_wechat_url", withValue: linkProperties["iosWeChatURL"] as! String)
        branchLinkProperties.addControlParam("$ios_weibo_url", withValue: linkProperties["iosWeiboURL"] as! String)
        
        
        branchLinkProperties.addControlParam("$fallback_url", withValue: linkProperties["fallbackURL"] as! String)
        branchLinkProperties.addControlParam("$desktop_url", withValue: linkProperties["desktopURL"] as! String)
        branchLinkProperties.addControlParam("$android_url", withValue: linkProperties["androidURL"] as! String)
        branchLinkProperties.addControlParam("$ios_url", withValue: linkProperties["iosURL"] as! String)
        branchLinkProperties.addControlParam("$ipad_url", withValue: linkProperties["ipadURl"] as! String)
        branchLinkProperties.addControlParam("$fire_url", withValue: linkProperties["fireURL"] as! String)
        branchLinkProperties.addControlParam("$blackberry_url", withValue: linkProperties["blackberryURL"] as! String)
        branchLinkProperties.addControlParam("$windows_phone_url", withValue: linkProperties["windowsPhoneURL"] as! String)
        branchLinkProperties.addControlParam("$after_click_url", withValue: linkProperties["afterClickURL"] as! String)
        if (linkProperties["alwaysDeeplink"] as! Bool) {
            branchLinkProperties.addControlParam("$always_deeplink", withValue: "true")
        } else {
            branchLinkProperties.addControlParam("$always_deeplink", withValue: "0")
        }
        branchLinkProperties.matchDuration = linkProperties["matchDuration"] as! UInt
        
        
        print(branchLinkProperties.description())
        print(branchUniversalObject.description())
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
    
    /*@IBAction func simulateLogoutButtonTouchUpInside(sender: AnyObject) {
        let branch = Branch.getInstance()
        branch.logoutWithCallback { (changed, error) in
            if (error != nil || !changed) {
                print(String(format: "Branch TestBed: Logout failed: %@", error))
                self.showAlert("Error simulating logout", withDescription: error.localizedDescription)
            } else {
                print("Branch TestBed: Logout succeeded")
                self.showAlert("Logout succeeded", withDescription: "")
                self.refreshRewardsBalanceOfBucket()
            }
        }

    }*/
    
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
    
    /*
    @IBAction func sendComplexEventButtonTouchUpInside(sender: AnyObject) {
        self.performSegueWithIdentifier("ShowBranchLink", sender: nil)
        
        let eventDetails = ["name": user_id1, "integer": 1, "boolean": true, "float": 3.14159265359, "test_key": test_key]
        let branch = Branch.getInstance()
        branch.userCompletedAction("buy", withState: eventDetails as [NSObject : AnyObject])
        let logOutput = String(format: "Branch Link Details:\n\n%@", eventDetails.description)
        self.performSegueWithIdentifier("ShowLogOutputViewController", sender: logOutput)
        
    }*/
    
    @IBAction func showRewardsHistoryButtonTouchUpInside(sender: AnyObject) {
        let branch = Branch.getInstance()
        branch.getCreditHistoryWithCallback { (creditHistory, error) in
            if (error == nil) {
                self.creditHistory = creditHistory as Array?
                self.performSegueWithIdentifier("ShowCreditHistoryViewController", sender: nil)
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
        
        self.performSegueWithIdentifier("ShowLogOutputViewController", sender: logOutput)
        print("Branch TestBed: FirstReferringParams:\n", logOutput)
    }
    
    
    @IBAction func viewLatestReferringParamsButtonTouchUpInside(sender: AnyObject) {
        let branch = Branch.getInstance()
        let params = branch.getFirstReferringParams()
        let logOutput = String(format:"LatestReferringParams:\n\n%@", params.description)
        
        self.performSegueWithIdentifier("ShowLogOutputViewController", sender: logOutput)
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
    
    
    //example using callbackWithURLandSpotlightIdentifier
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
    
    
    //MARK: Resign First Responder
    /* func hideKeyboard() {
        if (self.branchLinkTextField.isFirstResponder()) {
            self.branchLinkTextField.resignFirstResponder();
        }
    }*/
    
    
    func showAlert(alertTitle: String, withDescription message: String) {
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            self.refreshRewardsBalanceOfBucket()
        }
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch sender as! String {
        case "userID":
            let nc = segue.destinationViewController as! UINavigationController
            let vc = nc.topViewController as! RewardsBucketViewController
            vc.header = "User ID"
            vc.footer = "This User ID (or developer_id) is the application-assigned ID of the user. If not assigned, referrals from links created by the user will show up as 'anonymous' in reporting."
            vc.keyboardType = UIKeyboardType.Alphabet
            vc.incumbantRewardsBucket = userIDTextField.text
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
            let vc = nc.topViewController as! RewardsBucketViewController
            vc.header = "Rewards Bucket"
            vc.footer = "Rewards are granted via rules configured in the Rewards Rules section of the dashboard. Rewards are normally accumulated in a 'default' bucket, however any bucket name can be specified in rewards rules. Use this setting to specify the name of a non-default rewards bucket."
            vc.keyboardType = UIKeyboardType.Alphabet
            vc.incumbantRewardsBucket = rewardsBucketTextField.text
        case "RewardPointsToRedeem":
            let nc = segue.destinationViewController as! UINavigationController
            let vc = nc.topViewController as! RewardsBucketViewController
            vc.header = "Number of Reward Points to Redeem"
            vc.footer = "This is the quantity of points to subtract from the selected bucket's balance."
            vc.keyboardType = UIKeyboardType.DecimalPad
            vc.incumbantRewardsBucket = rewardPointsToRedeemTextField.text
        case "CustomEventName":
            let nc = segue.destinationViewController as! UINavigationController
            let vc = nc.topViewController as! RewardsBucketViewController
            vc.header = "Custom Event Name"
            vc.footer = "This is the name of the event that is referenced when creating rewards rules and webhooks."
            vc.keyboardType = UIKeyboardType.Alphabet
            vc.incumbantRewardsBucket = customEventNameTextField.text
        case "CustomEventMetadata":
            let vc = (segue.destinationViewController as! CustomEventMetadataTableViewController)
            vc.parameterName = "CustomEventMetadata"
        default:
            let vc = (segue.destinationViewController as! LogOutputViewController)
            vc.logOutput = sender as! String
            
        }
        
    }
    
    // This is where we call setIdentity
    @IBAction func unwindUserIDViewController(segue:UIStoryboardSegue) {
        if let viewController = segue.sourceViewController as? UserIDViewController {
            
            if let userID = viewController.userIDTextView.text {
                
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
        }
    }

    @IBAction func unwindRewardsBucketViewController(segue:UIStoryboardSegue) {
        if let vc = segue.sourceViewController as? RewardsBucketViewController {
            
            switch vc.header {
            case "User ID":
                    
                if let userID = vc.rewardsBucketTextView.text {
                    
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
            case "Rewards Bucket":
                if let rewardsBucket = vc.rewardsBucketTextView.text {
                    
                    guard self.rewardsBucketTextField.text != rewardsBucket else {
                        return
                    }
                    TestData.setRewardsBucket(rewardsBucket)
                    self.rewardsBucketTextField.text = rewardsBucket
                    self.refreshRewardsBalanceOfBucket()
                    
                }
            case "Reward Points to Redeem":
                if let rewardPointsToRedeem = vc.rewardsBucketTextView.text {
                    
                    guard self.rewardPointsToRedeemTextField.text != rewardPointsToRedeem else {
                        return
                    }
                    TestData.setRewardPointsToRedeem(rewardPointsToRedeem)
                    self.rewardPointsToRedeemTextField.text = rewardPointsToRedeem
                }
            case "Custom Event Name":
                if let customEventName = vc.rewardsBucketTextView.text {
                    
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
    
    @IBAction func unwindCustomEventMetadataTableViewController(segue:UIStoryboardSegue) {
        if let vc = segue.sourceViewController as? CustomEventMetadataTableViewController {
            if (vc.parameterName == "CustomEventMetadata") {
                customEventMetadata = vc.customEventMetadata
                self.customEventMetadataTextView.text = customEventMetadata.description
            }
        }
    }
    
    @IBAction func unwindLinkPropertiesTableViewController(segue:UIStoryboardSegue) {
        if let vc = segue.sourceViewController as? LinkPropertiesTableViewController {
            linkProperties = vc.linkProperties
            
            TestData.setLinkProperties(linkProperties)
            self.linkPropertiesTextView.text = linkProperties.description
        }
    }
    
}

