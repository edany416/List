//
//  NotesTableViewCell.swift
//  List
//
//  Created by edan yachdav on 3/14/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

protocol NotesViewDelegate {
    func didTapNotesView(_ notes: String)
}

class NotesTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var notesTextView: UITextView!
    
    var notesViewDelegate: NotesViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        notesTextView.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(notesTextViewTapped))
        notesTextView.superview?.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc private func notesTextViewTapped() {
        notesViewDelegate?.didTapNotesView(notesTextView.text)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
