//
//  RefreshControlHead.swift
//  ReleaseRefreshControl
//
//  Created by Phong Le on 3/27/17.
//  Copyright © 2017 Phong Le. All rights reserved.
//

import UIKit

open class RefreshControlHead: RefreshControl {
    open var refreshHeight:CGFloat = 65
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard let scrollView = self.superview as? UIScrollView else {
            return
        }
        
        let width = scrollView.frame.width
        self.frame = CGRect(x: 0, y: -refreshHeight, width: width, height: refreshHeight)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == .isDragging {
            guard let scrollView = object as? UIScrollView else { return }
            guard !isRefreshing else { return }
            if scrollView.contentOffset.y < 0 && scrollView.contentOffset.y > -refreshHeight {
                UIView.animate(withDuration: 0.5, animations: { 
                    scrollView.contentInset = .zero
                })
            }
        }
        
        if keyPath == .contentOffset{
            guard let scrollView = object as? UIScrollView else { return }
            guard !isRefreshing else { return }
            
            let offset = scrollView.contentOffset.y
            
            if offset == 0 {
                isRefreshing = false
                updatedWithState(state: .idle)
                scrollView.contentInset = .zero
            }
            
            if offset <= -refreshHeight {
                updatedWithState(state: .threshold)
                
                if !scrollView.isDragging {
                    updatedWithState(state: .refreshing)
                    
                    isRefreshing = true
                    
                    sendActions(for: .valueChanged)
                }
                var contentInset = scrollView.contentInset
                contentInset.top = refreshHeight
                scrollView.contentInset = contentInset
            }  else {
                updatedWithState(state: .pulling)
            }
            
            
            let width = scrollView.frame.width
            self.frame = CGRect(x: 0, y: -refreshHeight, width: width, height: refreshHeight)
        }
    }
    
    override open func updatedWithState(state:RefreshState) {
    }
}
