//
//  AddMessageViewController.swift
//  Help
//
//  Created by demo on 10/13/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import UIKit

protocol AddMessageControllerDelegate{
    func myVCDidFinish(controller:AddMessageViewController,message:String)
}

class AddMessageViewController: UIViewController {

    
    @IBOutlet var messageText: UITextField!


    @IBAction func sendMessageButton(sender: UIButton) {
        
        if(delegate != nil){
            var message = self.messageText.text
            delegate!.myVCDidFinish(self, message:message)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 var delegate: AddMessageControllerDelegate? = nil
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
