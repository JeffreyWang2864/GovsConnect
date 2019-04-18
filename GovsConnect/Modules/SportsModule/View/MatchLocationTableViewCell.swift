//
//  MatchLocationTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/2/10.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit
import MapKit

class MatchLocationTableViewCell: UITableViewCell, GCAnimatedCell {
    @IBOutlet var mapView: MKMapView!
    var artwork: GCArtwork?
    @IBOutlet var resetMapViewButton: UIButton!
    
    var data: SportsGame?{
        didSet{
            let location = self.data!.location
            let coordRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
            self.mapView.setRegion(coordRegion, animated: false)
            self.artwork = GCArtwork.init(self.data!.homeTeam, "school", location.coordinate)
            self.mapView.addAnnotation(self.artwork!)
            self.resetMapViewButton.backgroundColor = UIColorFromRGB(rgbValue: 0x006FFF, alpha: 1.0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mapView.clipsToBounds = true
        self.mapView.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.backgroundColor = APP_BACKGROUND_ULTRA_GREY
        self.layer.cornerRadius = 15
        self.resetMapViewButton.clipsToBounds = true
        self.resetMapViewButton.layer.cornerRadius = 6
        self.resetMapViewButton.setTitle("reset", for: .normal)
        self.resetMapViewButton.setTitleColor(UIColor.white, for: .normal)
        self.resetMapViewButton.titleLabel!.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.resetMapViewButton.addTarget(self, action: #selector(self.resetMapViewButtonDidClick(_:)), for: .touchDown)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func becomeLive() {
        if(self.artwork != nil){
            self.mapView.selectAnnotation(self.artwork!, animated: true)
        }
    }
    
    func endLive() {
        if(self.artwork != nil){
            self.mapView.deselectAnnotation(self.artwork!, animated: true)
        }
    }
    
    @objc func resetMapViewButtonDidClick(_ sender: UIButton){
        if(self.artwork != nil){
            let coordRegion = MKCoordinateRegionMakeWithDistance(self.artwork!.coordinate, 1000, 1000)
            self.mapView.setRegion(coordRegion, animated: true)
        }
    }
}
