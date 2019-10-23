//
//  MedicationsTableViewController.swift
//  MedLog
//
//  Created by Morgan Davison on 10/20/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import UIKit
import CoreData

class MedicationsTableViewController: UITableViewController {
    
    struct Storyboard {
        static let medicationCellReuseIdentifier = "MedicationCell"
        static let medicationDetailSegue = "MedicationDetailSegue"
    }
    
    var coreDataStack: CoreDataStack?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Medication> = {
        let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Medication.name), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack!.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Medications"
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print("Fetching error: \(error.localizedDescription)")
        }
    }



    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.medicationDetailSegue {
            guard
                let navController = segue.destination as? UINavigationController,
                let medicationDetailController = navController.topViewController as? MedicationDetailTableViewController else {
                return
            }
            
            medicationDetailController.delegate = self 
        }
    }

    
    
    // MARK: - Actions
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Helpers
    
    private func configure(cell: UITableViewCell, at indexPath: IndexPath) {
        let medication = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = medication.name
    }
        
}


// MARK: - Table view data source

extension MedicationsTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
        
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.medicationCellReuseIdentifier, for: indexPath)

        configure(cell: cell, at: indexPath)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}


// MARK: - MedicationDetailTableViewControllerDelegate

extension MedicationsTableViewController: MedicationDetailTableViewControllerDelegate {
    
    func didFinishEditingName(controller: MedicationDetailTableViewController, name: String) {
        guard let coreDataStack = coreDataStack else { return }
        
        _ = Medication(name: name, coreDataStack: coreDataStack)
        
        coreDataStack.saveContext()
        
//        tableView.reloadData()
    }
}


// MARK: - NSFetchedResultsControllerDelegate

extension MedicationsTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!)!
            configure(cell: cell, at: indexPath!)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        @unknown default:
            print("Unexpected NSFetchedResultsChangeType")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
