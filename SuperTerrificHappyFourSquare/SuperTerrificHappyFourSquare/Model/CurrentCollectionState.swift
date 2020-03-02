//
//  CurrentCollectionState.swift
//  SuperTerrificHappyFourSquare
//
//  Created by Cameron Rivera on 3/2/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation

enum CollectionState{
    case create
    case existing
    case tab
}

class CurrentCollectionState{
    static let shared = CurrentCollectionState()
    private var state: CollectionState
    private var currentVenue: Venue?
    
    private init(){
        state = CollectionState.tab
    }
    
    func updateCurrentState(_ state: CollectionState){
        self.state = state
    }
    
    func getCurrentState() -> CollectionState{
        return state
    }
    
    func getCurrentVenue() -> Venue?{
        return currentVenue
    }
    
    func updateCurrentVenue(_ venue: Venue?){
        currentVenue = venue
    }
}
