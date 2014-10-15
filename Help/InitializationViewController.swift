//
//  InitializationViewController.swift
//  Help
//
//  Created by demo on 10/12/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import CoreLocation
import UIKit

class InitializationViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var name: UITextField!
    @IBOutlet var initializationView: UIView!

    var tap: UITapGestureRecognizer!
    var locationManager : CLLocationManager!
    var myLatitude : CLLocationDegrees!
    var myLongitude : CLLocationDegrees!
    var myObject : PFObject!
    var myID : String!
    //var timer : NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        
        //Tap Gesture Recognizer
        self.tap=UITapGestureRecognizer()
        setup()
    }
    
    override func viewDidAppear(animated: Bool) {
     NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("startUpdatingLocation"), userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func startUpdatingLocation()
    {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(self.name.text=="")
        {
            self.showNullAlert()
            return
        }
        else
        {
            //Stuff to do before you segue
            myObject["Name"] = self.name.text
            myObject.saveInBackground()
            
            
            switch segue.identifier {
            case "toIMController":
                if var nextViewController = segue.destinationViewController as? MessageTableViewController {
                    nextViewController.myLatitude = (self.myLatitude.description as NSString).floatValue
                    nextViewController.myLongitude = (self.myLongitude.description as NSString).floatValue
                    nextViewController.myID = self.myID
                }
            
                
            default:
                break
        }

        }
        
    }
    
    func showNullAlert(){
    var alert = UIAlertController(title: "Name Field Is Left Blank", message: "Please enter a name first, and then press continue", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func setup()
    {
        self.initializationView.addGestureRecognizer(self.tap)
        self.tap.addTarget(self, action: "tapped:")
    }
    
    func tapped(sender: UIGestureRecognizer)
    {
    self.view.endEditing(true)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        // Most recent updates are appended to end of array,
        // so find the most recent update in last index.
        var loc : CLLocation = locations?[locations.count - 1] as CLLocation
        
        // The location stored as a coordinate.
        var coord : CLLocationCoordinate2D = loc.coordinate
        
        // Set the coordinates of location.
        self.myLatitude = coord.latitude
        self.myLongitude = coord.longitude
        // Tell location manager to stop collecting and updating location.
        self.locationManager.stopUpdatingLocation()
        
        //Setting other variables in the PFObject
        
        
        let deviceID =  IdentityGenerator()
        
        self.myID = deviceID.identifierForVendor.UUIDString as String
        verifyAndRegisterDevice(deviceID: self.myID)
        
    }

    func verifyAndRegisterDevice(deviceID ID:String!) -> Void{
    
        var addLocation : PFObject = PFObject(className: "PeopleLocation")
        
        var query : PFQuery = PFQuery(className: "PeopleLocation")
        query.findObjectsInBackgroundWithBlock({ (objects :[AnyObject]!, error : NSError!) -> Void in
            if error == nil {
                for object in objects
                {
                    //Logic if the MacID is found
                    if((object.objectForKey("DeviceID") as? String) == ID)
                    {
                        addLocation = object as PFObject
                        addLocation["Latitude"] = (self.myLatitude.description as NSString).floatValue
                        addLocation["Longitude"] = (self.myLongitude.description as NSString).floatValue
                        
                        self.myObject = addLocation
                        addLocation.saveInBackground()
                        return
                    }
                }
                
                //Logic if the registered MacID is not found
                println(ID+" "+self.myLatitude.description+self.myLongitude.description)
                addLocation["DeviceID"] = ID
                addLocation["Latitude"] = (self.myLatitude.description as NSString).floatValue
                addLocation["Longitude"] = (self.myLongitude.description as NSString).floatValue
                
                self.myObject = addLocation
                addLocation.saveInBackground()
                
            }
        })
    }
}
