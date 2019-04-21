//
//  SportsBrowseByCategoryViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/4/19.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit

class SportsBrowseByCategoryViewController: UIViewController {
    var thingsTodoAfterDismiss: (() -> ())?
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SPORTS_BROWSE_BY_CATEGORY_TABLEVIEW_CELL_ID")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }


    @IBAction func didClickOnCancel(_ sender: UIButton){
        AppDataManager.shared.sportsBrowseByCategoryData = []
        self.exitView()
    }
    
    private func exitView(){
        self.dismiss(animated: true) {
            UIApplication.shared.statusBarStyle = .lightContent
            if self.thingsTodoAfterDismiss != nil{
                self.thingsTodoAfterDismiss!()
            }
        }
    }
}

extension SportsBrowseByCategoryViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GCSportTeamType.allCases.count - 1 //disallow __default__ to show
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SPORTS_BROWSE_BY_CATEGORY_TABLEVIEW_CELL_ID", for: indexPath)
        let data = GCSportTeamType.allCases[indexPath.row]
        cell.textLabel!.text = data.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedTeam = GCSportTeamType.allCases[indexPath.item]
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        self.present(alert, animated: true, completion: nil)
        AppIOManager.shared.getGameDataByTeam(team: selectedTeam, {
            alert.dismiss(animated: true){
                if AppDataManager.shared.sportsBrowseByCategoryData.count == 0{
                    let alert = UIAlertController(title: "No game data for this season", message: "did not find sports data related to \(selectedTeam.rawValue) on server. ", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    self.exitView()
                }
            }
        }) { (errStr) in
            alert.dismiss(animated: true){
                let alert = UIAlertController(title: "Failed when loading game data", message: errStr, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
