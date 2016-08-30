//
//  DictionaryTableViewController.swift
//  TestBed-Swift
//
//  Created by David Westgate on 8/29/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//
import UIKit

class DictionaryTableViewController: UITableViewController {

    var dictionary = [String: AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionary.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "DictionaryTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DictionaryTableViewCell
        
        let keys = Array(dictionary.keys).sort()
        cell.keyLabel.text = keys[indexPath.row]
        cell.valueLabel.text = self.dictionary[keys[indexPath.row]] as? String

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
            let keys = Array(dictionary.keys)
            dictionary.removeValueForKey(keys[indexPath.row])

            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEnterParameter" {
            let vc = segue.destinationViewController as! KeyValuePairTableViewController
            
            // Get the cell that generated this segue.
            if let selectedCell = sender as? DictionaryTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedCell)!
                let keys = Array(dictionary.keys)
                let selectedParameterKey = keys[indexPath.row]
                let selectedParameterValue = self.dictionary[keys[indexPath.row]] as? String
                vc.incumbantKey = selectedParameterKey
                vc.incumbantValue = selectedParameterValue!
            }
        } else if segue.identifier == "AddItem" {
            /* let vc = segue.destinationViewController as! DictionaryTableViewController
            if let dictionary = linkProperties["tags"] as? [String] {
                vc.array = tags
            }
            print("Adding new key-value pair.")*/
        }
    }
    
    @IBAction func unwindByCancelling(segue:UIStoryboardSegue) { }
    
    @IBAction func unwindKeyValuePairTableViewController(sender: UIStoryboardSegue) {
        if let sourceVC = sender.sourceViewController as? KeyValuePairTableViewController {
            
            guard sourceVC.keyTextField.text!.characters.count > 0 else {
                return
            }
            dictionary[sourceVC.keyTextField.text!] = sourceVC.valueTextView.text
            tableView.reloadData()
        }
    }
    
}
