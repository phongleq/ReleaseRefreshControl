//
//  RefreshControl.swift
//  ReleaseRefreshControl
//
//  Created by Phong Le on 3/27/17.
//  Copyright © 2017 Phong Le. All rights reserved.
//

import UIKit

public enum RefreshState {
    case idle
    case pulling
    case threshold
    case refreshing
}

internal extension String {
    static let contentOffset = "contentOffset"
    static let isDragging = "pan.state"
}

open class RefreshControl: UIControl {
    open var isRefreshing:Bool = false
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard let scrollView = self.superview as? UIScrollView else {
            return
        }
        
        scrollView.addObserver(self, forKeyPath: .contentOffset, options: [.new], context: nil)
        scrollView.addObserver(self, forKeyPath: .isDragging, options: [.new], context: nil)
    }
    
    deinit {
        guard let scrollView = self.superview as? UIScrollView else {
            return
        }
        
        scrollView.removeObserver(self, forKeyPath: .contentOffset)
        scrollView.removeObserver(self, forKeyPath: .isDragging)
    }
    
    open func updatedWithState(state:RefreshState) {
        preconditionFailure("This method must be overridden")
    }
    
    open func endRefresh() {
        guard let scrollView = self.superview as? UIScrollView else {
            return
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            scrollView.contentInset = .zero
            self.updatedWithState(state: .idle)
        })
        
        isRefreshing = false
    }
}
