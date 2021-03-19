//
//  noteTableViewController.swift
//  notepad
//
//  Created by Никита on 18.03.2021.
//

import UIKit
import CoreData

class noteTableViewController: UITableViewController{
    
    private var notes = StorageManager.shared.fetchData()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var filterNotes: [Note] = []
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        //searchController.isActive = true
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "editNote")
        {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let noteDetail = segue.destination as! noteViewController
            
            let selectedNote = notes[indexPath.row]
            noteDetail.note = selectedNote
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
        else  {
            guard let destination = segue.destination as? noteViewController else { return }
            destination.closure = { [weak self] note in
                DispatchQueue.main.async {
                    self?.notes.insert(note, at: 0)
                    self?.tableView.reloadData()
                }
            }
            
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.boldSystemFont(ofSize: 17)
            
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filterNotes.count : notes.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteTableViewCell", for: indexPath) as! noteTableViewCell
        
        let note = isFiltering ? filterNotes[indexPath.row]
            : notes[indexPath.row]
        cell.configureCell(note: note)
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
}

extension noteTableViewController {
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.shared.delete(note)
        }
    }
}


// MARK: - UISearchResultsUpdating
extension  noteTableViewController: UISearchResultsUpdating , UISearchBarDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filterNotes = notes.filter { note in
            (note.title?.lowercased().contains(searchText.lowercased()) ?? false)
        }
        tableView.reloadData()
    }
}
