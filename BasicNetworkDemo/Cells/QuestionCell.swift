//
//  TableViewCell.swift
//  TrueOverflow-JerryWang
//
//  Created by Jerry Wang on 5/12/19.
//  Copyright © 2019 Jerry Wang. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {

    @IBOutlet weak var questionTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //hmm...should I implement this method to reset the contents of a cell? The docs say I should actually do that in tableView(cellForRowAt:)
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
