

import UIKit

extension UITableView {
	func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
		guard let lastIndexPath = indexPathsForVisibleRows?.last else {
			return false
		}

		return lastIndexPath == indexPath
	}
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: (self.bounds.size.height/2)))
        messageLabel.text = message
        if #available(iOS 13.0, *) {
            messageLabel.textColor = .white
        } else {
            messageLabel.textColor = .white
        }
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "SFProDisplay-Bold", size: 35)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
    }
        
        func restore() {
            self.backgroundView = nil
            self.separatorStyle = .none
        }
}
