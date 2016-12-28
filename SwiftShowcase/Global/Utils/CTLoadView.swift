//
//  CTLoadView.swift
//  SwiftShowcase
//
//  Created by cedro_nds on 02/12/16.
//  Copyright © 2016 Victor Freitas. All rights reserved.
//
//  Change values in variables center, bottom, top for modify position loadView
//
//
import UIKit
import Foundation

class CTLoadView: NSObject {
    
    //MARK: Components
    var loadView = UIView()
    let activityIndicator = UIActivityIndicatorView()
    var viewPosition : CGPoint = CGPoint(x: 0, y: 0)
    
    //MARK: Variables
    var bottom: CGFloat = 100
    var top: CGFloat = 30
    
    func createLoadView(message:String, view:UIView, position:String){
    
        let viewFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
        loadView.frame = viewFrame
        loadView.layer.cornerRadius = 2
        loadView.backgroundColor = UIColor.black
        loadView.backgroundColor?.withAlphaComponent(0.7)

        
        
        let label = UILabel()
        label.text = message
        label.font = UIFont(name: "Savoye LET", size: 22)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.frame = CGRect(x: 0, y: loadView.center.y - 25, width: self.loadView.frame.width, height: 22)
        
        loadView.addSubview(label)
    
        if position == "center" {
            viewPosition = view.center
        }else if position == "bottom"{
            let centerX = view.center.x
            let centerY = view.center.y
            viewPosition = CGPoint(x: centerX, y: centerY + bottom)
            
        }else{
            let centerX = view.center.x
            let centerY = view.center.y
            viewPosition = CGPoint(x: centerX, y: centerY + top)
            
        }
        
        let centerIndicatorX = loadView.center.x
        let centerIndicatorY = loadView.center.y + 15
        let centerIndicator = CGPoint(x: centerIndicatorX, y: centerIndicatorY)
        activityIndicator.center = centerIndicator
        loadView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        loadView.center = viewPosition
        loadView.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
         view.addSubview(self.loadView)
         self.loadView.alpha = 1
        })
       
        view.isUserInteractionEnabled = false
    
    }

    func removeLoadView(view: UIView){
        activityIndicator.stopAnimating()
        loadView.alpha = 1
        
        UIView.animate(withDuration: 0.5, animations: {
            self.loadView.alpha = 0
            self.loadView.removeFromSuperview()

        })
        
         view.isUserInteractionEnabled = true
    }
}
