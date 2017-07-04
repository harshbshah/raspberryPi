//
//  MapVC.swift
//  note_CD
//
//  Created by Marcel Harvan on 2017-04-21.
//  Copyright © 2017 The Marcel's fake Company. All rights reserved.
//

import UIKit
import MapKit
import CoreData
class MapVC: UIViewController {
    
    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        var annotations : [MKAnnotation] = []
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        do {
            let result = try context.fetch(fetchRequest) //as! [Notes]
            let notesToLoad = result as! [Notes]
            for note in notesToLoad {
                
                let latitude: CLLocationDegrees = note.latitude
                let longitude: CLLocationDegrees = note.longitude
                
                let latDelta: CLLocationDegrees = 0.01
                let lonDelta: CLLocationDegrees = 0.01
                let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
                let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                mapView.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = note.note_content as? String
                
                
                annotations.append(annotation)
            }
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        mapView.showAnnotations(annotations, animated: true)
    }
}
    




