//
//  CustomDataTableViewController.swift
//  TestBed-Swift
//
//  Created by David Westgate on 8/14/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//

import UIKit

class CustomDataTableViewController: UITableViewController {
    
    var keyValuePairs = [String: AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyValuePairs.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CustomDataTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CustomDataTableViewCell
        
        let keys = Array(keyValuePairs.keys).sort()
        cell.keyLabel.text = keys[indexPath.row]
        cell.valueLabel.text = self.keyValuePairs[keys[indexPath.row]] as? String
        
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let keys = Array(keyValuePairs.keys)
            keyValuePairs.removeValueForKey(keys[indexPath.row])
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    /*
     - (void)addItem:sender {
     if (itemInputController == nil) {
     itemInputController = [[ItemInputController alloc] init];
     }
     UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:itemInputController];
     [[self navigationController] presentModalViewController:navigationController animated:YES];
     }*/
    
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddElement" {
            let keyValuePairsElementViewController = segue.destinationViewController as! EnterCustomDataViewController
            
            // Get the cell that generated this segue.
            if let selectedCell = sender as? CustomDataTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedCell)!
                let keys = Array(keyValuePairs.keys)
                let selectedParameterKey = keys[indexPath.row]
                let selectedParameterValue = self.keyValuePairs[keys[indexPath.row]] as? String
                keyValuePairsElementViewController.incumbantKey = selectedParameterKey
                keyValuePairsElementViewController.incumbantValue = selectedParameterValue
            }
        } else if segue.identifier == "AddItem" {
            print("Adding new key-value pair.")
        }
    }
    // TODO be sure Cancel does not = Save
    @IBAction func unwindEnterCustomDataViewController(sender: UIStoryboardSegue) {
        if let sourceVC = sender.sourceViewController as? EnterCustomDataViewController {
            
            guard sourceVC.keyTextField.text!.characters.count > 0 else {
                return
            }
            keyValuePairs[sourceVC.keyTextField.text!] = sourceVC.valueTextView.text
            tableView.reloadData()
        }
    }
    
}
