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
import GooglePlacesAutocomplete

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
// MARK: - PROPERTIES

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchTextField: UITextField!
    var searchAddress : String = ""
    var model: Int = 1219
    let locationManager = CLLocationManager()
    let bathroomRetriever : IBathroomRetriever = BathroomRetriever()
    let gpaViewController = GooglePlacesAutocomplete(apiKey: ConfigManager.GOOGLE_PLACES_API_KEY, placeType: .Address)
    var logged_in = true

// MARK: - LIFECYCLE FUNCTIONS

    override func viewDidLoad() {
        super.viewDidLoad()
       
        gpaViewController.placeDelegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
// MARK: - VIEW CONTROLLER
    @IBAction func searchBathrooms(sender: UIButton) {
        populateMapWithBathrooms()
    }
    
    @IBAction func searchAddress(sender: UIButton) {
        presentViewController(gpaViewController, animated: true, completion: nil)
    }
    
    @IBAction func openProfileScreen() {
        
        if UserManager.sharedInstance.IsSignedIn {
            self.performSegueWithIdentifier("profileSegue", sender: self)
        }
        else
        {
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
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
        infoWindow.rating.text = bathroom.rating?.description
        infoWindow.flags.text = bathroom.flags?.map{"\($0.DESCRIPTION)"}.reduce("", combine: {$0 + " " + $1})
        return infoWindow
    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        performSegueWithIdentifier("bathroomDetailsSegue", sender: marker)
    }

// MARK: - BATHROOM MGMT
    func populateMapWithBathrooms(){
        print("Populating map with bathrooms: ")
        mapView.clear()
        bathroomRetriever.GetBathrooms(mapView.projection.visibleRegion()){
            bathrooms in
            print("Received bathrooms: \(bathrooms)")
            if let bathrooms = bathrooms{
                for bathroom in bathrooms {
                    print("Bathroom : \(bathroom.title)")
                    let marker = GMSMarker(position: bathroom.location)
                    marker.userData = bathroom
                    marker.map = self.mapView
                }
            }
        }
    }
    
    @IBAction func addBathroom() {
        performSegueWithIdentifier("addBathroomSegue", sender: self)
    }
}

extension MapViewController: UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension MapViewController: GooglePlacesAutocompleteDelegate {
    func placeSelected(place: Place) {
        print(place.description)
        place.getDetails{ (placeDetails) in
            self.mapView.animateToLocation(CLLocationCoordinate2D(latitude: placeDetails.latitude, longitude: placeDetails.longitude))
            self.populateMapWithBathrooms()
            self.searchAddress = placeDetails.description
        }
        place.getDetails { details in
            print(details)
        }
        placeViewClosed()
    }
    
    func placeViewClosed() {
        dismissViewControllerAnimated(true, completion: nil)
        populateMapWithBathrooms()
    }
}
