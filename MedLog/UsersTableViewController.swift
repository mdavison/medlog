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
    
    static let userCellReuseIdentifier = "UserCell"
    
    var coreDataStack: CoreDataStack?
    var users = [User]()
    weak var delegate: UserSelectionDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        if let coreDataStack = coreDataStack {
            users = User.getAll(with: coreDataStack)
        }
        
        if let firstUser = users.first {
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
            delegate?.userSelected(firstUser)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewController.userCellReuseIdentifier, for: indexPath)

        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        
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
            let user = users[indexPath.row]
            coreDataStack?.managedContext.delete(user)
            coreDataStack?.saveContext()
            users.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Actions
    
    @IBAction func addUser(_ sender: UIBarButtonItem) {
        guard let coreDataStack = coreDataStack else { return }
        
        if let user = User(name: "\(Date())", coreDataStack: coreDataStack) {
            users.append(user)
            let indexPath = IndexPath(row: users.count - 1, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    

}
