//
//  LoadingPlayerView.swift
//  RadiosPeru
//
//  Created by Jeans on 10/25/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class LoadingPlayerView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpAnimation(size: CGSize, color: UIColor, imageName: String) {
        
        let duration: CFTimeInterval = 0.75
        
        // Rotate animation
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.values = [0, Double.pi, 2 * Double.pi]
        
        // Animation
        let animation = CAAnimationGroup()
        
        animation.animations = [rotateAnimation]
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        //Add Play Image
        let newScaleSize = CGSize(width: size.width * 0.5 ,
                             height: size.height * 0.5)
        let image = getImage(with : newScaleSize, image: imageName)
        
        let frameImage = CGRect(x: (layer.bounds.size.width - newScaleSize.width) / 2,
                                y: (layer.bounds.size.height - newScaleSize.height) / 2,
                                width: size.width,
                                height: size.height)
        
        image.frame = frameImage
        layer.addSublayer(image)
        
        
        // Draw circle
        let sizeForCircle = CGSize(width: size.width * 0.65,
                                   height: size.height * 0.65)
        let circle = getRingThirdFour(size: sizeForCircle, color: color)
        let frame = CGRect(x: (layer.bounds.size.width - sizeForCircle.width) / 2,
                           y: (layer.bounds.size.height - sizeForCircle.height) / 2,
                           width: sizeForCircle.width,
                           height: sizeForCircle.height)
        
        circle.frame = frame
        circle.add(animation, forKey: "animation")
        
        layer.addSublayer(circle)
    }
    
    //MARK: - Helpers
    
    private func getImage(with size: CGSize, image: String) -> CALayer {
        let imageWith = size.width
        let imageHeight = size.height
        
        let frame = CGRect(x: (size.width - imageWith) / 2,
                           y: (size.width - imageWith) / 2,
                           width: imageWith,
                           height: imageHeight)
        let image = UIImage(named: image)
        let playImageView = UIImageView(image: image)
        playImageView.contentMode = .scaleAspectFit
        playImageView.frame = frame
        
        let layer: CAShapeLayer = CAShapeLayer()
        layer.addSublayer( playImageView.layer )
        
        return layer
    }
    
    private func getRingThirdFour(size: CGSize, color: UIColor) -> CAShapeLayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        
        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: size.width / 2,
                    startAngle: CGFloat(-3 * Double.pi / 4),
                    endAngle: CGFloat(-Double.pi / 4),
                    clockwise: false)
        layer.fillColor = nil
        layer.strokeColor = color.cgColor
        layer.lineWidth = 2
        
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        return layer
    }

}
