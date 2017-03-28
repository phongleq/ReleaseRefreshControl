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
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == .contentOffset {
            guard let scrollView = object as? UIScrollView else { return }
            
            let height = scrollView.frame.height
            let contentHeight = scrollView.contentSize.height
            let offSet = scrollView.contentOffset.y
            
            if scrollView.contentOffset.y == contentHeight {
                isRefreshing = false
                updatedWithState(state: .idle)
            }
            
            if scrollView.contentOffset.y + height >= contentHeight + refreshHeight && scrollView.isDragging {
                updatedWithState(state: .threshold)
            } else if offSet > 0, offSet + height >= contentHeight + refreshHeight, !isRefreshing {
                var contentInset = scrollView.contentInset
                contentInset.bottom = refreshHeight
                scrollView.contentInset = contentInset
                updatedWithState(state: .refreshing)
                
                isRefreshing = true
                
                sendActions(for: .valueChanged)
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
