//
//  ChatCell.swift
//  GeekChat
//
//  Created by Stanislav Frolov on 28.04.2021.
//

import UIKit

class ChatCell: BaseCollectionViewCell {
    
    static let identifier = String(describing: ChatCell.self)
    static let grayBubbleImage = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    static let whiteBubbleImage = UIImage(named: "bubble")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    var messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = ""
        textView.backgroundColor = UIColor.clear
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    var textBubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()
    
    var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ChatCell.whiteBubbleImage
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        imageView.layer.shadowColor = UIColor(red: 228/255, green: 34/255, blue: 45/255, alpha: 1).cgColor
        imageView.layer.shadowRadius = 4
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
        
        textBubbleView.addSubview(bubbleImageView)
        addConstraintsWithVisualStrings(format: "H:|[v0]|", views: bubbleImageView)
        addConstraintsWithVisualStrings(format: "V:|[v0]|", views: bubbleImageView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.messageTextView.text = nil
    }
    
}
