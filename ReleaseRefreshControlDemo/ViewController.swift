//
//  ViewController.swift
//  ReleaseRefreshControlDemo
//
//  Created by Phong Le on 3/27/17.
//  Copyright © 2017 Phong Le. All rights reserved.
//

import UIKit
import ReleaseRefreshControl

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var refreshHeader:Header!
    var refreshFooter:Footer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let refreshHeader = Header()
        refreshHeader.backgroundColor = .red
        refreshHeader.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        
        self.refreshHeader = refreshHeader
        
        tableView.addSubview(refreshHeader)
        
        let refreshFooter = Footer()
        refreshFooter.backgroundColor = .blue
        refreshFooter.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        
        self.refreshFooter = refreshFooter
        
        tableView.addSubview(refreshFooter)
        
        
    }
    
    func refresh(sender:Any) {
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.refreshHeader.endRefresh()
            self.refreshFooter.endRefresh()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
}

class Header: RefreshControlHead {
    override func updatedWithState(state:RefreshState) {
        
    }
}

class Footer: RefreshControlFoot {
    override func updatedWithState(state:RefreshState) {
        if state == .refreshing {
            print("Bye")
        }
    }
}
