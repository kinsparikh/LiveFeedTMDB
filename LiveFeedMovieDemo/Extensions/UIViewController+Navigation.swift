

import Foundation
import UIKit

private var actionKeyForLeftButton: Void?
private var actionKeyForRightButton: Void?

struct AlertAction {
    let buttonTitle: String
    let handler: (() -> Void)?
}

struct SingleButtonAlert {
    let title: String
    let message: String?
    let action: AlertAction
}

extension UIViewController{
    
    private var _actionLeft: (() -> ())? {
        get {
            return objc_getAssociatedObject(self, &actionKeyForLeftButton) as? () -> ()
        }
        set {
            objc_setAssociatedObject(self, &actionKeyForLeftButton, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var _actionRight: (() -> ())? {
        get {
            return objc_getAssociatedObject(self, &actionKeyForRightButton) as? () -> ()
        }
        set {
            objc_setAssociatedObject(self, &actionKeyForRightButton, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func configureNavigationWithAction(_ title:String? ,leftImage: UIImage?,actionForLeft: (() -> ())?,rightImage: UIImage?,actionForRight: (() -> ())?){
        self._actionLeft = actionForLeft
        self._actionRight = actionForRight
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1696988046, green: 0.1906097233, blue: 0.2814527452, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(),for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font :  UIFont(name: "AvenirNext-Bold", size: 22) ?? UIFont()
        ]

        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

        if title != nil{
            self.title = title!
        }
        if leftImage != nil{
            let leftButton = UIBarButtonItem(image: leftImage, style: .plain, target: self, action: #selector(leftButtonTappedwithDemo))
            leftButton.tintColor = .white
            self.navigationItem.leftBarButtonItem = leftButton
        }
        if rightImage != nil{
            let rightButton = UIBarButtonItem(image: rightImage, style: .plain, target: self, action: #selector(rightButtonTappedwithDemo))
            rightButton.tintColor = .white
            self.navigationItem.rightBarButtonItem = rightButton
        }
        
        
    }
    @objc private func leftButtonTappedwithDemo(){
        if self._actionLeft != nil{
            self._actionLeft!()
        }
    }
    @objc private func rightButtonTappedwithDemo(){
        if self._actionRight != nil{
            self._actionRight!()
        }
    }
    
    func presentSingleButtonDialog(alert: SingleButtonAlert) {
            DispatchQueue.main.async {[weak self] in
                let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: alert.action.buttonTitle, style: .default, handler: { _ in alert.action.handler?() }))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    
    func presentNetworkError(error: NetworkError?) {
        guard let error = error else {
            self.presentSingleButtonDialog(alert: SingleButtonAlert(title: "Unknown Error", message: "please try again later.", action: AlertAction(buttonTitle: "OK", handler: {})))
            return
        }
        var alert: SingleButtonAlert?
        switch error {
        case .unauthorized:
            alert = SingleButtonAlert(title: "API Error", message: "Your API Key might be wrong", action: AlertAction(buttonTitle: "OK", handler: {}))
        case .unknown:
            alert = SingleButtonAlert(title: "Unknown Error", message: "please try again later.", action: AlertAction(buttonTitle: "OK", handler: {}))
        case .noJSONData:
            alert = SingleButtonAlert(title: "Data Error", message: "Data returned is empty", action: AlertAction(buttonTitle: "OK", handler: {}))
        case .JSONDecoder:
            alert = SingleButtonAlert(title: "Data Error", message: "Data returned is not in the correct format", action: AlertAction(buttonTitle: "OK", handler: {}))
        }
        guard let finalAlert = alert else { return }
        self.presentSingleButtonDialog(alert: finalAlert)
    }
}


