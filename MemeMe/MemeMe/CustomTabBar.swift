//
//  CustomTabBar.swift
//  MemeMe
//
//  Created by Kinan Turjman on 4/10/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBar : UITabBar {

    var isVisible = true
    
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        
        isVisible = visible
        // zero duration means no animation
        let duration:NSTimeInterval = (animated ? 0.3 : 0.0)
        
        UIView.animateWithDuration(duration) {
            self.frame = CGRectOffset(frame, 0, offsetY)
            return
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return isVisible
    }
}