//
//  ChatTableViewCell.swift
//  GeekChat
//
//  Created by Stanislav Frolov on 25.04.2021.
//

import UIKit
import SnapKit

class ChatTableViewCell: UITableViewCell {
    let titleLabel : UILabel = {
            let lbl = UILabel ()
            lbl.textColor = .white
            lbl.font = UIFont.boldSystemFont(ofSize: 18)
            lbl.textAlignment = .left
            lbl.numberOfLines = 1
            lbl.adjustsFontSizeToFitWidth = false
            return lbl
        }()
    
    let timeLabel : UILabel = {
            let lbl = UILabel ()
            lbl.textColor = .white
            lbl.font = UIFont.systemFont(ofSize: 13)
            lbl.textAlignment = .center
            lbl.numberOfLines = 0
            lbl.adjustsFontSizeToFitWidth = false
            return lbl
        }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabels()
        
    }
    
    private func setupLabels() {
        addSubview(titleLabel)
        addSubview(timeLabel)
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().inset(15)
            maker.left.equalTo(contentView.snp.left).inset(20)
        }
        
        timeLabel.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().multipliedBy(0.95)
            maker.bottom.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
