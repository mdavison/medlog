//
//  MedsTableViewController.swift
//  MedLog
//
//  Created by Morgan Davison on 9/30/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import UIKit
import CoreData

class DosesTableViewController: UITableViewController {

    static let doseCellReuseIdentifier = "DoseCell"
    
    var user: User? {
        didSet {
            _fetchedResultsController = nil
            
            do {
                try fetchedResultsController.performFetch()
                refreshUI()
            } catch let error {
                print("Fetching error: \(error.localizedDescription)")
            }
        }
    }
    var coreDataStack: CoreDataStack?
    var fetchedResultsController: NSFetchedResultsController<Dose> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
                
        let fetchRequest: NSFetchRequest<Dose> = Dose.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Dose.date), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        if let user = user {
            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Dose.user), user)
        }
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack!.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        _fetchedResultsController = fetchedResultsController
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<Dose>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = user?.name ?? ""

         self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
        
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DosesTableViewController.doseCellReuseIdentifier, for: indexPath)
        
        configure(cell: cell, for: indexPath)
        
        return cell
    }
    
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let dose = fetchedResultsController.object(at: indexPath)
            coreDataStack?.managedContext.delete(dose)
            coreDataStack?.saveContext()
        }
    }

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

    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
  */
    
    // MARK: - Actions
    
    @IBAction func addDose(_ sender: UIBarButtonItem) {
        guard
            let coreDataStack = coreDataStack,
            let medication = Medication(name: "Tylenol", coreDataStack: coreDataStack),
            let user = user else {
                return
        }
                
        _ = Dose(date: Date(), medication: medication, user: user, coreDataStack: coreDataStack)
        
        coreDataStack.saveContext()
    }
    
    
    
    // MARK: - Helpers
    
    private func refreshUI() {
        loadViewIfNeeded()
        title = user?.name
        tableView.reloadData()
    }
    
    private func configure(cell: UITableViewCell, for indexPath: IndexPath) {
        let dose = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = "\(dose.medication?.name) at \(dose.date)"
    }

}


// MARK: - UserSelectionDelegate

extension DosesTableViewController: UserSelectionDelegate {
    
    func userSelected(_ user: User) {
        self.user = user
    }
}


// MARK: - NSFetchedResultsControllerDelegate

extension DosesTableViewController: NSFetchedResultsControllerDelegate {
    
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
            configure(cell: cell, for: indexPath!)
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
