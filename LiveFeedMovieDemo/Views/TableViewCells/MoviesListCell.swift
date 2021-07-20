//
//  MoviesListTableCellTableViewCell.swift
//  LiveFeedMovieDemo
//
//  Created by Kayaan on 15/06/21.
//  Copyright © 2021 Kayaan Parikh. All rights reserved.
//

import UIKit

class MoviesListCell: UITableViewCell {
    
    @IBOutlet weak var btnBook: UIButton!
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var lblMovieReleaseDate: UILabel!
    @IBOutlet weak var lblMovieDescription: UILabel!
    @IBOutlet weak var innerView: UIView!
    var buttoPress : (() -> Void)? = nil


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnBook.roundCornersBook([.topLeft, .bottomRight], radius: 8)
        self.viewShadow(view: innerView)
        imgMovie.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imgMovie.layer.cornerRadius = 10.0
        imgMovie.clipsToBounds = true
    }
    
    func viewShadow(view : UIView){
        let radius: CGFloat = view.frame.width / 2.0 //change it to .height if you need spread for height
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1.98 * radius, height: view.frame.height))
        //Change 2.1 to amount of spread you need and for height replace the code for height

        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.5, height: 0.4)  //Here you control x and y
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 6.0 //Here your control your blur
        view.layer.masksToBounds =  false
        view.layer.shadowPath = shadowPath.cgPath
    }
    
    @IBAction func btnAction(sender: UIButton){
            if let btnAction = self.buttoPress
            {
                btnAction()
            }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
