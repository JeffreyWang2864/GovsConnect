//
//  SportsTeamStat.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/4/20.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit

class SportsTeamStat{
    var numberOfWin: Int
    var numberOfDraw: Int
    var numberOfLose: Int
    var goalScore: Int
    var goalAgainst: Int
    var totalMatch: Int{
        return self.numberOfWin + self.numberOfDraw + self.numberOfLose
    }
    var winRate: Double{
        if self.numberOfLose == 0{
            return -1.0
        }
        return Double(self.numberOfWin) / Double(self.totalMatch)
    }
    var scoreAgainstRatio: Double{
        if self.goalAgainst == 0{
            return -1.0
        }
        return Double(self.goalScore) / Double(self.goalAgainst)
    }
    
    init(_ w: Int, _ d: Int, _ l: Int, _ gs: Int, _ ga: Int){
        self.numberOfWin = w
        self.numberOfDraw = d
        self.numberOfLose = l
        self.goalScore = gs
        self.goalAgainst = ga
    }
    
    init(){
        self.numberOfWin = 0
        self.numberOfDraw = 0
        self.numberOfLose = 0
        self.goalScore = 0
        self.goalAgainst = 0
    }
}
