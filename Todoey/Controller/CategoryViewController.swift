//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Zeynep on 29.06.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: SwipeTableViewController {
    
    var categArray : Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFile()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categArray?[indexPath.row].name ?? "no text in category cell yet"
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categArray?[indexPath.row]
        }
    }
    
    
    @IBAction func addButtonPressed2(_ sender: Any) {
       
        var textField = UITextField()
              let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
              let action = UIAlertAction(title: "Add a new category", style: .default){ (action) in
                  
                  let newCateg = Category()
                  newCateg.name = textField.text!
                  self.saveFile(category: newCateg)
                  self.tableView.reloadData()
              }
              alert.addTextField { (categTextField) in
                  textField = categTextField
              }
              alert.addAction(action)
              present(alert, animated: true, completion: nil)
             
    }

  
    func saveFile(category: Category){
        do {
            try realm.write{
                realm.add(category)
            }
        } catch  {
            print("Error in saving a category \(category)")
        }
    }
    
    
    func loadFile(){
        categArray = realm.objects(Category.self)
    }
    
    
    override func updateModel(at indexPath: IndexPath){

        if let item = categArray?[indexPath.row]{
            do {
                try realm.write{
                    realm.delete(item)
                }
            }catch{
                print("error in deleting \(error)")
            }
        }

    }
}



