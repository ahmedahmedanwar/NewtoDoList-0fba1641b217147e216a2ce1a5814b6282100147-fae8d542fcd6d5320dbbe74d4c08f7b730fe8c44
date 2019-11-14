//
//  ViewController.swift
//  toDoList
//
//  Created by z510 on 11/1/19.
//  Copyright © 2019 z510. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class toDo: UITableViewController {
    
    
    var toDoItems : Results <Items>?
    let realm = try! Realm()
    
    
    var   selctedCategory : Category? {
        
        didSet{
            
            loadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Mark DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "doCell", for: indexPath)
        
        if   let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ?  .checkmark :  .none
            
            
        }else {
            
            cell.textLabel?.text = "No item Add"
        }
        
        
        return cell
    }
    
    //Mark Delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row]{
            
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error Saving done status , \(error)")
            }
        }
        
        tableView.reloadData()
        
        
        
    }
    
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new to Do", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            if let currentCategory = self.selctedCategory{
                do{
                    try self.realm.write {
                        let newItem =  Items()
                        newItem.dateCreated = Date()
                        
                        newItem.title = textfield.text!
                        currentCategory.items.append(newItem)
                    }
                }
                catch {
                    
                    print("Error saving new items, \(error)")
                }
                
            }
            self.tableView.reloadData()
        }
        
        
        alert.addTextField { (alerttextfield) in
            alerttextfield.placeholder = "Enter New Item"
            textfield = alerttextfield
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    func loadData (){
        
        toDoItems = selctedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

//Mark SearchBar Method

extension toDo :UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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






