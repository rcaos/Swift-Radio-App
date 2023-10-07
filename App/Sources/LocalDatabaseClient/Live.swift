//
//  Created by Jeans Ruiz on 25/09/23.
//

import Foundation
import SwiftData

extension LocalDatabaseClient {

  public static func buildSwiftDataClient(modelContext: ModelContext) -> LocalDatabaseClient {
    return LocalDatabaseClient(
      toggleFavoriteStation: { model in
        let stationId = model.id // why predicate can't access to "station.id" ?
        let predicate = #Predicate<RadioStationFavoriteSD> {
          return $0.id == stationId
        }
        do {
          let descriptor = FetchDescriptor<RadioStationFavoriteSD>(predicate: predicate)
          if try modelContext.fetchCount(descriptor) == 0 {
            modelContext.insert(RadioStationFavoriteSD(model))
            return true
          } else {
            try modelContext.delete(model: RadioStationFavoriteSD.self, where: predicate)
            return false
          }
        } catch  {
          print(error)
          return false
        }
      },
      fetchAllFavorites: {
        do {
          let descriptor = FetchDescriptor<RadioStationFavoriteSD>()
          return try modelContext.fetch(descriptor).map { $0.asModel() }
        } catch  {
          return []
        }
      },
      getStationById: { stationId in
        let predicate = #Predicate<RadioStationFavoriteSD> {
          return $0.id == stationId
        }
        let descriptor = FetchDescriptor<RadioStationFavoriteSD>(predicate: predicate)
        do {
          return try modelContext.fetch(descriptor).map { $0.asModel() }.first
        } catch {
          return nil
        }
      }
    )
  }
}
