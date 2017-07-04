//
//  NoteCell.swift
//  Notes
//
//  Created by Marcel Harvan on 2017-04-04.
//  Copyright © 2017 The Marcel's fake Company. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet weak var lblNote: UILabel!
    
    func configureCell(notes: Notes){
        lblNote.attributedText = notes.note_content as? NSAttributedString
    }


}
