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
            updateDoses()
            refreshUI()
        }
    }
    var coreDataStack: CoreDataStack?
    var doses = [Dose]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = user?.name ?? ""

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DosesTableViewController.doseCellReuseIdentifier, for: indexPath)

        let dose = doses[indexPath.row]
        cell.textLabel?.text = "\(dose.medication?.name) at \(dose.date)"
        
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

    /*
    // MARK: - Navigation

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
        
        if let dose = Dose(date: Date(), medication: medication, user: user, coreDataStack: coreDataStack) {
            doses.append(dose)
            tableView.reloadData()
        }
    }
    
    
    
    // MARK: - Helpers
    
    private func refreshUI() {
        loadViewIfNeeded()
        title = user?.name
        tableView.reloadData()
    }
    
    private func updateDoses() {
        if let coreDataStack = coreDataStack, let user = user {
            doses = Dose.getAll(for: user, coreDataStack: coreDataStack)
        }
    }

}


// MARK: - UserSelectionDelegate

extension DosesTableViewController: UserSelectionDelegate {
    
    func userSelected(_ user: User) {
        self.user = user
    }
}
