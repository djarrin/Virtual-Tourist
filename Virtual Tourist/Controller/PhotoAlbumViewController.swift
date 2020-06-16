//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by David Jarrin on 5/1/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    
    var dataController:DataController!
    
    var fetchedPhotosController:NSFetchedResultsController<Photo>!
    
    var pin: Pin!
    var page: Int = 0
    var availablePages: Int?
    lazy var photos = pin.photos!.allObjects as! [Photo]
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var NewCollectionButton: UIBarButtonItem!
    @IBOutlet weak var NoPhotosWarning: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NoPhotosWarning.isHidden = true
        setUpCollectionView()
        setStaticMapView()
        if(pin.photos!.count == 0) {
            fetchNewCollection()
        }
    }
    
    @IBAction func fetchNewCollection() {
        page += 1
        pageLoading(loading: true)
        FlickerClient.photoSearch(latitude: pin.latitude, longitude: pin.longitude, page: page, completion: photoSearchResponse(response:error:))
    }
    
    func reloadPhotos(){
        photos = pin.photos!.allObjects as! [Photo]
        collectionView!.reloadData()
    }
    
    func photoSearchResponse(response: FlickerPhotoSearchResponse?, error: Error?) -> Void {
        if let response = response {
            //Need to delete old photos
            pin.photos = []
            availablePages = response.photos.pages
            if response.photos.photo.count > 0 {
                NoPhotosWarning.isHidden = true
            } else {
                NoPhotosWarning.isHidden = false
            }
            var completionArray = [Bool]()
            for image in response.photos.photo {
                let photosTotal = response.photos.photo.count
                // A little too much indentation here but I needed access to the image object
                // and this seemed like the least disruptive path
                FlickerClient.getSource(photoID: image.id) { (response, error) in
                    if let response = response {
                        self.NoPhotosWarning.isHidden = true
                        if let lastPhoto = response.sizes.size.first {
                            let newPhoto = Photo(context: self.dataController.viewContext)
                            newPhoto.id = image.id
                            newPhoto.source = URL(string: lastPhoto.source)!
                            self.pin.addToPhotos(newPhoto)
                            try? self.dataController.viewContext.save()
                            self.reloadPhotos()
                            completionArray.append(true)
                            if(completionArray.count >= photosTotal) {
                                self.pageLoading(loading: false)
                            }
                        } 
                    } else {
                        // error, perhaps display no photos language
                        self.NoPhotosWarning.isHidden = false
                    }
                }
            }
        } else {
            // error, perhaps display no photos language
            self.NoPhotosWarning.isHidden = false
            pageLoading(loading: false)
        }
        
    }
    
    
    func pageLoading(loading: Bool) {
        NewCollectionButton.isEnabled = !loading
    }
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView!.reloadData()
    }
    
    
    
    func setStaticMapView() {
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
