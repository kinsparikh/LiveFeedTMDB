//
//  LoadingCell.swift
//  TheMovieDB
//
//  Created by Mina Mikhael on 27.05.20.
//  Copyright © 2020 MoviesDB. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {
    static let cellIdentifier = String(describing: LoadingCell.self)
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
}
