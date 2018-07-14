//
//  LookupViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/7/13.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit
import TwicketSegmentedControl
import IQKeyboardManagerSwift

class LookupViewController: UIViewController {
    @IBOutlet var segmentControl: TwicketSegmentedControl!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var currentProfession = UserDataContainer.Profession.student
    var alphabeticalOrderDataSource = Array<String>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateAlphabeticalOrder()
        self.segmentControl.setSegmentItems(["club", "course", "faculty", "student"])
        self.segmentControl.move(to: self.currentProfession.rawValue)
        self.segmentControl.sliderBackgroundColor = APP_THEME_COLOR
        self.segmentControl.delegate = self
        self.tableView.register(UINib(nibName: "PersonTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PERSON_TABLEVIEW_CELL")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func updateAlphabeticalOrder(){
        switch self.currentProfession{
        case .student:
            self.alphabeticalOrderDataSource = AppDataManager.shared.allStudent.sorted(){
                return AppDataManager.shared.users[$0]!.name < AppDataManager.shared.users[$1]!.name
            }
        case .facalty:
            self.alphabeticalOrderDataSource = AppDataManager.shared.allFaculty.sorted(){
                return AppDataManager.shared.users[$0]!.name < AppDataManager.shared.users[$1]!.name
            }
        }
    }
}

extension LookupViewController: TwicketSegmentedControlDelegate{
    func didSelect(_ segmentIndex: Int) {
        self.currentProfession = UserDataContainer.Profession(rawValue: segmentIndex)!
        self.updateAlphabeticalOrder()
        self.tableView.reloadData()
    }
}

extension LookupViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alphabeticalOrderDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PERSON_TABLEVIEW_CELL", for: indexPath) as! PersonTableViewCell
        cell.uid = self.alphabeticalOrderDataSource[indexPath.item]
        return cell
    }
}
