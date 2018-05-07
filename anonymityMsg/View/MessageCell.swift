//
//  MessageCell.swift
//  anonymityMsg
//
//  Created by Dadao on 2018/5/4.
//  Copyright © 2018 com.ZhuYunLong. All rights reserved.
//

import UIKit
class MesssageCell: UITableViewCell {
    private var contentLabel: UILabel?
    private var nameLabel: UILabel?
    var message: MessageModel? {
        didSet {
            self.contentLabel?.text = message?.message
            self.nameLabel?.text = message?.user_name
            self.contentLabel?.flex.markDirty()
            if(!((message?.user_name) != nil)) {
                self.nameLabel?.flex.isIncludedInLayout = false
            }else {
                self.nameLabel?.flex.isIncludedInLayout = true
                self.nameLabel?.flex.markDirty()
            }
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 12)
        self.contentView.addSubview(contentLabel)
        
        let nameLabel = UILabel()
        nameLabel.font = UIFont.italicSystemFont(ofSize: 12)
        self.contentView.addSubview(nameLabel)
        let backgroundView = UIView()
        backgroundView.layer.cornerRadius = 3
        backgroundView.backgroundColor = UIColor.white
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOpacity = 0.1
        backgroundView.layer.shadowRadius = 4
        backgroundView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.contentView.addSubview(backgroundView)
        self.contentView.flex.padding(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)).define { (flex) in
            flex.addItem(backgroundView).define({ (flex) in
                flex.addItem(contentLabel).margin(10, 15, 10, 15)
                flex.addItem(nameLabel).alignSelf(.start).margin(0, 15, 10, 15)
            })
            
        }
        
        self.contentLabel = contentLabel
        self.nameLabel = nameLabel
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.flex.layout(mode: .adjustHeight)
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.contentView.flex.layout(mode: .adjustHeight)
        return contentView.frame.size
    }
}
