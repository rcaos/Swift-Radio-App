//
//  Created by Jeans Ruiz on 17/08/23.
//

import Env
import Foundation
import SwiftUI

public struct MiniPlayerView: View {

#warning("todo, change namimg, model, store?")
  @Environment(PlayerViewModel.self) private var playerModel
  @Environment(RouterPath.self) private var routerPath
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
            .lineLimit(1)
            .font(.title3)
            .fontWeight(.bold)
          Text(model.subtitle)
            .lineLimit(1)
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
    .onTapGesture {
      routerPath.presentedSheet = .fullPlayer
    }
  }
}
