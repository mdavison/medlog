//
//  DoseDetailTableViewController.swift
//  MedLog
//
//  Created by Morgan Davison on 10/18/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import UIKit

class DoseDetailTableViewController: UITableViewController {
    
    struct Storyboard {
        static let dateCell = "DatePickerCell"
        static let medicationCell = "MedicationCell"
        static let manageMedicationsCell = "ManageMedicationsCell"
        static let notesCell = "NotesCell"
        static let dateSection = 0
        static let medicationsSection = 1
        static let manageMedicationsSection = 2
        static let notesSection = 3
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - Table view data source

extension DoseDetailTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Storyboard.medicationsSection: return 3
        default: return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Storyboard.dateSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.dateCell, for: indexPath) as! DatePickerTableViewCell
            return cell
        case Storyboard.medicationsSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.medicationCell, for: indexPath)
            return cell
        case Storyboard.manageMedicationsSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.manageMedicationsCell, for: indexPath)
            return cell
        case Storyboard.notesSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.notesCell, for: indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
    }
}
