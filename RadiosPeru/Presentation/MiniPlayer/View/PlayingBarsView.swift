//
//  PlayingBarsView.swift
//  RadiosPeru
//
//  Created by Jeans on 10/25/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class PlayingBarsViews {
    
    class func createFrames() -> [UIImage] {
        
        var animationFrames = [UIImage]()
        for i in 0...3 {
            if let image = UIImage(named: "NowPlayingBars-\(i)") {
                animationFrames.append(image)
            }
        }
        
        for i in stride(from: 2, to: 0, by: -1) {
            if let image = UIImage(named: "NowPlayingBars-\(i)") {
                animationFrames.append(image)
            }
        }
        return animationFrames
    }
    
}
