//
//  MapViewController.swift
//  YelpForBathrooms
//
//  Created by Vince Ly on 11/21/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
// MARK: - PROPERTIES

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchTextField: UITextField!
    var model: Int = 1219
    let locationManager = CLLocationManager()
    let bathroomRetriever : IBathroomRetriever = BathroomRetriever()
    var logged_in = true

// MARK: - LIFECYCLE FUNCTIONS

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        searchTextField.delegate = self
        mapView.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
// MARK: - VIEW CONTROLLER
    
    @IBAction func openProfileScreen() {
        
        if UserManager.sharedInstance.IsSignedIn {
            self.performSegueWithIdentifier("profileSegue", sender: self)
        }
        else
        {
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
    }
    
    func keyboardWillShow(notification: NSNotification){
        adjustViewForKeyboard(true, notification: notification)
    }
    
    func keyboardWillHide(notification: NSNotification){
        adjustViewForKeyboard(false, notification: notification)
    }
    
    func adjustViewForKeyboard(show: Bool, notification: NSNotification){
        let userInfo = notification.userInfo ??  [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let adjustmentHeight = (CGRectGetHeight(keyboardFrame)*(show ? -1:1))
        self.view.frame.origin.y += adjustmentHeight
    }
    
// MARK: - NAVIGATION
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let segueIdentifier = segue.identifier{
            switch segueIdentifier{
            case "profileSegue":
                let profileViewController = segue.destinationViewController as! ProfileViewController
                profileViewController.model = model;
            default:
                NOOP("UNREACHABLE")
            }
        }
    }
// MARK: - CLLOCATION MANAGER DELEGATE
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true

        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
            populateMapWithBathrooms()
        }
    }

// MARK: - GMSMapViewDelgate methods
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        let infoWindow = NSBundle.mainBundle().loadNibNamed("BathroomSnippetView", owner: self, options: nil).first! as! BathroomSnippetView
        let bathroom = marker.userData as! Bathroom
        infoWindow.title.text = bathroom.title
        infoWindow.rating.text = bathroom.rating.description
        infoWindow.flags.text = bathroom.flags.map{"\($0.DESCRIPTION)"}.reduce("", combine: {$0 + " " + $1})
        return infoWindow
    }
// MARK: - BATHROOM MGMT
    func populateMapWithBathrooms(){
        print("Populating map with bathrooms: ")
        mapView.clear()
        bathroomRetriever.GetBathrooms(mapView.projection.visibleRegion()){
            bathrooms in
            print("Received bathrooms: \(bathrooms)")
            for bathroom in bathrooms! {
                print("Bathroom : \(bathroom.title)")
                let marker = GMSMarker(position: bathroom.location)
                marker.userData = bathroom
                marker.map = self.mapView
            }
        }
    }
    
    @IBAction func addBathroom() {
        NOOP("TODO")
    }
}

extension MapViewController: UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

