//
//  ViewController.swift
//  toDoList
//
//  Created by z510 on 11/1/19.
//  Copyright © 2019 z510. All rights reserved.
//

import UIKit
import CoreData

class toDo: UITableViewController {
    
    var dolist = [Items]()
    //  let defaults = UserDefaults.standard
    //  let dataFilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var   selctedCategory : Category? {
        
        didSet{
            
            loadData()
        }
        
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //
        //        let newItem1 = Items()
        //        newItem1.title = "Sport"
        //        dolist.append(newItem1)
        //
        //        let newItem2 = Items()
        //        newItem2.title = "Shopping"
        //        dolist.append(newItem2)
        //
        //        let newItem3 = Items()
        //        newItem3.title = "Running"
        //        dolist.append(newItem3)
        
        //   print(dataFilepath)
        
        
        
        
        
        //        if let items = defaults.array(forKey: "dolist") as? [Items]{
        //           dolist = items
        //        }
        
    }
    
    // Mark DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dolist.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //  let cell = UITableViewCell(style: .default, reuseIdentifier: "doCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "doCell", for: indexPath)
        
        let item = dolist[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ?  .checkmark :  .none
        
        
        return cell
    }
    
    //Mark Delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Mark -> deleting raws befor ui editing
        //        context.delete(dolist[indexPath.row])
        //        dolist.remove(at: indexPath.row)
        
        dolist[indexPath.row].done = !dolist[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveditems()
    }
    
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new to Do", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            
            let newItem =  Items(context: self.context)
            newItem.title = textfield.text!
            newItem.done = false
            newItem.parentCategory = self.selctedCategory
            self.dolist.append(newItem)
            
            //         self.defaults.set(self.dolist, forKey: "dolist")
            
            self.saveditems()
//            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alerttextfield) in
            alerttextfield.placeholder = "Enter New Item"
            textfield = alerttextfield
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    func saveditems (){
        
        do{
            
            try context.save()
            
        }catch{
            
            print("error Saving context")
        }
        
        tableView.reloadData()
        
    }
    
    func loadData(with request: NSFetchRequest <Items> = Items.fetchRequest(), predicate : NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@ ", selctedCategory!.name!)
        
        if let addtionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate , addtionalPredicate])
            
        }else{
            request.predicate = categoryPredicate
        }

        do{
            
            dolist =   try context.fetch(request)
            
        }catch {
            
            print("Error fetching data from request ")
        }
        
        tableView.reloadData()
        
    }
}

//Mark SearchBar Method

extension toDo :UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
       let request : NSFetchRequest<Items> = Items.fetchRequest()

               let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

               request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

               loadData(with: request, predicate: predicate)
    
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}





