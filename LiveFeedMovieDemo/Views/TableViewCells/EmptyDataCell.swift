//
//  EmptyDataCell.swift
//  TheMovieDB
//
//  Created by Mina Mikhael on 29.05.20.
//  Copyright © 2020 MoviesDB. All rights reserved.
//

import UIKit

class EmptyDataCell: UITableViewCell {
    static let cellIdentifier = String(describing: EmptyDataCell.self)
    @IBOutlet weak var emptyMessageLabel: UILabel!
}
