//
//  AddMessageViewController.swift
//  Help
//
//  Created by demo on 10/13/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import UIKit

class AddMessageViewController: UIViewController {

    
    var myID : String!
    var addMessage : PFObject!
    @IBOutlet var messageText: UITextField!

    @IBAction func sendMessageButton(sender: UIButton) {
        addMessage = PFObject(className: "PeopleLocation")
        
        var query : PFQuery = PFQuery(className: "PeopleLocation")
        query.findObjectsInBackgroundWithBlock({ (objects :[AnyObject]!, error : NSError!) -> Void in
            if error == nil {
        for object in objects
        {
            //Logic if the MacID is found
            if((object.objectForKey("DeviceID") as? String) == self.myID)
            {
                self.addMessage = object as PFObject
                self.addMessage["DeviceID"] = self.myID
                self.addMessage["newCount"] = ((object.objectForKey("newCount") as Int)+1)
                self.addMessage.saveInBackgroundWithBlock{ (Bool, NSError) -> Void in
                //self.navigationController?.popViewControllerAnimated(true)
                }
            }
            break
        }
        }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
