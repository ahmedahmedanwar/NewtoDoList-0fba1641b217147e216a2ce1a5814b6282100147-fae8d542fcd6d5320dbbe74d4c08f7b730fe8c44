//
//  CtegoryTableViewController.swift
//  toDoList
//
//  Created by Ahmed on 11/8/19.
//  Copyright © 2019 z510. All rights reserved.
//

import UIKit
import RealmSwift

class CtegoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results <Category>?
    
    //  var categoryArr = [Category]()
    
    //    let context = (UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          loadData()
    }
    
    // MARK: - Table view data source Methods
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        //      let categoryitems = categoryArr[indexPath.row]
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Add yet"
        
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
            
            // Mark -> Core data code
            //            let newCategory =  Category(context: self.context)
            
            // Mark -> Realm Code
            
            let newCategory =  Category()
            
            newCategory.name = textField.text!
            
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
        
        
        //        // Mark -> Core data code
        //        //      let request:NSFetchRequest <Category> = Category.fetchRequest()
        //
        //        do{
        //            categoryArr = try context.fetch(request)
        //        }
        //
        //        catch{
        //
        //            print(" Error Saving context \(error)")
        //        }
        tableView.reloadData()
    }
    
}




