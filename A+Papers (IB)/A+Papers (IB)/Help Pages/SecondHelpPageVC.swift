//
//  SecondHelpPageVC.swift
//  A+Papers (IB)
//
//  Created by Danesh Rajasolan on 2020-01-19.
//  Copyright © 2020 Danesh Rajasolan. All rights reserved.
//

import UIKit

class SecondHelpPageVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    var isZooming = false
    var originalImageCenter : CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextLabel.font = boldFont
        let attributedString = NSMutableAttributedString(string: NSLocalizedString("Using AirPrint", comment: ""))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        titleTextLabel.attributedText = attributedString
        mainTextView.font = normalFont
        mainTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        mainTextView.text = NSLocalizedString("Ever wanted to print any paper  to show your friends or practise on physically?\n\nWe introduce AirPrint, our latest upcoming feature which allows users to download any paper that is on the app by simply clicking on the print icon on the top right corner, as shown in the screenshot below.", comment: "")
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
        self.imageView.addGestureRecognizer(pinch)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan(sender:)))
        pan.delegate = self
        self.imageView.addGestureRecognizer(pan)
        mainTextView.layer.zPosition = -1
        titleTextLabel.layer.zPosition = -1
    }
        
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
        
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            let currentScale = self.imageView.frame.size.width / self.imageView.bounds.size.width
            let newScale = currentScale*sender.scale
                
            if newScale > 1 {
                self.isZooming = true
            }
        } else if sender.state == .changed {
            guard let view = sender.view else {return}
            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                          y: sender.location(in: view).y - view.bounds.midY)
            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                    .scaledBy(x: sender.scale, y: sender.scale)
                    .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            let currentScale = self.imageView.frame.size.width / self.imageView.bounds.size.width
            var newScale = currentScale*sender.scale
                
            if newScale < 1 {
                newScale = 1
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                self.imageView.transform = transform
                sender.scale = 1
                    
            } else if newScale > 2.5 {
                newScale = 2.5
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                self.imageView.transform = transform
                sender.scale = 1
                    
            }else {
                view.transform = transform
                sender.scale = 1
            }
                
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            guard let center = self.originalImageCenter else {return}
            UIView.animate(withDuration: 0.3, animations: {
                self.imageView.transform = CGAffineTransform.identity
                self.imageView.center = center
            }, completion: { _ in
                self.isZooming = false
            })
        }
    }
    
    @objc func pan(sender: UIPanGestureRecognizer) {
        if self.isZooming && sender.state == .began {
            self.originalImageCenter = sender.view?.center
        } else if self.isZooming && sender.state == .changed {
            let translation = sender.translation(in: view)
            if let view = sender.view {
                view.center = CGPoint(x:view.center.x + translation.x,
                                          y:view.center.y + translation.y)
            }
            sender.setTranslation(CGPoint.zero, in: self.imageView.superview)
        } else if sender.state == .ended {
            guard let center = self.originalImageCenter else {return}
            self.imageView.transform = CGAffineTransform.identity
            self.imageView.center = center
        }
    }
}

