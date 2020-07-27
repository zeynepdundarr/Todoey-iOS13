//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category?{
        didSet{
            loadFile()
        }
    }
    
    let realm = try! Realm()
    var todoItems : Results<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    //MARK: - <tableViewDataSource>
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.string
            cell.accessoryType = item.done ? .checkmark : .none
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                print("color in todo is \(color)")
            }
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        //cell.backgroundColor = selectedCategory?.color
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write{
                    item.done = !item.done
                }
                
            }catch{
                print("error in loading in didSelectRowAt \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        var textField = UITextField()
        let alert = UIAlertController(title:" Add a todo in \(selectedCategory!.name)", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if self.selectedCategory != nil{
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.string = textField.text!
                        newItem.date = Date()
                        self.selectedCategory?.items.append(newItem)
                    }
                }catch{
                    print("error saving context is: \(error)")
                }
            }
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion : nil)
    }
    
    
    func loadFile(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "string")
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath){

        if let item = todoItems?[indexPath.row]{
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

//MARK: UISearchBarDelegate

extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("string CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0{
            loadFile()
            DispatchQueue.main.async{
                searchBar.resignFirstResponder()
            }
        }
    }
    
}



