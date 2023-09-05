//
//  Created by Jeans Ruiz on 17/08/23.
//

import Foundation
import SwiftUI

public struct MiniPlayerView: View {

  #warning("todo, change namimg, model, store?")
  @Environment(PlayerViewModel.self) private var playerModel
  var model: MiniPlayerUIModel // @Bindable ?

  public init(model: MiniPlayerUIModel) {
    self.model = model
  }

  public var body: some View {
    VStack {
      HStack(alignment: .center) {
        Button(action: {

        }, label: {
          Image(systemName: model.isFavorite ? "heart.fill" : "heart")
            .resizable()
            .scaledToFit()
            .padding(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
            .frame(width: 44, height: 44)
        })

        Button(action: {}, label: {
          Label("", systemImage: model.state.isPlaying ? "chart.bar.fill": "chart.bar")
        })
        .opacity( model.state.isLoading ? 0 : 1)
        .overlay {
          if model.state.isLoading {
            ProgressView().id(UUID())
          }
        }

        VStack(alignment: .leading) {
          Text(model.title)
            .font(.title3)
            .fontWeight(.bold)
          Text(model.subtitle)
            .font(.footnote)
            .fontWeight(.regular)
        }

        Spacer()

        Button(action: {
          playerModel.toggle()
        }, label: {
          Image(systemName: model.state.isPlaying ? "pause.circle.fill" : "play.circle.fill")
            .resizable()
            .scaledToFit()
            .padding(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
            .frame(width: 44, height: 44)
        })
      }
      Divider()
    }
    .background(Color(UIColor.secondarySystemBackground))
  }
}

// MARK: - UIModel
public struct MiniPlayerUIModel {
  public let isFavorite: Bool
  public var state: PlayerStatus
  public var title: String
  public let subtitle: String

  public init(
    isFavorite: Bool = false,
    state: PlayerStatus = .stopped,
    title: String = "",
    subtitle: String = ""
  ) {
    self.isFavorite = isFavorite
    self.state = state
    self.title = title
    self.subtitle = subtitle
  }

  public enum PlayerStatus {
    case loading
    case stopped
    case playing

    var isPlaying: Bool {
      return .playing == self
    }

    var isLoading: Bool {
      return .loading == self
    }
  }
}
