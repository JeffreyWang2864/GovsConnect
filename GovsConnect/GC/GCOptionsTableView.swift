//
//  GCOptionsTableView.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/7/6.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

typealias tableViewReturnOptionBlock = (Int, Int, String) -> (Bool)

class GCOptionsTableView: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var titleForRow = Array<Array<String>>()
    var didClickAction: tableViewReturnOptionBlock? = nil
    var currentSelection = IndexPath(item: 0, section: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GCOptionsTableView_cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titleForRow.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleForRow[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GCOptionsTableView_cell")!
        cell.textLabel!.text = self.titleForRow[indexPath.section][indexPath.item]
        cell.tintColor = APP_THEME_COLOR
        if indexPath == self.currentSelection{
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cancelSelectionCell = tableView.cellForRow(at: self.currentSelection)
        cancelSelectionCell!.accessoryType = .none
        let shouldSelectCell = tableView.cellForRow(at: indexPath)
        shouldSelectCell!.accessoryType = .checkmark
        self.currentSelection = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        if self.didClickAction!(indexPath.section, indexPath.item, self.titleForRow[indexPath.section][indexPath.item]){
            self.navigationController!.popViewController(animated: true)
        }
    }
}
