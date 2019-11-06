//
//  Model.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

enum GroupStation {
    case RPP(String)
    case CRP(String)
}

struct RadioStation {
    var name: String
    var image: String
    var city: String
    var frecuency: String
    var slogan = "Default Slogan"
    var urlStream: String
    var group: GroupStation
    
    var isFavorite: Bool
}

class StationsManager {
    
    static let shared = StationsManager()
    
    private var stations: [RadioStation]!
    
    lazy var allStations: [RadioStation] = {
        return stations
    }()
    
    //MARK: - Initializers
    
    private init() {
        stations = createStations()
    }
    
    //MARK: - Public
    
    func findFavorites() -> [RadioStation] {
        return stations.filter({ $0.isFavorite })
    }
    
    func toggleFavorite(for name: String) {
        if let index = stations.firstIndex(where: { $0.name == name }) {
            let favorite = stations[index].isFavorite
            stations[index].isFavorite = !favorite
        }
    }
    
    //MARK: - Private
    
    private func createStations() -> [RadioStation] {
        var stations:[RadioStation] = []
        
        //RPP Group
        
        stations.append( RadioStation(name: "RPP", image: "rpp", city: "Lima", frecuency: "89.7 FM", slogan: "Confianza por todos los medios",
                                      urlStream: "https://18593.live.streamtheworld.com/RADIO_RPP.mp3",
                                      group: .RPP("43"), isFavorite: false ))
        stations.append( RadioStation(name: "Capital", image: "capital", city: "Lima",  frecuency: "96.7 FM", slogan: "Tu Opinion Importa",
                                      urlStream: "https://16693.live.streamtheworld.com/RADIO_CAPITAL.mp3",
                                      group: .RPP("44"), isFavorite: false ) )
        stations.append( RadioStation(name: "Studio 92", image: "studio92", city: "Lima", frecuency: "92.5FM", slogan: "Primeros en tu Música",
                                      urlStream: "https://18623.live.streamtheworld.com/RADIO_STUDIO92.mp3",
                                      group: .RPP("47"), isFavorite: false ) )
        stations.append( RadioStation(name: "Corazón", image: "corazon", city: "Lima", frecuency: "94.3 FM", slogan: "Única como tú",
                                      urlStream: "https://17523.live.streamtheworld.com/RADIO_CORAZON.mp3",
                                      group: .RPP("45"), isFavorite: false ) )
        stations.append( RadioStation(name: "Oxigeno", image: "oxigeno", city: "Lima", frecuency: "102.1 FM", slogan: "Clásicos del rock & pop",
                                      urlStream: "https://20813.live.streamtheworld.com/RADIO_OXIGENO.mp3",
                                      group: .RPP("48"), isFavorite: false ) )
        stations.append( RadioStation(name: "La Zona", image: "lazona", city: "Lima", frecuency: "90.5 FM", slogan: "¡Tu música urbana!",
                                      urlStream: "https://15383.live.streamtheworld.com/RADIO_LAZONA.mp3",
                                      group: .RPP("46"), isFavorite: false ) )
        stations.append( RadioStation(name: "Felicidad", image: "felicidad", city: "Lima", frecuency: "88.9 FM", slogan: "La música de tu vida",
                                      urlStream: "https://18313.live.streamtheworld.com/RADIO_FELICIDAD.mp3",
                                      group: .RPP("49"), isFavorite: false ) )
        
        //CRP Group
        
        stations.append( RadioStation(name: "Ritmo Romántica", image: "ritmoromantica", city: "Lima", frecuency: "93.1 FM", slogan: "Tu radio de baladas",
                                      urlStream: "https://19253.live.streamtheworld.com/CRP_RIT.mp3",
                                      group: .CRP("https://ritmoromantica.pe"), isFavorite: false ))
        stations.append( RadioStation(name: "La Inolvidable", image: "inolvidable", city: "Lima", frecuency: "93.7 FM", slogan: "Tus mejores momentos",
                                      urlStream: "https://14653.live.streamtheworld.com/CRP_LI.mp3",
                                      group: .CRP("https://lainolvidable.pe"), isFavorite: false ))
        stations.append( RadioStation(name: "Moda", image: "moda", city: "Lima", frecuency: "97.3 FM", slogan: "Te mueve! ... con la música que esta de moda",
                                      urlStream: "https://18303.live.streamtheworld.com/CRP_MOD.mp3",
                                      group: .CRP("https://moda.com.pe"), isFavorite: false ))
        stations.append( RadioStation(name: "Oasis", image: "oasis", city: "Lima", frecuency: "100.1 FM", slogan: "Oasis, Rock & pop",
                                      urlStream: "https://19223.live.streamtheworld.com/CRP_OAS.mp3",
                                      group: .CRP("https://oasis.pe"), isFavorite: false ))
        stations.append( RadioStation(name: "Radiomar", image: "radiomar", city: "Lima", frecuency: "106.3 FM", slogan: "¡Vive gozando!",
                                      urlStream: "https://18493.live.streamtheworld.com/CRP_MAR.mp3",
                                      group: .CRP("https://radiomar.pe"), isFavorite: false ))
        stations.append( RadioStation(name: "Nueva Q", image: "nuevaq", city: "Lima", frecuency: "107.1 FM", slogan: "¡QQQumbia!",
                                      urlStream: "https://19253.live.streamtheworld.com/CRP_NQ.mp3",
                                      group: .CRP("https://radionuevaq.pe"), isFavorite: false ))
        stations.append( RadioStation(name: "Planeta", image: "planeta", city: "Lima", frecuency: "107.7 FM", slogan: "Tu música en inglés",
                                      urlStream: "https://18723.live.streamtheworld.com/CRP_PLA.mp3",
                                      group: .CRP("https://planeta.pe"), isFavorite: false ))
        
        //Test for Scrolling
        stations.append( RadioStation(name: "Capital", image: "capital", city: "Lima",  frecuency: "96.7 FM", slogan: "Tu Opinion Importa",
                                      urlStream: "https://16693.live.streamtheworld.com/RADIO_CAPITAL.mp3",
                                      group: .RPP("44"), isFavorite: false ) )
        stations.append( RadioStation(name: "Corazón", image: "corazon", city: "Lima", frecuency: "94.3 FM", slogan: "Única como tú",
                                      urlStream: "https://17523.live.streamtheworld.com/RADIO_CORAZON.mp3",
                                      group: .RPP("45"), isFavorite: false ) )
        stations.append( RadioStation(name: "Oxigeno", image: "oxigeno", city: "Lima", frecuency: "102.1 FM", slogan: "Clásicos del rock & pop",
                                      urlStream: "https://20813.live.streamtheworld.com/RADIO_OXIGENO.mp3",
                                      group: .RPP("48"), isFavorite: false ) )
        stations.append( RadioStation(name: "La Zona", image: "lazona", city: "Lima", frecuency: "90.5 FM", slogan: "¡Tu música urbana!",
                                      urlStream: "https://15383.live.streamtheworld.com/RADIO_LAZONA.mp3",
                                      group: .RPP("46"), isFavorite: false ) )
        stations.append( RadioStation(name: "Felicidad", image: "felicidad", city: "Lima", frecuency: "88.9 FM", slogan: "La música de tu vida",
                                      urlStream: "https://18313.live.streamtheworld.com/RADIO_FELICIDAD.mp3",
                                      group: .RPP("49"), isFavorite: false ) )
        
        //Mark a few Favorites
        
        if let index = stations.firstIndex(where: { $0.name == "RPP" }) {
            stations[index].isFavorite = true
        }
        
        if let index = stations.firstIndex(where: { $0.name == "Studio 92" }) {
            stations[index].isFavorite = true
        }
        
        if let index = stations.firstIndex(where: { $0.name == "Moda" }) {
            stations[index].isFavorite = true
        }
        
        
        return stations
    }
}
