//
//  ViewController.swift
//  toDoList
//
//  Created by z510 on 11/1/19.
//  Copyright © 2019 z510. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class toDo: SwipeTableViewController, UISearchBarDelegate {
    
    
    var toDoItems : Results <Items>?
    let realm = try! Realm()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var   selctedCategory : Category? {
        
        didSet{
            
            loadData()
             
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 65.0
    }
    
    override func viewWillAppear(_ animated: Bool) {

        title = selctedCategory!.name
        if let colourHex = selctedCategory?.color {

                guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller error not add")}
            if let    navBarColour = UIColor(hexString: colourHex){
            
            searchBar.barTintColor = navBarColour
                navBar.barTintColor = navBarColour
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                navBar.largeTitleTextAttributes =   [NSAttributedString.Key.foregroundColor:ContrastColorOf(navBarColour, returnFlat: true)]
                
                
        }
        }

        
    }

    override func viewWillDisappear(_ animated: Bool) {
       updateNavBar(withHexCode: "9D99D1")
    }
    //MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colourHexCode: String){
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError()}
        
        navBar.barTintColor = navBarColour
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor = navBarColour
        
    }
    
    

    // Mark DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "doCell", for: indexPath)
        
        if   let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let  colour = 	UIColor(hexString: selctedCategory!.color)?.darken (byPercentage: CGFloat ( indexPath.row ) / CGFloat (toDoItems!.count) / 3) {
                
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            cell.accessoryType = item.done ?  .checkmark :  .none
            
            
        }else {
            
            cell.textLabel?.text = "No item Add"
        }
        
        
        return cell
    }
    
    // Mark :-> Delete Data from Swipe
    
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
    
    public func loadData (){
        
        toDoItems = selctedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    
    // Mark :-> Delete Data from Swipe
    
    override func updateModel(at IndexPath: IndexPath) {
        super.updateModel(at: IndexPath)
        if let categoryForDeletion = self.toDoItems?[IndexPath.row]{
            
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting Cell , \(error)")
            }
        }
    }
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


