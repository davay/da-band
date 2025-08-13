import Foundation
import SwiftData

@Model
final class Configuration {
    var id: UUID = UUID()
    var name: String
    var createdAt: Date = Date()
    var isActive: Bool = false

    @Relationship(inverse: \Device.configurations) var devices: [Device] = []
    @Relationship(deleteRule: .cascade) var gestures: [Gesture] = []
    @Relationship(deleteRule: .cascade) var models: [Model] = []

    init(name: String) {
        self.name = name
    }

    func toggleIsActive(in modelContext: ModelContext) {
        if isActive {
            isActive = false
        } else {
            let descriptor = FetchDescriptor<Configuration>()
            let allConfigurations = try? modelContext.fetch(descriptor)

            // all other configurations will be disabled
            allConfigurations?.forEach { $0.isActive = false }

            isActive = true

            try? modelContext.save()
        }
    }
}
