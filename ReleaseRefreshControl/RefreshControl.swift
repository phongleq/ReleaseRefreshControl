//
//  RefreshControl.swift
//  ReleaseRefreshControl
//
//  Created by Phong Le on 3/27/17.
//  Copyright © 2017 Phong Le. All rights reserved.
//

import UIKit

enum RefreshState {
    case idle
    case pulling
    case threshold
    case refershing
}

internal extension String {
    static let contentOffset = "contentOffset"
}

open class RefreshControl: UIControl {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard let scrollView = self.superview as? UIScrollView else {
            return
        }
        
        scrollView.addObserver(self, forKeyPath: .contentOffset, options: [.initial,.new], context: nil)
    }
    
    deinit {
        guard let scrollView = self.superview as? UIScrollView else {
            return
        }
        
        scrollView.removeObserver(self, forKeyPath: .contentOffset)
    }
    
    func updatedWithState(state:RefreshState) {
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
    }
}
