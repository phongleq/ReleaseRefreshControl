//
//  RefreshControlFoot.swift
//  ReleaseRefreshControl
//
//  Created by Phong Le on 3/27/17.
//  Copyright © 2017 Phong Le. All rights reserved.
//

import UIKit

open class RefreshControlFoot: RefreshControl {
    open var refreshHeight:CGFloat = 65
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard let scrollView = self.superview as? UIScrollView else {
            return
        }
        let width = scrollView.frame.width
        let contentHeight = scrollView.contentSize.height
        self.frame = CGRect(x: 0, y: contentHeight, width: width, height: refreshHeight)
        
        self.isHidden = contentHeight == 0
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == .isDragging {
            guard let scrollView = object as? UIScrollView else { return }
            guard !isRefreshing else { return }
            
            let height = scrollView.frame.height
            let contentHeight = scrollView.contentSize.height
            let offSet = scrollView.contentOffset.y
            
            if offSet + height > contentHeight && offSet + height < contentHeight + refreshHeight {
                UIView.animate(withDuration: 0.5, animations: {
                    scrollView.contentInset = .zero
                })
            }
        }
        
        if keyPath == .contentOffset {
            guard let scrollView = object as? UIScrollView else { return }
            guard !isRefreshing else { return }
            
            let height = scrollView.frame.height
            let contentHeight = scrollView.contentSize.height
            let offSet = scrollView.contentOffset.y
            
            guard offSet > 0 && contentHeight > height else {
                self.isHidden = true
                return
            }
            
            self.isHidden = false
            
            if scrollView.contentOffset.y == contentHeight {
                isRefreshing = false
                updatedWithState(state: .idle)
                scrollView.contentInset = .zero
            }
            
            if offSet + height >= contentHeight + refreshHeight {
                updatedWithState(state: .threshold)
                if !scrollView.isDragging { 
                    updatedWithState(state: .refreshing)
                    
                    isRefreshing = true
                    
                    sendActions(for: .valueChanged)
                }
                
                var contentInset = scrollView.contentInset
                contentInset.bottom = refreshHeight
                scrollView.contentInset = contentInset
            } else {
                updatedWithState(state: .pulling)
            }
            
            let width = scrollView.frame.width
            self.frame = CGRect(x: 0, y: contentHeight, width: width, height: refreshHeight)
        }
    }
    
    override open func updatedWithState(state:RefreshState) {
    }
}
