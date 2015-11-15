//
//  MapViewController.swift
//  YelpForBathrooms
//
//  Created by Vince Ly on 11/21/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import UIKit
import GoogleMaps
<<<<<<< HEAD
import Alamofire
import GooglePlacesAutocomplete

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GIDSignInUIDelegate, GIDSignInDelegate{
=======

class MapViewController: UIViewController, CLLocationManagerDelegate {
>>>>>>> Removed .DS_Store from repository
    
// MARK: - PROPERTIES

    @IBOutlet weak var mapView: GMSMapView!
<<<<<<< HEAD
    @IBOutlet weak var buttonBackground: UIView!
    @IBOutlet weak var searchAreaButton: UIButton!
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var searchAddressButton: UIButton!
    
    var searchAddress : String = ""
    let locationManager = CLLocationManager()
    let bathroomRetriever : IBathroomRetriever = BathroomRetriever()
    let profileRetriever : IProfileRetriever = ProfileRetriever()
    let gpaViewController = GooglePlacesAutocomplete(apiKey: ConfigManager.GOOGLE_PLACES_API_KEY, placeType: .Address)
=======
    var model: Int = 1219
    let locationManager = CLLocationManager()
    var logged_in = true
>>>>>>> Removed .DS_Store from repository

// MARK: - LIFECYCLE FUNCTIONS

    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
        styleButtonBackground()
        styleNavigationBar()
        styleButtons()
        styleDivider()
        styleGooglePlacesAutoCompleteBar()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        gpaViewController.placeDelegate = self
        mapView.delegate = self
        
        if let path = NSBundle.mainBundle().pathForResource("GoogleService-Info", ofType: "plist") {
            if let myDict = NSDictionary(contentsOfFile: path) {
                GIDSignIn.sharedInstance().clientID = myDict["CLIENT_ID"] as! String
            }
        }
        GIDSignIn.sharedInstance().signInSilently()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        populateMapWithBathrooms()
    }
=======
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

>>>>>>> Removed .DS_Store from repository
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
// MARK: - VIEW CONTROLLER
<<<<<<< HEAD
    @IBAction func searchBathrooms(sender: UIButton) {
        populateMapWithBathrooms()
    }
    
    @IBAction func searchAddress(sender: UIButton) {
        presentViewController(gpaViewController, animated: true, completion: nil)
    }
=======
>>>>>>> Removed .DS_Store from repository
    
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
<<<<<<< HEAD
            case "bathroomDetailsSegue":
                let marker = sender as! GMSMarker
                let bathroom = marker.userData as! Bathroom
                let bathroomDetailsViewController = segue.destinationViewController as! BathroomDetailsTableViewController
                bathroomDetailsViewController.bathroom = bathroom
=======
            case "profileSegue":
                let profileViewController = segue.destinationViewController as! ProfileViewController
                profileViewController.model = model;
>>>>>>> Removed .DS_Store from repository
            default:
                NOOP("UNREACHABLE")
            }
        }
    }
<<<<<<< HEAD
    
// MARK: - GIDSIGNIN DELEGATE
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if let err = error {
            print("Error signing in \(err)")
        } else {
            UserManager.sharedInstance.email = user.profile.email
            UserManager.sharedInstance.name = user.profile.name
            UserManager.sharedInstance.userToken = user.authentication.accessToken
            UserManager.sharedInstance.refreshToken = user.authentication.refreshToken
            UserManager.sharedInstance.profileId = 1
            if user.profile.hasImage {
                if let  imageURL = user.profile.imageURLWithDimension(50), let data = NSData(contentsOfURL: imageURL), let image = UIImage(data: data)
                {
                    UserManager.sharedInstance.profilePic = image;
                }
            }
            print("User manager shared instance:  ID: \(UserManager.sharedInstance.profileId)   Name: \(UserManager.sharedInstance.name)")
            var fullNameArr = UserManager.sharedInstance.name?.componentsSeparatedByString(" ")
            let firstName = fullNameArr![0]
            let lastName = fullNameArr![1]
            profileRetriever.authorize{ id -> Void in
                if let id = id {
                    UserManager.sharedInstance.profileId = id
                } else {
                    UserManager.sharedInstance.profileId = 1
                }
            }
        }
    }
    
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        if let err = error {
            print("Error disconnection \(err)")
        } else {
            
        }
    }
    
