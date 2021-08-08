//
//  ContactsTableViewController.swift
//  My Contact List
//
//  Created by Samir Alyateem on 4/24/19.
//  Copyright © 2019 Samir Alyateem. All rights reserved.
//

import UIKit
import CoreData

class ContactsTableViewController: UITableViewController {

  //let  contacts = ["John", "James", "Luke"]
    var contacts:[NSManagedObject] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromDatabase()

        self.navigationItem.leftBarButtonItem = self.editButtonItem
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromDatabase()
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() 
    }
    
    
    func loadDataFromDatabase() {
        //load settings from UserDefaults
        let settings = UserDefaults.standard
        let sortField = settings.string(forKey: Constants.kSortField)
        let sortAscending = settings.bool(forKey: Constants.kSortDirectionAscending)
        
        //Setup Core Data
        let context = appDelegate.persistentContainer.viewContext
        
        //specify sorting
        let sortDescriptor = NSSortDescriptor(key: sortField, ascending: sortAscending)
        
        let sortDescriptorArray = [sortDescriptor]
        
        //setup request
        let request = NSFetchRequest<NSManagedObject>(entityName: "Contact")

        
        request.sortDescriptors = sortDescriptorArray
        
        //execute request
        do{
            contacts = try context.fetch(request)
        }catch let error as NSError {
            print ("Could not fetch . \(error), \(error.userInfo)")
        }
        
        do{
            contacts = try context.fetch(request)
        }catch let error as NSError{
            print("Could not fetch . \(error), \(error.userInfo) ")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            // Configure the cell...
            let contact = contacts[indexPath.row] as? Contact
        
            cell.textLabel?.text = contact?.contactName
            cell.detailTextLabel?.text = contact?.city
            cell.accessoryType = .detailDisclosureButton
        
        
            return cell
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditContact"{
            let contactController = segue.destination as? ContactsViewController
            let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
            let selectedContact = contacts[selectedRow!] as? Contact
            
            contactController?.currentContact = selectedContact!
            
        }
    }
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let contact = contacts[indexPath.row] as? Contact
            let context = appDelegate.persistentContainer.viewContext
            context.delete(contact!)
            do{
                try context.save()
            }catch{
                fatalError("Error saving context : \(error)")
            }
            loadDataFromDatabase()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = contacts[indexPath.row] as? Contact
        let name = selectedContact!.contactName!
        let actionHandler = { (action: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "EditContact", sender: tableView.cellForRow(at: indexPath))
        }
        
        let alertController = UIAlertController(title: "Contact Selected", message: "Selected Row: \(indexPath.row) (\(name))", preferredStyle: .alert)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: actionHandler)
        
        let actionDetails = UIAlertAction(title: "Show Details", style: .default, handler: actionHandler)
        
        alertController.addAction(actionCancel)
        alertController.addAction(actionDetails)
        present(alertController, animated:true, completion: nil)
        
        
        
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

}
