//
//  TableViewController.swift
//  Help
//
//  Created by Adarshkumar Pavani on 10/12/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import UIKit
import Foundation

class TableViewController: UITableViewController, UITableViewDataSource {

    var users : [UserInfo] = []
    var timeformatter = NSDateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.timeformatter.dateFormat = "hh:mm"
        loadNewData()
    }

    
    func loadNewData()
    {
        var query = PFQuery(className: "PeopleLocation")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error:NSError!) -> Void in
            if error == nil{
                if(self.users.count>0)
                {
                    self.users.removeAll(keepCapacity: false)
                }
                
                for object in objects{
                    var userName : String? = object.objectForKey("Name") as? String!
                    var userMacID : String =  object.objectForKey("DeviceID") as String
                    var messageTimeStamp : String = self.timeformatter.stringFromDate(object.updatedAt)
                    var userMessage : String = object.objectForKey("Message") as String
                    var newUser : UserInfo = UserInfo(name: userName!, macID: userMacID, distance: 0, timeStamp: messageTimeStamp, messageText: userMessage)
                    
                    self.users.append(newUser)
                }
                self.tableView.reloadData()
            }
        }
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.users.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("chatMessage") as? TableViewCell ?? TableViewCell()
        var user = self.users[indexPath.row]
        
        cell.nameField.text = user.name
        cell.timeStamp.text = user.timeStamp
        cell.messageText.text = user.messageText
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
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
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
