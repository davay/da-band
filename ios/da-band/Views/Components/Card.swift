import SwiftUI

struct Card<Content: View>: View {
    let widthPercentage: CGFloat
    let content: Content

    init(widthPercentage: CGFloat, @ViewBuilder content: () -> Content) {
        self.widthPercentage = widthPercentage
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .containerRelativeFrame(.horizontal) { length, _ in length * widthPercentage }
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .shadow(radius: 1)
    }
}

#Preview {
    Card(widthPercentage: 0.2) {
        Text("Test")
        Text("Test 2")
    }
}
