//
//  TabMapViewController.swift
//  LocationNews
//
//  Created by Kiko Santos on 10/01/19.
//  Copyright © 2019 Kiko Santos. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TabMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var editWarning: UILabel!
    
    var dataController: DataController!
    
    var fetchedResultsController: NSFetchedResultsController<Location>!

    var flgEditLocations = false
    var selectedLocation: Location!
    var mainTabBarController: MainViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        mainTabBarController = (self.tabBarController as! MainViewController)
        dataController = mainTabBarController.dataController
        
        mapView.delegate = self;

        setupFetchedResultsController()
        
        NotificationCenter.default.addObserver(self, selector: #selector(editLocations), name: NSNotification.Name(rawValue: tabMapNotificationKey), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        cancelEditing()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
        cancelEditing()
    }
    
    fileprivate func cancelEditing() {
        flgEditLocations = false
        editWarning.isHidden = true
        self.mainTabBarController.editButton.title = "Edit"
    }
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "locations")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        
        guard let locations = fetchedResultsController.fetchedObjects else {
            return
        }
        
        for location in locations {
            self.mapView.addAnnotation(location)
        }

    }

    @objc func editLocations() {
        flgEditLocations = !flgEditLocations
        editWarning.isHidden = !editWarning.isHidden
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapToListDetailSegue" {
            let vc = segue.destination as! NewsTableViewController
            vc.query = selectedLocation.name
        }
    }

}

extension TabMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let coordinate = view.annotation?.coordinate {
            let locations = self.fetchedResultsController.fetchedObjects?.filter { (location) -> Bool in
                if let latitude = location.latitude, let longitude = location.longitude {
                    return CLLocationDegrees(latitude.doubleValue) == coordinate.latitude &&
                        CLLocationDegrees(longitude.doubleValue) == coordinate.longitude
                }
                return false
            }
            
            mapView.deselectAnnotation(view as? MKAnnotation, animated: false)
            
            if let locations = locations {
                selectedLocation = locations[0]
                if flgEditLocations {
                    mapView.removeAnnotation(selectedLocation)
                    dataController.viewContext.delete(selectedLocation)
                    try? dataController.viewContext.save()
                } else {
                    self.performSegue(withIdentifier: "MapToListDetailSegue", sender: self)
                }
            }
        }
    }
}

extension TabMapViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        guard let location = anObject as? Location else {
            preconditionFailure("All changes observed in the map view controller should be for Point instances")
        }
        
        switch type {
        case .insert:
            performUIUpdatesOnMain {
                self.mapView.addAnnotation(location)
            }
        case .delete:
            performUIUpdatesOnMain {
                self.mapView.removeAnnotation(location)
            }
        case .update:
            performUIUpdatesOnMain {
                self.mapView.removeAnnotation(location)
                self.mapView.addAnnotation(location)
            }
        case .move:
            // N.B. The fetched results controller was set up with a single sort descriptor that produced a consistent ordering for its fetched Point instances.
            fatalError("How did we move a Point? We have a stable sort.")
        }
    }
    
}
