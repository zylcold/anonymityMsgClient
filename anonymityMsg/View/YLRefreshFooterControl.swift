//
//  YLRefreshFooterControl.swift
//  anonymityMsg
//
//  Created by Yun on 2018/5/5.
//  Copyright © 2018 com.ZhuYunLong. All rights reserved.
//

import UIKit

class YLRefreshFooterControl: UIControl {
    open var isRefreshing: Bool = false
    open var attributedTitle: NSAttributedString?
    fileprivate weak var scrollView: UIScrollView?
    fileprivate var scrollViewInsets: UIEdgeInsets = UIEdgeInsets.zero
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        self.backgroundColor = .yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // May be used to indicate to the refreshControl that an external event has initiated the refresh action
    open func beginRefreshing() {
        guard self.isRefreshing == true || self.isHidden == true else{
            return
        }
        self.isRefreshing = true
        self.sendActions(for: .valueChanged)
    }
    
    // Must be explicitly called when the refreshing has completed
    open func endRefreshing() {
        self.isRefreshing = false
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.scrollView = self.superview as? UIScrollView
        DispatchQueue.main.async {
            [weak self] in
            self?.scrollViewInsets = self?.scrollView?.contentInset ?? UIEdgeInsets.zero
            self?.scrollView?.contentInset.bottom = (self?.scrollViewInsets.bottom ?? 0) + (self?.bounds.size.height ?? 0)
            var rect = self?.frame ?? CGRect.zero
            rect.origin.y = self?.scrollView?.contentSize.height ?? 0.0
            self?.frame = rect
        }
    }

}

private var kYLRefreshFooterKey: Void?
extension UIScrollView {
    var refreshFooterControl: YLRefreshFooterControl? {
        get { return (objc_getAssociatedObject(self, &kYLRefreshFooterKey) as? YLRefreshFooterControl) }
        set(newValue) { objc_setAssociatedObject(self, &kYLRefreshFooterKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
}
