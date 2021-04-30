//
//  ChatViewController.swift
//  GeekChat
//
//  Created by Stanislav Frolov on 24.04.2021.
//

import UIKit
import CoreData

class ChatViewController: UIViewController {
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var list: [Int] = []
    var chatList: [ChatID] = []
    var chat: [Chat] = []
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "ChatTableViewCell")
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = 88
        return tableView
    }()
    
    let startButton = UIButton(backgroundColor: .black,
                               title: NSLocalizedString("newChat", comment: ""),
                               font: .boldSystemFont(ofSize: 18),
                               shadow: true, titleColor: .white)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController!.setTabBarHidden(false, animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchChats()
        fetchList()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = NSLocalizedString("chats", comment: "")
        setupTableView()
        setupSearchBar()
        if chatList.isEmpty {
            startButton.isHidden = false
        }
    }
    
    private func fetchChats() {
        let fetchRequest: NSFetchRequest<Chat> = Chat.fetchRequest()
        do {
            chat = try context.fetch(fetchRequest)
            self.tableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func fetchList() {
        let fetchRequest: NSFetchRequest<ChatID> = ChatID.fetchRequest()
        do {
            chatList = try context.fetch(fetchRequest)
            self.tableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        guard chatList.count > 0 else {
            return
        }
        for i in 1...chatList.count{
            list.append(i)
        }
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add,
                                                                 target: self,
                                                                 action: #selector(rightHandAction))
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    private func setupTableView(){
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.showsVerticalScrollIndicator = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.heightAnchor.constraint(equalToConstant: 53).isActive = true
        startButton.widthAnchor.constraint(equalToConstant: 183).isActive = true
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        startButton.isHidden = true
        startButton.addTarget(self, action: #selector(rightHandAction), for: .touchUpInside)
        
    }
    
    @objc func rightHandAction() {
        let index = list.count
        self.list.append(index + 1)
        startButton.isHidden = true
        
        guard let entity = NSEntityDescription.entity(forEntityName: "ChatID", in: context) else { return }
        
        let taskObject = ChatID(entity: entity, insertInto: context)
        taskObject.iD = String(list.last!)
        do {
            try context.save()
            self.tableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}


extension ChatViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}


// Configure TableView
extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            switch indexPath.section {
            case 0:
                tableView.deleteRows(at: [indexPath], with: .automatic)
            default:
                return
            }
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        cell.titleLabel.text = "Last message from this \(indexPath.row + 1) chat"
        cell.timeLabel.text = "16:20"
        cell.clipsToBounds = true
        cell.backgroundColor = UIColor.black
        cell.contentView.layer.masksToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let vC = storyboard.instantiateViewController(identifier: "DialogueViewController") as! DialogueViewController
        
        let id = list[indexPath.row]
        vC.chatID = id
        navigationController?.pushViewController(vC, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = 12
        
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.white.cgColor
        maskLayer.cornerRadius = 8
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
}
