//
//  HudView.swift
//  MyLocations
//
//  Created by Giovanni Gaffé on 2021/3/21.
//

import UIKit

class HudView: UIView {
 
    var text  = ""
    
    class func hud(inView view: UIView, animated: Bool) -> HudView {
        let hudView = HudView(frame: view.bounds)
        hudView.isOpaque = false
        
        view.addSubview(hudView)
        view.isUserInteractionEnabled = false
     
        return hudView
        
    }
}
