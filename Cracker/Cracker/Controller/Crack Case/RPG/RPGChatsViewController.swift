//
//  RPGChatroomViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/15.
//

import UIKit

class RPGChatsViewController: UIViewController {
    
    @IBOutlet weak var chatsTableView: UITableView!

    let geofenceManager = GeofenceManager.shared
    
    var charContents: [CharContent] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupTableView()
    }
    
    func setupTableView() {
        
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
    }
}

extension RPGChatsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return demoRpgCase.charContent!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatsTBCell") as! ChatsTBCell
        
        cell.senderImage.image = demoRpgCase.charContent![indexPath.row].image
        
        cell.senderImage.layer.cornerRadius = cell.senderImage.frame.width / 2
        
        cell.senderName.text = demoRpgCase.charContent?[indexPath.row].name
        
        if geofenceManager.didEnter == true || geofenceManager.alreadyInside == true {
            
            let charContent = demoRpgCase.charContent?[indexPath.row]
            
            if geofenceManager.identifiers.contains(charContent!.id) {
                
                cell.recentMessage.text = charContent!.talks.randomElement()
                
                cell.unreadMessageCount.text = "1"
                
                cell.unreadMessageCount.layer.cornerRadius = cell.unreadMessageCount.frame.width / 2
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
}
