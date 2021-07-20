

import UIKit

final class SimilarMovieListCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgMovieCover : UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgMovieCover.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imgMovieCover.layer.cornerRadius = 10.0
        imgMovieCover.clipsToBounds = true
    }
}
