//
//  UsersTableViewController.swift
//  MedLog
//
//  Created by Morgan Davison on 9/30/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import UIKit

protocol UserSelectionDelegate: class {
    func userSelected(_ newUser: User)
}

class UsersTableViewController: UITableViewController {
    
    static let userCellReuseIdentifier = "UserCell"
    
    var users: [User]?
    weak var delegate: UserSelectionDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewController.userCellReuseIdentifier, for: indexPath)

        if let users = users {
            let user = users[indexPath.row]
            cell.textLabel?.text = user.name
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedUser = users?[indexPath.row] else { return }
        
        delegate?.userSelected(selectedUser)
        
        // Make it work on iPhone
        if
            let dosesTableViewController = delegate as? DosesTableViewController,
            let dosesNavController = dosesTableViewController.navigationController {
            splitViewController?.showDetailViewController(dosesNavController, sender: nil)
        }
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

}
