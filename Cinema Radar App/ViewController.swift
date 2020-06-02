//
//  ViewController.swift
//  Cinema Radar App
//
//  Created by Patunique on 02.06.2020.
//  Copyright © 2020 Boris Malashenko. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
                
        mapView.delegate = self
        
        mapView.showsUserLocation = true
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    @IBAction func showNearby(_ sender: Any) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "Cinema"
        searchRequest.region = mapView.region
        let localSearch = MKLocalSearch(request: searchRequest)
        localSearch.start { (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print(error)
                }
                return
            }
            let mapItems = response.mapItems
            var nearbyAnnotations: [MKAnnotation] = []
            if mapItems.count > 0 {
                for item in mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.title = item.name
                    annotation.subtitle = item.phoneNumber
                    if let location = item.placemark.location {
                        annotation.coordinate = location.coordinate
                        
                    }
                    nearbyAnnotations.append(annotation)
                    
                }
            }
            self.mapView.showAnnotations(nearbyAnnotations, animated: true)
            
        }
    }
    
}

