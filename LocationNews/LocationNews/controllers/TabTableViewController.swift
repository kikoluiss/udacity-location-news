//
//  TabTableViewController.swift
//  LocationNews
//
//  Created by Kiko Santos on 10/01/19.
//  Copyright © 2019 Kiko Santos. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TabTableViewController: UITableViewController {

    var dataController: DataController!
    
    var fetchedResultsController: NSFetchedResultsController<Location>!

    var flgEditLocations = false
    var mainTabBarController: MainViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainTabBarController = (self.tabBarController as! MainViewController)
        dataController = mainTabBarController.dataController

        setupFetchedResultsController()
        
        NotificationCenter.default.addObserver(self, selector: #selector(editLocations), name: NSNotification.Name(rawValue: tabTableNotificationKey), object: nil)
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
        self.tableView.isEditing = false
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
        
        self.tableView.reloadData()

    }
    
    @objc func editLocations() {
        self.tableView.isEditing = !self.tableView.isEditing
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListToListDetailSegue" {
            let vc = segue.destination as! NewsTableViewController
            if let indexRow = tableView.indexPathForSelectedRow?.row, let selectedLocation = fetchedResultsController.fetchedObjects?[indexRow] {
                vc.query = selectedLocation.name
            }
        }
    }

}

extension TabTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_location", for: indexPath)
        
        let location = fetchedResultsController.fetchedObjects?[indexPath.row]
        cell.textLabel?.text = location?.name
        cell.detailTextLabel?.text = location?.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            if let selectedLocation = fetchedResultsController.fetchedObjects?[indexPath.row] {
                tableView.beginUpdates()
                
                dataController.viewContext.delete(selectedLocation)
                try? dataController.viewContext.save()
                tableView.deleteRows(at: [indexPath], with: .fade)

                tableView.endUpdates()
            }
        }
    }
    
}

extension TabTableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: tableView.insertSections(indexSet, with: .fade)
        case .delete: tableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

}
