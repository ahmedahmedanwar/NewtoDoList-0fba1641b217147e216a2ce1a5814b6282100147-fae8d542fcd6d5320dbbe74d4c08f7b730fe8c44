//
//  CtegoryTableViewController.swift
//  toDoList
//
//  Created by Ahmed on 11/8/19.
//  Copyright © 2019 z510. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework



class CtegoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results <Category>?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        tableView.rowHeight = 65.0
    }
    
    // MARK: - Table view data source Methods
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Add yet"
        cell.backgroundColor = UIColor(hexString: categories? [indexPath.row].color ?? "‏3232ff" )
      

        return cell

    }
    
    // MARK: - Table view Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        //  saveCategories()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! toDo
        
        if let   indexpath = tableView.indexPathForSelectedRow {
            
            destinationVC.selctedCategory = categories? [indexpath.row]
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // Mark -> Realm Code
            
            let newCategory =  Category()
            
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            //        self.categories.append(newCategory)
            self.saveCategories(category: newCategory)
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            
            textField = field
            textField.placeholder = "Add new Category"
            
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //Mark -> Functions and data manipulation
    
    func saveCategories (category: Category){
        
        do{
            
            //       try context.save()
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print(" Error Saving context \(error)")
        }
        
        tableView.reloadData()
        
    }
    func loadData (){
        
        
        categories = realm.objects(Category.self)
        
        
        tableView.reloadData()
    }
    // Mark :-> Delete Data from Swipe
    
    override func updateModel(at IndexPath: IndexPath) {
        super.updateModel(at: IndexPath)
        if let categoryForDeletion = self.categories?[IndexPath.row]{
            
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                    print("Error deleting Cell , \(error)")
                }
            }
        }
    }
  




