import SwiftUI

struct ModalOverlay<Content: View>: View {
    private let isPresented: Bool
    private let dismiss: () -> Void
    private let content: Content?

    /// sometimes modal triggers are simple boolean bindings
    /// when we use @Binding on some property, that's syntax sugar for _property.wrappedValue
    /// here we're not using the property, so we need to access it directly
    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.isPresented = isPresented.wrappedValue
        self.dismiss = { isPresented.wrappedValue = false }
        self.content = isPresented.wrappedValue ? content() : nil
    }

    /// other times its the modal content depends on which item we select
    init<Item>(item: Binding<Item?>, @ViewBuilder content: (Item) -> Content) {
        self.dismiss = { item.wrappedValue = nil }
        if let value = item.wrappedValue {
            self.isPresented = true
            self.content = content(value)
        } else {
            self.isPresented = false
            self.content = nil
        }
    }

    var body: some View {
        if isPresented, let content {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }
            content
        }
    }
}

struct Modal<Content: View>: View {
    let content: Content
    let onDismiss: () -> Void

    init(onDismiss: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.onDismiss = onDismiss
        self.content = content()
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(radius: 20)
            .padding(.horizontal, 20)
    }
}
