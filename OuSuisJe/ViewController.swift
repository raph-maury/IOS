//
//  ViewController.swift
//  OuSuisJe
//
//  Created by xcode on 20/03/2015.
//  Copyright (c) 2015 University of Corsica. All rights reserved.
//

import UIKit

import CoreLocation

import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!
    @IBOutlet weak var saiLatitude: UITextField!
    @IBOutlet weak var saiLongitude: UITextField!
    @IBOutlet weak var saiAltitude: UITextField!
    @IBOutlet weak var saiMap: MKMapView!
    @IBOutlet weak var libStatut: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    //Constructeur
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var geolocEnabled: Bool
        geolocEnabled = CLLocationManager.locationServicesEnabled()
        if(geolocEnabled){
            self.libStatut.text = "Arrêté"
            self.libStatut.backgroundColor = UIColor.orangeColor()
        }else{
            self.libStatut.text = "Services non disponibles"
            self.libStatut.backgroundColor = UIColor.redColor()
    
        }
    }
    
    func updateStatut(){
        var autorization: CLAuthorizationStatus
        autorization = CLLocationManager.authorizationStatus()
        switch(autorization){
        case .NotDetermined:
            self.libStatut.text = "Non déterminé"
            self.libStatut.backgroundColor = UIColor.redColor()
        case .Restricted:
            self.libStatut.text = "Restreint"
            self.libStatut.backgroundColor = UIColor.redColor()
        case .Denied:
            self.libStatut.text = "Bloqué"
            self.libStatut.backgroundColor = UIColor.redColor()
        case .Authorized:
            self.libStatut.text = "En réception"
            self.libStatut.backgroundColor = UIColor.greenColor()
        case .AuthorizedWhenInUse:
            self.libStatut.text = "En réception"
            self.libStatut.backgroundColor = UIColor.greenColor()
        }
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var currenLoc: CLLocation
        var XY: CLLocationCoordinate2D
        var alt, x, y:Double
        var region: MKCoordinateRegion

        currenLoc = manager.location
        self.saiAltitude.text = String(format:"%f", currenLoc.altitude)
        XY = currenLoc.coordinate
        x = XY.latitude
        self.saiLatitude.text = String(format: "%f", x)
        y = XY.longitude
        self.saiLongitude.text = String(format: "%f", y)
        region = MKCoordinateRegionMakeWithDistance(XY, 250, 250)
        self.saiMap.setRegion(region, animated: true)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError) {
        var alert = UIAlertView()
        alert.title = "Erreur GPS"
        alert.message = "Impossible de trouver la positon"
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!){
        self.activityIndicator.hidden = true
        self.activityIndicator.stopAnimating()
    }
    func mapViewWillStartLocatingUser(mapView: MKMapView!){
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
    }
    
    func mapViewDidFinishRenderungMap(mapView: MKMapView!, fullyRendered: Bool){
        self.activityIndicator.hidden = true
        self.activityIndicator.stopAnimating()
    }
    
    @IBAction func clicStop(sender: UIButton) {
        self.locationManager.stopUpdatingLocation()
        self.libStatut.text = "Arrêté"
        self.libStatut.backgroundColor = UIColor.orangeColor()
        self.saiMap.showsUserLocation = false
    }
    
    @IBAction func clicStart(sender: UIButton) {
        self.locationManager.startUpdatingLocation()
        self.updateStatut()
        self.saiMap.showsUserLocation = true
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

