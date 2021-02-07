//
//  ViewController+Ext.swift
//  PromiseKit_Tutorial
//
//  Created by Jeff Jeong on 2021/02/07.
//


import Foundation
import UIKit

fileprivate var indicatorContainerView : UIView?

extension UIViewController{
    
    func showLoading(){
        indicatorContainerView = UIView(frame: self.view.bounds)
        indicatorContainerView?.backgroundColor = #colorLiteral(red: 0.2179596256, green: 0.2179596256, blue: 0.2179596256, alpha: 0.2136791426)
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        indicator.center = indicatorContainerView!.center
        indicator.startAnimating()
        indicatorContainerView?.addSubview(indicator)
        self.view.addSubview(indicatorContainerView!)
    }
    
    func hideLoading() {
        indicatorContainerView?.removeFromSuperview()
        indicatorContainerView = nil
    }
    
}
