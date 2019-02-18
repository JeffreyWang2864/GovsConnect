//
//  SportsGame.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/2/10.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit

class SportsGame{
    let _uid: Int
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
    init(_ _uid: Int, _ catagory: GCSportType, _ team: GCSportTeamType, _ startTime
        : Date, _ homeTeam: String, _ awayTeam: String, _ homeScore: Int, _ awayScore: Int){
        self._uid = _uid
        self.catagory = catagory
        self.team = team
        self.startTime = startTime
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.homeScore = homeScore
        self.awayScore = awayScore
    }
}

func ==(left: SportsGame, right: SportsGame) -> Bool{
    if left._uid == right._uid{
        return true
    }
    return false
}
