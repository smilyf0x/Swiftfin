//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2026 Jellyfin & Jellyfin Contributors
//

import SwiftUI

struct NavigationBarFilterDrawerModifier: ViewModifier {

    @Environment(\.frameForParentView)
    private var frameForParentView

    @FocusState
    private var focusedFilter: FilterTrack.FocusTarget?

    @ObservedObject
    var viewModel: FilterViewModel

    let types: [ItemFilterType]

    /// Side safe area, e.g. the vertical bars on the outer display of iPhone Duo.
    private var sideInsets: EdgeInsets {
        frameForParentView[.navigationStack]?.safeAreaInsets ?? .zero
    }

    private var drawer: some View {
        ScrollView(.horizontal) {
            HStack {
                FilterTrack(viewModel: viewModel, types: types, focus: $focusedFilter)
            }
        }
        .contentMargins(.leading, 16 + sideInsets.leading, for: .scrollContent)
        .contentMargins(.trailing, 16 + sideInsets.trailing, for: .scrollContent)
        .padding(.bottom, 5)
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .clippedToSideSafeArea()
    }

    func body(content: Content) -> some View {
        if types.isEmpty {
            content
        } else {
            if #available(iOS 26, *) {
                content
                    .safeAreaBar(edge: .top, spacing: 0) {
                        drawer
                    }
            } else {
                NavigationBarDrawerView {
                    drawer
                        .ignoresSafeArea()
                } content: {
                    content
                }
                .ignoresSafeArea()
            }
        }
    }
}
