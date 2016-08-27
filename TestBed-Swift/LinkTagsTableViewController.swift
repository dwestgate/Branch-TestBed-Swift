//
//  LinkTagsTableViewController.swift
//  TestBed-Swift
//
//  Created by David Westgate on 8/14/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//

import UIKit

class LinkTagsTableViewController: UITableViewController {
    
    var tags = [String]()
    
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
        return tags.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "LinkTagTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! LinkTagTableViewCell
        print("indexPath.row = \(indexPath.row)")
        print("tags = \(tags.description)")
        
        cell.tagLabel.text = tags[indexPath.row]
        
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
            tags.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // TestData.setLinkTags(linkTags)
        
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
        if segue.identifier == "showEnterParameter" {
            let vc = segue.destinationViewController as! EnterLinkTagViewController
            
            // Get the cell that generated this segue.
            if let selectedCell = sender as? LinkTagTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedCell)!
                
                let selectedParameterTag = self.tags[indexPath.row]
                vc.incumbantTag = selectedParameterTag
            }
        } else if segue.identifier == "AddItem" {
            print("Adding new key-value pair.")
        }
    }
    // TODO be sure Cancel does not = Save
    @IBAction func unwindEnterLinkTagViewController(sender: UIStoryboardSegue) {
        if let vc = sender.sourceViewController as? EnterLinkTagViewController {
            
            guard vc.tagTextField.text!.characters.count > 0 else {
                return
            }
            
            tags.append(vc.tagTextField.text!)
            tableView.reloadData()
        }
    }
    
}
