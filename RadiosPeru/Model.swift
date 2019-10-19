//
//  Model.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct RadioStation {
    
    var name: String
    var image: String
    var description : String
    
    
    
    static func createStations() -> [RadioStation] {
        var stations:[RadioStation] = []
        
        //Grupo RPP
        stations.append( RadioStation(name: "RPP", image: "rpp", description: "") )
        stations.append( RadioStation(name: "Capital", image: "capital", description: "") )
        stations.append( RadioStation(name: "Studio 92", image: "studio92", description: "") )
        stations.append( RadioStation(name: "Corazón", image: "corazon", description: "") )
        stations.append( RadioStation(name: "Oxigeno", image: "oxigeno", description: "Lima 87.1 FM") )
        stations.append( RadioStation(name: "La Zona", image: "lazona", description: "") )
        stations.append( RadioStation(name: "Felicidad", image: "felicidad", description: "") )
        
        //Grupo CRP
        stations.append( RadioStation(name: "Ritmo Romántica", image: "ritmoromantica", description: "") )
        stations.append( RadioStation(name: "La Inolvidable", image: "inolvidable", description: "") )
        stations.append( RadioStation(name: "Moda", image: "moda", description: "") )
        stations.append( RadioStation(name: "Oasis", image: "oasis", description: "") )
        stations.append( RadioStation(name: "Radiomar", image: "radiomar", description: "") )
        stations.append( RadioStation(name: "Nueva Q", image: "nuevaq", description: "") )
        stations.append( RadioStation(name: "Planeta", image: "planeta", description: "") )
        
        
        
        
        
        
        
        return stations
    }
}
