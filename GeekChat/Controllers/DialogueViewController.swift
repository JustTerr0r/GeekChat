//
//  DialogueViewController.swift
//  GeekChat
//
//  Created by Stanislav Frolov on 27.04.2021.
//

import UIKit
import CoreData


class DialogueViewController: UIViewController {
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var chatID: Int = 0
    let emptyImage = UIImageView(image: UIImage(named: "empty"))
    let tabBar = TabBarController()
    
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var chatCollectionView: UICollectionView!
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var messages: [Chat] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filterMessage()
        tabBarController!.setTabBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        goDown()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Chat"
        setupButton()
        setDelegates()
        setEmpty()
    }
    
    private func filterMessage() {
        let id = String(self.chatID)
        let fetchRequest: NSFetchRequest<Chat> = Chat.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "chatID == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                emptyImage.isHidden = false
                emptyLabel.isHidden = false
            } else {messages = results}
            
        } catch let error as NSError {
            print(error.localizedDescription); return
        }
        self.chatCollectionView.reloadData()
    }
    
    private func setupButton() {
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func sendMessage() {
        if chatTextField.text?.isEmpty == false {
            emptyImage.isHidden = true
            emptyLabel.isHidden = true
            let userId = Int.random(in: 0...1)
            let chatText = chatTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let chatID = self.chatID
            
            guard let entity = NSEntityDescription.entity(forEntityName: "Chat", in: context) else { return }
            
            let taskObject = Chat(entity: entity, insertInto: context)
            taskObject.text = chatText
            taskObject.user = Int16(userId)
            taskObject.chatID = String(chatID)
            do {
                try context.save()
                messages.append(taskObject)
                self.chatCollectionView.reloadData()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            print(messages)
            chatTextField.text = ""
            
            goDown()
        } else {print("nil message")}
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -350
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    private func goDown() {
        let lastItem = self.messages.count - 1
        let index = IndexPath(item: lastItem, section: 0)
        self.chatCollectionView.scrollToItem(at: index, at: .bottom, animated: true)
    }
    
    private func setDelegates() {
        
        self.chatCollectionView.register(ChatCell.self, forCellWithReuseIdentifier: ChatCell.identifier)
        self.chatCollectionView.dataSource = self
        self.chatCollectionView.delegate = self
        
        view.backgroundColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1)
        chatCollectionView.backgroundColor = UIColor(red: 244/255, green: 243/255, blue: 243/255, alpha: 1)
    }
    
    private func setEmpty() {
        
        view.addSubview(emptyImage)
        emptyImage.translatesAutoresizingMaskIntoConstraints = false
        emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyImage.isHidden = true
        
        
        emptyLabel.text = "No messages yet..."
        emptyLabel.font = .boldSystemFont(ofSize: 18)
        emptyLabel.isHidden = true
        
        chatTextField.clearButtonMode = .whileEditing
        chatTextField.placeholder = NSLocalizedString("textFieldBack", comment: "")
    }
}

// Chat core
extension DialogueViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = chatCollectionView.dequeueReusableCell(withReuseIdentifier: ChatCell.identifier, for: indexPath) as? ChatCell {
            
            let chat = messages[indexPath.item]
            cell.messageTextView.text = chat.text
            
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            var estimatedFrame = NSString(string: chat.text ?? "nil").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            estimatedFrame.size.height += 18
            
            let maxValue = max(estimatedFrame.width, 100)
            estimatedFrame.size.width = maxValue
            
            
            if chat.user == 1 {
                
                cell.messageTextView.frame = CGRect(x: 48 + 8, y: 12, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: 48 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 16 + 12, height: estimatedFrame.height + 20 + 6)
                cell.bubbleImageView.image = ChatCell.grayBubbleImage
                cell.bubbleImageView.tintColor = .white
                cell.messageTextView.textColor = UIColor.black
            } else {
                cell.messageTextView.frame = CGRect(x: collectionView.bounds.width - estimatedFrame.width - 16 - 16 - 8 - 30, y: 12, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: collectionView.frame.width - estimatedFrame.width - 16 - 8 - 16 - 10 - 30, y: -4, width: estimatedFrame.width + 16 + 8 + 10, height: estimatedFrame.height + 20 + 6)
                cell.bubbleImageView.image = ChatCell.whiteBubbleImage
                cell.bubbleImageView.tintColor = UIColor(red: 217/255, green: 216/255, blue: 216/255, alpha: 1)
                cell.messageTextView.textColor = UIColor.black
            }
            
            return cell
        }
        
        return ChatCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let chat = messages[indexPath.item]
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        var estimatedFrame = NSString(string: chat.text ?? "nil").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
        estimatedFrame.size.height += 18
        
        return CGSize(width: chatCollectionView.frame.width, height: estimatedFrame.height + 20)
    }
}

