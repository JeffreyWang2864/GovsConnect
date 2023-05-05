//
//  GCFuckShit.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/4/17.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

class GCFuckShit{
    private init(){}
    static func fuckBackSlashQuote(_ str: String) -> String{
        var ret = ""
        for a in str{
            let b = String(a)
            if b == "\'"{
                ret += "'"
            }else{
                ret += b
            }
        }
        return ret
    }
}
