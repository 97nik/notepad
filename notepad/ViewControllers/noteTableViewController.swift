//
//  noteTableViewController.swift
//  notepad
//
//  Created by Никита on 18.03.2021.
//

import UIKit
import CoreData

class noteTableViewController: UITableViewController {


    private var notes = StorageManager.shared.fetchData()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title
        cell.imageView?.image = UIImage(systemName: "note.text")

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


