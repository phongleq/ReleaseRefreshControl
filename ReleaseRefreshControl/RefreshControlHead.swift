//
//  RefreshControlHead.swift
//  ReleaseRefreshControl
//
//  Created by Phong Le on 3/27/17.
//  Copyright © 2017 Phong Le. All rights reserved.
//

import UIKit

public class RefreshControlHead: RefreshControl {
    var refreshHeight:CGFloat = 65
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard let scrollView = self.superview as? UIScrollView else {
            return
        }
        
        let width = scrollView.frame.width
        self.frame = CGRect(x: 0, y: -refreshHeight, width: width, height: refreshHeight)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == .contentOffset{
            guard let scrollView = object as? UIScrollView else { return }
            
            if scrollView.contentOffset.y == 0 {
                updatedWithState(state: .idle)
            }
            
            if scrollView.contentOffset.y <= -refreshHeight && scrollView.isDragging {
                updatedWithState(state: .threshold)
            } else if scrollView.contentOffset.y <= -refreshHeight {
                var contentInset = scrollView.contentInset
                contentInset.top = refreshHeight
                scrollView.contentInset = contentInset
                updatedWithState(state: .refershing)
                
                sendActions(for: .valueChanged)
            } else {
                updatedWithState(state: .pulling)
            }
            
            
            let width = scrollView.frame.width
            self.frame = CGRect(x: 0, y: -refreshHeight, width: width, height: refreshHeight)
        }
    }
    
    override func updatedWithState(state:RefreshState) {
    }
}