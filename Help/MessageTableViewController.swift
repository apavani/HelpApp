//
//  MessageTableViewController.swift
//  Help
//
//  Created by LiQihui on 10/13/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import UIKit
import Foundation

class MessageTableViewController: UITableViewController, UITableViewDataSource, AddMessageControllerDelegate {
    
    var myLatitude : Float!
    var myLongitude : Float!
    var timer : NSTimer!
    
    var users : [UserInfo] = []
    var timeformatter = NSDateFormatter()
    var usersWithinRange : [UserInfo] = []
    var firstTime : Bool = true
    var myID: String!
    var addMessage : PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.timeformatter.dateFormat = "hh:mm"
    }
    
    override func viewDidAppear(animated: Bool) {
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("loadNewData"), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.timer.invalidate()
    }
    
    func loadNewData()
    {
        
        var query = PFQuery(className: "PeopleLocation")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error:NSError!) -> Void in
            if error == nil{
                
                for object in objects{
                    let distanceCalc = DistanceCalculator(lat1: self.myLatitude, lat2: object.objectForKey("Latitude") as Float, lon1: self.myLongitude , lon2: object.objectForKey("Longitude") as Float)
                    var distance : Float = distanceCalc.calculateDistance()
                    
                    if(distance < 100)
                    {
                        var oldCount : Int
                        if(object.objectForKey("oldCount") == nil)
                        {
                            oldCount = 0
                        }
                        else
                        {
                            oldCount = object.objectForKey("oldCount") as Int
                        }
                        
                        var newCount : Int
                        
                        if(object.objectForKey("newCount") == nil)
                        {
                            newCount = 0
                        }
                        else
                        {
                            newCount = object.objectForKey("newCount") as Int
                        }
                        
                        if((oldCount != newCount) || self.firstTime)
                        {
                            var userName : String = object.objectForKey("Name") as String
                            var userMacID : String =  object.objectForKey("DeviceID") as String
                            var messageTimeStamp : String = self.timeformatter.stringFromDate(object.updatedAt)
                            
                            var userMessage : String
                            if(object.objectForKey("Message") == nil)
                            {userMessage = ""}
                            else
                            {userMessage = object.objectForKey("Message") as String}
                            
                            var latitude : Float = object.objectForKey("Latitude") as Float
                            var longitude : Float = object.objectForKey("Longitude") as Float
                            
                            if(self.firstTime)
                            {
                                var updateCount : PFObject = PFObject(className: "PeopleLocation")
                                updateCount = object as PFObject
                                updateCount["oldCount"] = oldCount
                                updateCount["newCount"] = newCount
                                updateCount.saveInBackground()
                            }
                            else
                            {
                                var updateCount : PFObject = PFObject(className: "PeopleLocation")
                                updateCount = object as PFObject
                                updateCount["oldCount"] = object.objectForKey("newCount") as Int
                                updateCount.saveInBackground()
                            }
                            
                            var newUser : UserInfo = UserInfo(name: userName, macID: userMacID, distance: distance, timeStamp: messageTimeStamp, messageText: userMessage, latitude: object.objectForKey("Latitude") as Float, longitude: object.objectForKey("Longitude") as Float, oldCount : oldCount, newCount : newCount)
                            if(!self.firstTime)
                            {
                                self.users.append(newUser)
                            }
                        }
                    }
                }
                self.firstTime = false
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
    
    //help message returned from AddMessageViewController
    func myVCDidFinish(controller:AddMessageViewController,message:String){
//        userInfo = UserInfo(name: <#String#>, macID: <#String#>, distance: <#Float#>, timeStamp: <#String#>, messageText: <#String#>, latitude: <#Float#>, longitude: <#Float#>, oldCount: <#Int#>, newCount: <#Int#>)
        addMessage = PFObject(className: "PeopleLocation")
        
        var query : PFQuery = PFQuery(className: "PeopleLocation")
        query.findObjectsInBackgroundWithBlock({ (objects :[AnyObject]!, error : NSError!) -> Void in
            if error == nil {
                for object in objects
                {
                    //Logic if the MacID is found
                    if((object.objectForKey("DeviceID") as String) == self.myID)
                    {
                        self.addMessage = object as PFObject
                        self.addMessage["Message"] = message
                        self.addMessage["newCount"] = ((object.objectForKey("newCount") as Int)+1)
                        self.addMessage.saveInBackgroundWithBlock{ (Bool, NSError) -> Void in
                            
                            //self.navigationController?.popViewControllerAnimated(true)
                        }
                        break
                    }
                }
            }
            controller.navigationController?.popViewControllerAnimated(true)

        })

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var text:String = segue.identifier as String!
        switch text{
        case "toAddMessage":
            if var secondViewController = segue.destinationViewController as? AddMessageViewController {
                secondViewController.delegate = self
            }
                    
        default:
            break
        }
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