=======
>>>>>>> Removed .DS_Store from repository
// MARK: - CLLOCATION MANAGER DELEGATE
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
<<<<<<< HEAD
            
=======
>>>>>>> Removed .DS_Store from repository
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
<<<<<<< HEAD
            populateMapWithBathrooms()
        }
    }

// MARK: - GMSMapViewDelgate methods
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        let infoWindow = NSBundle.mainBundle().loadNibNamed("BathroomSnippetView", owner: self, options: nil).first! as! BathroomSnippetView
        let bathroom = marker.userData as! Bathroom
        infoWindow.title.text = bathroom.title
        infoWindow.ratingView.notSelectedImages = [
            UIImage(named: "Brown_washed")!, UIImage(named: "Bronze_washed")!, UIImage(named: "Gold_washed")!,
            UIImage(named: "Silver_washed")!, UIImage(named: "Porcelain_washed")!]
        infoWindow.ratingView.fullSelectedImage = [
            UIImage(named: "Brown")!, UIImage(named: "Bronze")!, UIImage(named: "Gold")!,
            UIImage(named: "Silver")!, UIImage(named: "Porcelain")!]
        infoWindow.ratingView.rating = Int(bathroom.rating!)
        infoWindow.layer.borderColor = UIColor(red: 89/255.0, green: 225/255/0, blue: 166/255.0, alpha: 1).CGColor
        if let flags = bathroom.flags {
            for flag in flags {
                if flag.FLAG_ID == Flag.HARD_TO_FIND.FLAG_ID {
                    infoWindow.hardToFindFlag.image = UIImage(named: "Hard_to_find")
                } else if flag.FLAG_ID == Flag.NON_EXISTING.FLAG_ID {
                    infoWindow.nonExistentFlag.image = UIImage(named: "Non_Existent")
                } else if flag.FLAG_ID == Flag.PAID.FLAG_ID {
                    infoWindow.paidFlag.image = UIImage(named: "Paid")
                } else if flag.FLAG_ID == Flag.PUBLIC.FLAG_ID{
                    infoWindow.publicFlag.image = UIImage(named: "Public")
                }
            }
        }
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
                    marker.appearAnimation = kGMSMarkerAnimationPop
                    marker.map = self.mapView
                }
            }
        }
    }
    
    @IBAction func addBathroom() {
        if UserManager.sharedInstance.IsSignedIn {
            performSegueWithIdentifier("addBathroomSegue", sender: self)
        } else {
            let ac = UIAlertController(title: "Sign in to create a bathroom.", message: "Not signed in.", preferredStyle: UIAlertControllerStyle.Alert)
            ac.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }
    }
}

// MARK: - GOOGLE PLACES DELEGATE

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

// MARK: - STYLE FUNCTIONS

extension MapViewController {
    
    func styleButtonBackground(){
        buttonBackground.layer.backgroundColor = UIColor.colorFromHexRGBValue(0x59E1A6).CGColor
    }
    
    func styleDivider(){
        self.divider?.layer.backgroundColor = UIColor.grayColor().CGColor
    }
    
    func styleGooglePlacesAutoCompleteBar() {
        self.gpaViewController.navigationBar.barTintColor = UIColor.colorFromHexRGBValue(0x26C27F)
        self.gpaViewController.navigationBar.tintColor = UIColor.whiteColor()
        self.gpaViewController.navigationBar.translucent = false
        self.gpaViewController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.gpaViewController.navigationBar.topItem?.title = "Where Do You Need to Poo?"
        gpaViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: gpaViewController, action: "close")
    }
    
    func styleNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor.colorFromHexRGBValue(0x26C27F)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.topItem?.title = "Porcelain"
    }
    
    func styleButtons(){
        self.searchAddressButton.backgroundColor = UIColor.colorFromHexRGBValue(0x59E1A6)
        self.searchAreaButton.backgroundColor = UIColor.colorFromHexRGBValue(0x59E1A6)
=======
        }
    }

// TODO:
    @IBAction func addBathroom() {
        NOOP("TODO")
>>>>>>> Removed .DS_Store from repository
    }
}
