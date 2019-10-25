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
    var city: String
    var frecuency: String
    var slogan: String
    
    static func createStations() -> [RadioStation] {
        var stations:[RadioStation] = []
        
        //Grupo RPP
        stations.append( RadioStation(name: "RPP", image: "rpp", city: "Lima", frecuency: "89.7 FM", slogan: "Confianza por todos los medios"))
        stations.append( RadioStation(name: "Capital", image: "capital", city: "Lima",  frecuency: "96.7 FM", slogan: "Tu Opinion Importa") )
        stations.append( RadioStation(name: "Studio 92", image: "studio92", city: "Lima", frecuency: "92.5FM", slogan: "Primeros en tu Música") )
        stations.append( RadioStation(name: "Corazón", image: "corazon", city: "Lima", frecuency: "94.3 FM", slogan: "Única como tú") )
        stations.append( RadioStation(name: "Oxigeno", image: "oxigeno", city: "Lima", frecuency: "102.1 FM", slogan: "Clásicos del rock & pop") )
        stations.append( RadioStation(name: "La Zona", image: "lazona", city: "Lima", frecuency: "90.5 FM", slogan: "¡Tu música urbana!") )
        stations.append( RadioStation(name: "Felicidad", image: "felicidad", city: "Lima", frecuency: "88.9 FM", slogan: "La música de tu vida") )
        
        //Grupo CRP
        stations.append( RadioStation(name: "Ritmo Romántica", image: "ritmoromantica", city: "Lima", frecuency: "93.1 FM", slogan: "Tu radio de baladas") )
        stations.append( RadioStation(name: "Moda", image: "moda", city: "Lima", frecuency: "97.3 FM", slogan: "Te mueve! ... con la música que esta de moda") )
        stations.append( RadioStation(name: "Oasis", image: "oasis", city: "Lima", frecuency: "100.1 FM", slogan: "Oasis, Rock & pop") )
        stations.append( RadioStation(name: "Radiomar", image: "radiomar", city: "Lima", frecuency: "106.3 FM", slogan: "¡Vive gozando!") )
        stations.append( RadioStation(name: "Nueva Q", image: "nuevaq", city: "Lima", frecuency: "107.1 FM", slogan: "¡QQQumbia!") )
        stations.append( RadioStation(name: "Planeta", image: "planeta", city: "Lima", frecuency: "107.7 FM", slogan: "Tu música en inglés") )
        
        return stations
    }
}
