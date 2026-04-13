import SwiftUI

extension View {
    func hideNavigationBar() -> some View {
        toolbarVisibility(.hidden, for: .navigationBar)
    }
}
