//
//  CtegoryTableViewController.swift
//  toDoList
//
//  Created by Ahmed on 11/8/19.
//  Copyright © 2019 z510. All rights reserved.
//

import UIKit
import CoreData
class CtegoryTableViewController: UITableViewController {
    
    var categoryArr = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    // MARK: - Table view data source Methods
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        //      let categoryitems = categoryArr[indexPath.row]
        
        cell.textLabel?.text = categoryArr[indexPath.row].name
        
        return cell
        
    }
    
    
    
    // MARK: - Table view Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        saveCategories()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! toDo
        
        if let   indexpath = tableView.indexPathForSelectedRow {
            
            destinationVC.selctedCategory = categoryArr [indexpath.row]
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory =  Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArr.append(newCategory)
            self.saveCategories()
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            
            textField = field
            textField.placeholder = "Add new Category"
            
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //Mark -> Functions and data manipulation
    
    func saveCategories (){
        
        do{
            
            try context.save()
            
        }
        catch{
            print(" Error Saving context \(error)")
        }
        
        tableView.reloadData()
        
    }
    func loadData (){
        
        let request:NSFetchRequest <Category> = Category.fetchRequest()
        
        do{
           categoryArr = try context.fetch(request)
        }
            
        catch{
            
            print(" Error Saving context \(error)")
        }
        tableView.reloadData()
    }
    
}




