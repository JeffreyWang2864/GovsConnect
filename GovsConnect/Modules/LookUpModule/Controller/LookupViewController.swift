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
    var filterWord: String? = nil
    var loginViewController: GCLoginRequireViewController?
    private var endEditingGestureRecongnizer: UITapGestureRecognizer!
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
        let lgr = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipeLeft(_:)))
        lgr.direction = .left
        let rgr = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipeRight(_:)))
        rgr.direction = .right
        self.endEditingGestureRecongnizer = UITapGestureRecognizer(target: self, action: #selector(self.endEditing(_:)))
        self.view.addGestureRecognizer(lgr)
        self.view.addGestureRecognizer(rgr)
        self.searchBar.delegate = self
        self.loginViewController = GCLoginRequireViewController.init(nibName: "GCLoginRequireViewController", bundle: Bundle.main)
        self.loginViewController!.view.frame = self.view.bounds
        if !AppIOManager.shared.isLogedIn{
            self.view.addSubview(self.loginViewController!.view)
            return
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func loginAction(_ sender: Notification){
        if AppIOManager.shared.isLogedIn{
            guard self.loginViewController != nil else{
                return
            }
            if self.loginViewController!.loginView != nil{
                self.loginViewController!.loginView!.dismiss(animated: false) {
                    //code here
                }
            }
            if self.loginViewController!.isThatYouView != nil{
                self.loginViewController!.isThatYouView!.dismiss(animated: false) {
                    //code
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.loginViewController!.view.removeFromSuperview()
            }
        }
        //log out
        self.view.addSubview(self.loginViewController!.view)
        self.loginViewController!.view.frame = self.view.bounds
    }
    
    @objc func didSwipeLeft(_ sender: UISwipeGestureRecognizer){
        if self.segmentControl.selectedSegmentIndex < 3{
            let newIndex = self.segmentControl.selectedSegmentIndex + 1
            self.segmentControl.move(to: newIndex)
            self.__selectedSegmentIndexDidChangeAction(newIndex)
        }
    }
    
    @objc func didSwipeRight(_ sender: UISwipeGestureRecognizer){
        if self.segmentControl.selectedSegmentIndex > 0 {
            let newIndex = self.segmentControl.selectedSegmentIndex - 1
            self.segmentControl.move(to: newIndex)
            self.__selectedSegmentIndexDidChangeAction(newIndex)
        }
    }
    
    @objc func endEditing(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
        self.searchBar.resignFirstResponder()
        self.view.removeGestureRecognizer(self.endEditingGestureRecongnizer)
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
        case .course:
            self.alphabeticalOrderDataSource = AppDataManager.shared.allCourse.sorted(){
                return AppDataManager.shared.users[$0]!.name < AppDataManager.shared.users[$1]!.name
            }
        case .club:
            self.alphabeticalOrderDataSource = AppDataManager.shared.allClub.sorted(){
                return AppDataManager.shared.users[$0]!.name < AppDataManager.shared.users[$1]!.name
            }
        case .admin:
            fatalError()
        }
        let filter = self.filterWord
        if filter != nil{
            self.alphabeticalOrderDataSource = self.alphabeticalOrderDataSource.filter { (item) -> Bool in
                return AppDataManager.shared.users[item]!.name.lowercased().range(of: filter!.lowercased()) != nil || UserDetailViewController.getDescriptionText(data: AppDataManager.shared.users[item]!).lowercased().range(of: filter!.lowercased()) != nil
            }
        }
    }
    
    private func __selectedSegmentIndexDidChangeAction(_ segmentIndex: Int){
        self.currentProfession = UserDataContainer.Profession(rawValue: segmentIndex)!
        self.updateAlphabeticalOrder()
        self.tableView.reloadData()
    }
}

extension LookupViewController: TwicketSegmentedControlDelegate{
    func didSelect(_ segmentIndex: Int) {
        self.__selectedSegmentIndexDidChangeAction(segmentIndex)
    }
}

extension LookupViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.alphabeticalOrderDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PERSON_TABLEVIEW_CELL", for: indexPath) as! PersonTableViewCell
        cell.uid = self.alphabeticalOrderDataSource[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.tableView.cellForRow(at: indexPath) as! PersonTableViewCell
        let vc = UserDetailViewController.init(nibName: "UserDetailViewController", bundle: Bundle.main)
        vc.view.frame = self.view.bounds
        vc.uid = item.uid
        self.navigationController!.pushViewController(vc, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension LookupViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.becomeFirstResponder()
        self.view.addGestureRecognizer(self.endEditingGestureRecongnizer)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.removeGestureRecognizer(self.endEditingGestureRecongnizer)
        self.searchBarTextDidEndEditing(searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            self.filterWord = nil
        }else{
            self.filterWord = searchText
        }
        self.updateAlphabeticalOrder()
        self.tableView.reloadData()
    }
}
