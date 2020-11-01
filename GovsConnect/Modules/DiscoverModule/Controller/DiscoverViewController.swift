//
//  DiscoverViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/29.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
    @IBOutlet var mainView: GCWaterfallScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        self.mainView.frame = self.view.bounds
        self.mainView.cellHeight = UIScreen.main.bounds.size.height / 7 * 3
        for i in stride(from: 0, to: AppDataManager.shared.discoverData.count, by: 1) {
            let v = DiscoverBasicCellView()
            v.data = AppDataManager.shared.discoverData[i]
            let gr = UITapGestureRecognizer(target: self, action: #selector(self.didClickOnDiscoverFunction(_:)))
            v.tag = i
            v.addGestureRecognizer(gr)
            self.mainView.cells.append(v)
        }
        self.mainView.arrangeCells()
        // Do any additional setup after loading the view.
        
        //am pm showing preference
        if let ans = AppDataManager.shared.deviceSetting["did_ask_prefer_question"], ans != "yes"{
            self.askTimePreference()
        }
    }
    
    @objc func didClickOnDiscoverFunction(_ sender: UITapGestureRecognizer){
        switch sender.view!.tag{
        case 0:
            // weekend event
            let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            loadingIndicator.startAnimating();
            alert.view.addSubview(loadingIndicator)
            self.present(alert, animated: true, completion: nil)
            AppIOManager.shared.loadWeekendEventData({ (isSucceed) in
                alert.dismiss(animated: true){
                    let vc = WeekendDetailViewController.init(nibName: "WeekendDetailViewController", bundle: Bundle.main)
                    self.navigationController!.pushViewController(vc, animated: true)
                }
            }) { (errStr) in
                alert.dismiss(animated: true){
                    makeMessageViaAlert(title: "Failed when loading weekend event", message: errStr)
                }
            }
        case 1:
            // modified shedule
            
            let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            loadingIndicator.startAnimating();
            alert.view.addSubview(loadingIndicator)
            self.present(alert, animated: true, completion: nil)
            
            AppIOManager.shared.loadModifiedScheduleData({ (isSucceed) in
                //success handler
                alert.dismiss(animated: true){
                    if AppDataManager.shared.discoverModifiedScheduleData.count == 0{
                        makeMessageViaAlert(title: "The schedule is normal today", message: "")
                    }else{
                        let vc = ModifiedScheduleViewController.init(nibName: "ModifiedScheduleViewController", bundle: Bundle.main)
                        self.navigationController!.pushViewController(vc, animated: true)
                    }
                }
            }) { (errStr) in
                alert.dismiss(animated: true){
                    makeMessageViaAlert(title: "Fail to load modified schedule data", message: errStr)
                }
            }
        case 2:
            //rate your food
//            guard AppIOManager.shared.connectionStatus != .none else{
//                let alert = UIAlertController(title: "Sorry, you cannot rate foods on offline mode:(", message: "Your device is not connecting to the Internet.", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//                self.navigationController!.present(alert, animated: true, completion: nil)
//                return
//            }
//            let vc = NewFoodViewController.init(nibName: "NewFoodViewController", bundle: Bundle.main)
//            self.navigationController!.pushViewController(vc, animated: true)
            
            
            
            let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            loadingIndicator.startAnimating();
            alert.view.addSubview(loadingIndicator)
            self.present(alert, animated: true, completion: nil)
            AppIOManager.shared.loadFoodDataThisWeek({ (isSucceed) in
                alert.dismiss(animated: true){
                    let vc = DiningHallMenuViewController.init(nibName: "DiningHallMenuViewController", bundle: Bundle.main)
                    self.navigationController!.pushViewController(vc, animated: true)
                }
            }) { (errStr) in
                alert.dismiss(animated: true){
                    makeMessageViaAlert(title: "Failed when loading food data", message: errStr)
                }
            }

        case 3:
            //links
            let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            loadingIndicator.startAnimating();
            alert.view.addSubview(loadingIndicator)
            self.present(alert, animated: true, completion: nil)
            AppIOManager.shared.loadLinkData({ (isSucceed) in
                alert.dismiss(animated: true){
                    let vc = LinksViewController.init(nibName: "LinksViewController", bundle: Bundle.main)
                    vc.view.frame = self.view.bounds
                    self.navigationController!.pushViewController(vc, animated: true)
                }
            }) { (errStr) in
                alert.dismiss(animated: true){
                    makeMessageViaAlert(title: "Failed when loading links", message: errStr)
                }
            }
        case 4:
            //more
            let vc = UIViewController()
            vc.view.frame = self.view.bounds
            vc.view.backgroundColor = APP_BACKGROUND_LIGHT_GREY
            vc.navigationItem.title = "More..."
            
            let cardBackgroundWidthOffset: CGFloat = {
                switch PHONE_TYPE{
                case .ipodtouch:
                    return 60
                case .iphone8:
                    return 60
                default:
                    return 50
                }
            }()
            let cardBackgroundHeightOffset: CGFloat = {
                switch PHONE_TYPE{
                case .ipodtouch:
                    return 45
                default:
                    return 95
                }
            }()
            let cardBackgroundFontSize: CGFloat = {
                switch PHONE_TYPE{
                case .ipodtouch:
                    return 14
                case .iphone8:
                    return 16
                default:
                    return 18
                }
            }()
            
            let cardBackgroundView = UIView(frame: CGRect(x: 25, y: 25, width: screenWidth - cardBackgroundWidthOffset, height: vc.view.frame.size.height - cardBackgroundHeightOffset))
            cardBackgroundView.backgroundColor = UIColor.white
            cardBackgroundView.layer.cornerRadius = 20
            let titleLabel = UILabel(frame: CGRect(x: 10, y: 20, width: screenWidth - 50 - 20, height: 60))
            titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            titleLabel.text = "Want to add a new discover page?"
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            
            let descriptionLabel = UILabel(frame: CGRect(x: 10, y: 90, width: screenWidth - 50 - 20, height: cardBackgroundView.frame.size.height - 90 - 20))
            descriptionLabel.font = UIFont.systemFont(ofSize: cardBackgroundFontSize, weight: .regular)
            descriptionLabel.text = "    The Govs Connect crews always encourage users to publish their own discovery page. We promote pages that bring conveniences and benefits to our community. Please contact us without hesitation once you got an idea. However, publishing something public to the entire school should not be taken lightly. A review of your application between faculty and developers is necessary. Accepted applications are supposed to have a high “market requirement”, which can solve issues from (or bring advantages to) the majorities. More importantly, your application must adhere to the school rules. Once you have your idea ready, you may send us a feedback(go to \"You\" tab -> feedback button). You may also talk with us in person. We cannot wait to hear your ideas!"
            descriptionLabel.numberOfLines = 0
            descriptionLabel.sizeToFit()
            cardBackgroundView.addSubview(titleLabel)
            cardBackgroundView.addSubview(descriptionLabel)
            vc.view.addSubview(cardBackgroundView)
            self.navigationController!.pushViewController(vc, animated: true)
        default:
            NSLog("\(sender.view!.tag)")
        }
    }
    
    private func askTimePreference(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            let predicate = NSPredicate(format: "key == %@", "time_display_preference")
            let res = AppPersistenceManager.shared.filterObject(of: .setting, with: predicate) as! Array<Setting>
            if res.count == 0{
                //am pm not decided yet
                let perferenceAlertController = UIAlertController(title: "I prefer", message: nil, preferredStyle: .alert)
                perferenceAlertController.addAction(UIAlertAction(title: "14:00", style: .default, handler: { (alert) in
                    AppPersistenceManager.shared.saveObject(to: .setting, with: ["time_display_preference", "international"])
                    AppDataManager.shared.deviceSetting["time_display_preference"] = "international"
                    AppDataManager.shared.deviceSetting["did_ask_prefer_question"] = "yes"
                }))
                perferenceAlertController.addAction(UIAlertAction(title: "2:00 PM", style: .default, handler: { (alert) in
                    AppPersistenceManager.shared.saveObject(to: .setting, with: ["time_display_preference", "us"])
                    AppDataManager.shared.deviceSetting["time_display_preference"] = "us"
                    AppDataManager.shared.deviceSetting["did_ask_prefer_question"] = "yes"
                }))
                self.present(perferenceAlertController, animated: true, completion: nil)
            }
        }
    }
}
