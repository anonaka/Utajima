//
//  UtajimaModel.swift
//  Utajima
//
//  Created by nonaka on 2014/11/22.
//  Copyright (c) 2014年 nonaka@mac.com. All rights reserved.
//

import UIKit
import MediaPlayer

class UtajimaModel: NSObject {
    
    var musicList = []

    override init(){
        println("hi utajmamodel")
        super.init()
        self.listupAllMusics()
    }
    
    func listupAllMusics(){
        let sq = MPMediaQuery.songsQuery()
        var songs = sq.items
        for item in songs {
            println(item.title)
        }
    }
}
