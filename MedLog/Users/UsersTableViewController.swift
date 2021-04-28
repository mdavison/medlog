//
//  UsersTableViewController.swift
//  MedLog
//
//  Created by Morgan Davison on 9/30/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import UIKit
import CoreData

protocol UserSelectionDelegate: class {
    func userSelected(_ user: User)
}

class UsersTableViewController: UITableViewController {
    
    struct Storyboard {
        static let userCellReuseIdentifier = "UserCell"
        static let showMedicationsListSegue = "ShowMedicationsList"
    }
    
    var coreDataStack: CoreDataStack?
    weak var delegate: UserSelectionDelegate?
    
    lazy var fetchedResultsController: NSFetchedResultsController<User> = {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(User.name), ascending: true)
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
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let medicationsToolBarButton = UIBarButtonItem(title: "Medications", style: .plain, target: self, action: #selector(showMedications))
        toolbarItems = [medicationsToolBarButton]
        
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print("Fetching error: \(error.localizedDescription)")
        }
        
        // Select the first user by default
        // TODO: Remember the last selection and select that one instead of the first one
        if let firstUser = fetchedResultsController.fetchedObjects?.first {
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
            delegate?.userSelected(firstUser)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showMedicationsListSegue {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let medicationsTableViewController = navigationController.topViewController as? MedicationsTableViewController else {
                    return
            }
            
            medicationsTableViewController.coreDataStack = coreDataStack
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func addUser(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New User", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] (action) in
            if
                let name = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                name.isEmpty == false {
                
                self?.saveUser(name: name)
            }
        }))
        present(alert, animated: true)
    }
    
    
    // MARK: - Helpers
    
    private func saveUser(name: String) {
        guard let coreDataStack = coreDataStack else { return }
        
        if User.checkNameExists(name, coreDataStack: coreDataStack) == true {
            let alert = UIAlertController(title: "Name Exists", message: "Please choose a different name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            
            return
        }
        
        _ = User(name: name, coreDataStack: coreDataStack)
        
        coreDataStack.saveContext()
    }
    
    private func configure(cell: UITableViewCell, at indexPath: IndexPath) {
        let user = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = user.name
    }
    
    @objc private func showMedications(_ button: UIBarButtonItem) {
        performSegue(withIdentifier: Storyboard.showMedicationsListSegue, sender: self)
    }

}


// MARK: - NSFetchedResultsControllerDelegate

extension UsersTableViewController: NSFetchedResultsControllerDelegate {
    
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



// MARK: - Table view data source

extension UsersTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
        
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.userCellReuseIdentifier, for: indexPath)
        
        configure(cell: cell, at: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = fetchedResultsController.object(at: indexPath)
        
        delegate?.userSelected(selectedUser)
        
        // Make it work on iPhone
        if
            let dosesTableViewController = delegate as? DosesTableViewController,
            let dosesNavController = dosesTableViewController.navigationController {
            splitViewController?.showDetailViewController(dosesNavController, sender: nil)
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = fetchedResultsController.object(at: indexPath)
            coreDataStack?.managedContext.delete(user)
            coreDataStack?.saveContext()
        }
    }
}
