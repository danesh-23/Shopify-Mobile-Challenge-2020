//
//  FirstTimeVC2.swift
//  A+Papers (IB)
//
//  Created by Danesh Rajasolan on 2020-02-01.
//  Copyright © 2020 Danesh Rajasolan. All rights reserved.
//

import UIKit

class FirstTimeVC2: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    var isZooming = false
    var originalImageCenter : CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = NSLocalizedString("Once you click on the AirPrint icon, we will present a popup where you can choose the printer you would like to use (that supports AirPrint) and customize various properties such as black or white or number of copies etc.\n\nThen click Print and youre done. Hope you enjoy :)", comment: "")
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
            self.imageView.addGestureRecognizer(pinch)
            let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan(sender:)))
            pan.delegate = self
            self.imageView.addGestureRecognizer(pan)
            textView.layer.zPosition = -1
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
                var newScale = currentScale * sender.scale
                
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
                    
                } else {
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
            }
        }
    }
