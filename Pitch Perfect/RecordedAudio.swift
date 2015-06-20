//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Kamlesh Bokdia on 18/05/15.
//  Copyright (c) 2015 Kamlesh Bokdia. All rights reserved.
//

import Foundation

class RecordedAudio{
    var filePathURL:NSURL!
    var title:String!
    
    init(title:String!,filePathURL:NSURL!){
        self.filePathURL = filePathURL
        self.title = title
    }
}