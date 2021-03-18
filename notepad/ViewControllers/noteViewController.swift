//
//  noteViewController.swift
//  notepad
//
//  Created by Никита on 18.03.2021.
//

import UIKit
import CoreData

class noteViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    var notes = [Note]()
    var note: Note?
    var closure: ((Note) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.text = note?.title
        textView.text = note?.text
        
    }
    
    @IBAction func doneButtom(_ sender: Any) {
        guard let title = titleTextField.text else {return}
        guard let text = textView.text else {return}
        
        if note == nil{
            StorageManager.shared.save(title,text) { note in
                self.closure?(note)
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true)
            }
        } else {
            if let note = note {
                DispatchQueue.main.async {
                    StorageManager.shared.edit(note, title: title, text: text)
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}




