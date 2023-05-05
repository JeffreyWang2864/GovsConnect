//
//  SportsGame.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/2/10.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit
import MapKit

class SportsGame{
    let _uid: String
    let catagory: GCSportType
    let team: GCSportTeamType
    let startTime: Date
    var isHome: Bool{
        get{
            return self.homeTeam == "The Governor's Academy"
        }
    }
    let homeTeam: String
    let awayTeam: String
    var homeScore: Int
    var awayScore: Int
    let location: CLLocation
    var stat = SportsTeamStat()
    var result: SportsGameResult{
        get{
            if self.homeScore == -1{
                //match haven't start yet
                if self.startTime.timeIntervalSinceNow > 0{
                    //match in future tense
                    return .yetToBeStarted
                }
                //match in progress, but score not updated yet
                return .inProgress
            }
            //there's score
            
            //if it's golf
            if self.catagory == .golf && self.homeScore > 20 && self.awayScore > 20{
                if self.homeScore == self.awayScore{
                    return .draw
                }
                if (self.homeScore > self.awayScore && self.isHome) || (self.awayScore > self.homeScore && !self.isHome){
                    //govs lost
                    return .defeat
                }
                //govs won
                return .victory
            }
            
            if self.homeScore == self.awayScore{
                //draw
                return .draw
            }
            if (self.homeScore > self.awayScore && self.isHome) || (self.awayScore > self.homeScore && !self.isHome){
                //govs won
                return .victory
            }
            //govs lost
            return .defeat
        }
    }
    
    init(_ _uid: String, _ catagory: GCSportType, _ team: GCSportTeamType, _ startTime
        : Date, _ homeTeam: String, _ awayTeam: String, _ homeScore: Int, _ awayScore: Int, _ latitude: Double, _ longitude: Double){
        self._uid = _uid
        self.catagory = catagory
        self.team = team
        self.startTime = startTime
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.homeScore = homeScore
        self.awayScore = awayScore
        self.location = CLLocation.init(latitude: latitude, longitude: longitude)
    }
}

func ==(left: SportsGame, right: SportsGame) -> Bool{
    if left._uid == right._uid{
        return true
    }
    return false
}
