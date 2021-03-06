//
//  YLRefreshFooterControl.swift
//  anonymityMsg
//
//  Created by Yun on 2018/5/5.
//  Copyright © 2018 com.ZhuYunLong. All rights reserved.
//

import UIKit

class YLRefreshFooterControl: UIControl {
    open var isRefreshing: Bool
    open var autoRefresh: Bool = true
    fileprivate var tipLabel: UILabel?
    fileprivate weak var scrollView: UIScrollView?
    fileprivate var scrollViewInsets: UIEdgeInsets = UIEdgeInsets.zero
    public init() {
        self.isRefreshing = false
        self.tipLabel = UILabel()
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        self.addSubview(self.tipLabel!)
        self.tipLabel?.center = self.center
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func beginRefreshing() {
        guard self.isRefreshing == false && self.isHidden == false else{
            return
        }
        self.isRefreshing = true
        self.sendActions(for: .valueChanged)
    }
    
    // Must be explicitly called when the refreshing has completed
    open func endRefreshing() {
        self.isRefreshing = false
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.scrollView?.removeObserver(self, forKeyPath: "contentSize")
        self.scrollView?.removeObserver(self, forKeyPath: "contentOffset")
        self.scrollView?.contentInset.bottom += self.bounds.height
        
    }
    
    override func willRemoveSubview(_ subview: UIView) {
        subview.willRemoveSubview(subview)
        self.scrollView?.removeObserver(self, forKeyPath: "contentSize")
        self.scrollView?.removeObserver(self, forKeyPath: "contentOffset")
        self.scrollView?.contentInset.bottom -= self.bounds.height
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.scrollView = self.superview as? UIScrollView
        
        if let scroll = self.scrollView {
            scroll.addObserver(self, forKeyPath: "contentSize", options: .initial, context: nil)
            scroll.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
        }
        DispatchQueue.main.async {
            [weak self] in
            self?.scrollViewInsets = self?.scrollView?.contentInset ?? UIEdgeInsets.zero
            self?.scrollView?.contentInset.bottom = (self?.scrollViewInsets.bottom ?? 0) + (self?.bounds.size.height ?? 0)
            var rect = self?.frame ?? CGRect.zero
            rect.origin.y = self?.scrollView?.contentSize.height ?? 0.0
            self?.frame = rect
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let tipLabel = self.tipLabel {
            let size = tipLabel.sizeThatFits(CGSize(width: 200, height: 44))
            let rect = CGRect(origin: .zero, size: size)
            tipLabel.frame = rect
            tipLabel.center = self.center
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            
            var rect = self.frame
            rect.origin.y = self.scrollView?.contentSize.height ?? 0.0
            self.frame = rect
            
        }
        
        if keyPath == "contentOffset" {
            
            guard let scroll = self.scrollView else {
                return
            }
            
            let offsetY = scroll.contentOffset.y
            let contentSizeH = scroll.contentSize.height
            
            guard self.isRefreshing == false && self.isHidden == false else{
                return
            }
            
            guard offsetY > 300 else {
                return
            }

            guard (contentSizeH-offsetY) < (scroll.bounds.height-(scroll.adjustedContentInset.top) + 100 + self.bounds.height) else {
                return
            }
            
            if self.autoRefresh {
                self.beginRefreshing()
            }
        }
        
    }

}

private var kYLRefreshFooterKey: Void?
extension UIScrollView {
    var refreshFooterControl: YLRefreshFooterControl? {
        get { return (objc_getAssociatedObject(self, &kYLRefreshFooterKey) as? YLRefreshFooterControl) }
        set(newValue) {
            guard let subView = newValue else {
                return
            }
            self.addSubview(subView)
            objc_setAssociatedObject(self, &kYLRefreshFooterKey, subView, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            
        }
    }
}
