//
//  ViewController.swift
//  servicestab
//
//  Created by Phoenix on 2016-02-13.
//  Copyright © 2016 Phoenix. All rights reserved.
//

import UIKit
import MapKit

class InfoViewController: UIViewController {
    
    @IBOutlet var desc: UILabel!
    
    @IBOutlet var locationinput: UILabel!
    
    @IBOutlet var hoursinput: UILabel!
    
    @IBOutlet var phoneinput: UILabel!
    
    @IBOutlet var emailinput: UILabel!
    
    @IBOutlet var homepageinput: UIButton!
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    
    
    func GetData() {
        
        let url = NSURL(string: "https://api.uwaterloo.ca/v2/poi/visitorinformation.json?key=2fa6eb226bdc853b6dd71e6f7bd5a822")!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
            if let urlContent = data {
                
                do {
                    
                    let object = try NSJSONSerialization.JSONObjectWithData(urlContent, options: .AllowFragments)
                    
                    if let dictionary = object as? [String: AnyObject]{
                        guard let datas = dictionary["data"] as? [[String: AnyObject]] else {return}
                        
                        for data in datas {
                            
                            guard let tmpname = data["name"] as? String else{break}
                            
                            
                            if tmpname == "Parking Services" {
                                
                                guard let strDesc  = data["description"] as? String,
                                    let strHoursinput = data["opening_hours"] as? String,
                                    let strLocationinput = data["note"] as? String,
                                    let strPhoneinput = data["phone"] as? String,
                                    let strEmailinput = data["email"] as? String,
                                    let strHomepageinput = data["url"] as? String,
                                    let dblLatitude = data["latitude"] as? Double,
                                    let dblLongitude = data["longitude"] as? Double else{break}
                                
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.desc.text =  strDesc
                                    self.hoursinput.text =  strHoursinput
                                    self.locationinput.text =  strLocationinput + "  154"
                                    self.phoneinput.text =  strPhoneinput
                                    self.emailinput.text =  strEmailinput
                                    self.homepageinput.setTitle(strHomepageinput, forState: .Normal)
                                    self.latitude = dblLatitude
                                    self.longitude = dblLongitude
                                })
                                break
                            }
                        }
                    }
                } catch {
                    print("JSON serialization failed")
                }
            }
        }
        task.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "INFO"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterForground", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        GetData()
    
    }
    
    
    func willEnterForground() {
        GetData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        GetData()
    }
    
    @IBAction func homepageDir(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: self.homepageinput.currentTitle! )!)
        print("done")
    }
    
    @IBAction func Direaction(sender: AnyObject) {
        print("done")
        
        let currentLocation = MKMapItem.mapItemForCurrentLocation()
        let markDestLocation = MKPlacemark(coordinate: CLLocationCoordinate2DMake(self.latitude, self.longitude), addressDictionary: nil)
        let destLocation = MKMapItem(placemark: markDestLocation)
        
        destLocation.name = "Parking Services"
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        MKMapItem.openMapsWithItems([currentLocation, destLocation], launchOptions: launchOptions)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

