import SwiftUI

struct StatusIndicator: View {
    let isActive: Bool
    let type: IndicatorType

    enum IndicatorType {
        case configuration
        case device
    }

    private var color: Color {
        switch type {
        case .configuration:
            return .blue
        case .device:
            return .green
        }
    }

    var body: some View {
        Circle()
            .fill(isActive ? color : Color.clear)
            .stroke(color, lineWidth: 2)
            .frame(width: 12, height: 12)
    }
}
