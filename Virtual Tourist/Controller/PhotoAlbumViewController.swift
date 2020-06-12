//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by David Jarrin on 5/1/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate {
    
    var pin: Pin!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStaticMapView()
    }
    
    func setStaticMapView(){
        mapView.delegate = self
        
        let annotation = MKPointAnnotation()
               
        let cordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        annotation.coordinate = cordinate
        
        mapView.addAnnotation(annotation)
        
        mapView.showAnnotations([annotation], animated: true)
        
        mapView.selectAnnotation(annotation, animated: true)
        
        let rectangleSide = 5000
        let region = MKCoordinateRegion( center: cordinate, latitudinalMeters: CLLocationDistance(exactly: rectangleSide)!, longitudinalMeters: CLLocationDistance(exactly: rectangleSide)!)
        
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .systemTeal
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
}
