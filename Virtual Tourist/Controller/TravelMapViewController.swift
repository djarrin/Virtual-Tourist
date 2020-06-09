//
//  TravelMapViewController.swift
//  Virtual Tourist
//
//  Created by David Jarrin on 4/28/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import UIKit
import MapKit

class TravelAnnotation: MKPointAnnotation {
    //Will use this ID once we get to the saving and retrieving step
    var tag: Int!
}

class TravelMapViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var dataController:DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.delegate = self
        mapView.addGestureRecognizer(tapGesture)

        mapView.delegate = self
        
//        mapView.setCenter(CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "mapLatitude"), longitude: UserDefaults.standard.double(forKey: "mapLongitude")), animated: true)
        let centerCoordinate = CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "mapLatitude"), longitude: UserDefaults.standard.double(forKey: "mapLongitude"))
        let latitudeDelta = UserDefaults.standard.double(forKey: "mapLatitudeDelta")
        let longitudeDelta = UserDefaults.standard.double(forKey: "mapLongitudeDelta")
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let region = MKCoordinateRegion( center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
                
    }
    
    @objc func handleTap(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        let annotation = TravelAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }

    

}

extension TravelMapViewController:MKMapViewDelegate {
    // save coordinates of map center point and zoom everytime it changes to UserDefaults
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        UserDefaults.standard.set(mapView.centerCoordinate.latitude, forKey: "mapLatitude")
        UserDefaults.standard.set(mapView.centerCoordinate.longitude, forKey: "mapLongitude")
        let zoom = mapView.region.span
        UserDefaults.standard.set(zoom.latitudeDelta, forKey: "mapLatitudeDelta")
        UserDefaults.standard.set(zoom.longitudeDelta, forKey: "mapLongitudeDelta")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .purple
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("tapped on pin ")
        print(view)
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let doSomething = view.annotation?.title! {
               print("do something")
            }
        }
    }
    
    func getRadius(centralLocation: CLLocation) -> Double{
        let topCentralLat:Double = centralLocation.coordinate.latitude -  mapView.region.span.latitudeDelta/2
        let topCentralLocation = CLLocation(latitude: topCentralLat, longitude: centralLocation.coordinate.longitude)
        let radius = centralLocation.distance(from: topCentralLocation)
        return radius / 1000.0 // to convert radius to meters
    }
}
