//
//  noteTableViewCell.swift
//  notepad
//
//  Created by Никита on 19.03.2021.
//

import UIKit

class noteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var noteImageView: UIImageView!
    @IBOutlet weak var noteTitile: UILabel!
    @IBOutlet weak var noteDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Styles
        shadowView.layer.shadowColor =  UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        shadowView.layer.shadowRadius = 1.5
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.cornerRadius = 2
        
        noteImageView.layer.cornerRadius = 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    func configureCell(note: Note) {
        
        self.noteTitile.text = note.title
        self.noteDescription.text = note.text
        if let image = note.image {
            self.noteImageView.image = UIImage(data: image as Data)
        }
        else {
            self.noteImageView.image = UIImage(systemName: "note.text")
        }
        
    }
    
    
}
