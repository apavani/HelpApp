//
//  InitializationViewController.swift
//  Help
//
//  Created by demo on 10/12/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import UIKit

class InitializationViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var name: UITextField!
    @IBOutlet var initializationView: UIView!

    var tap: UITapGestureRecognizer!
    var locationManager : CLLocationManager!
    var myLatitude : CLLocationDegrees!
    var myLongitude : CLLocationDegrees!
    
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
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(self.name.text=="")
        {
            self.showNullAlert()
            return
        }
        else
        {
            switch segue.identifier {
            case "toIMController":
                if var firstViewController = segue.destinationViewController as? FirstViewController {
                    firstViewController.myName = self.name.text
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
        
        verifyAndRegisterDevice(deviceID: deviceID.identifierForVendor.description)
        
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
                    }
                }
                
                //Logic if the registered MacID is not found
                addLocation["DeviceID"] = ID
                addLocation["Latitude"] = (self.myLatitude.description as NSString).floatValue
                addLocation["Longitude"] = (self.myLongitude.description as NSString).floatValue
                
            }
        })
        addLocation.saveInBackground()
    }
}
