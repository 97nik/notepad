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
    
    @IBOutlet weak var imageView: UIImageView!
    var notes = [Note]()
    var note: Note?
    var closure: ((Note) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let note = note {
            titleTextField.text = note.title
            textView.text = note.text
            if let image = note.image {
                imageView?.image = UIImage(data: image as Data)
            }
            else {
                imageView?.image = UIImage(systemName: "note.text")
            }
        }
        
    }
    @IBAction func buttom(_ sender: Any) {
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    
    
    @IBAction func doneButtom(_ sender: Any) {
        guard let title = titleTextField.text else {return}
        guard let text = textView.text else {return}
        guard let image = imageView.image?.pngData else {return}
        
        if note == nil{
            StorageManager.shared.save(title,text,image()) { note in
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
extension noteViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imageView.image = image
            
            if let data = self.imageView.image!.jpegData(compressionQuality: 1.0) {
                note?.image = data as NSData as Data
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}




