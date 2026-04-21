import Foundation
import os

private let logger = Logger(subsystem: "im.devinl.da-band", category: "SensorData")

enum APIClient {
    private static let baseURL = "https://api.devinl.im/da-band"

    static func trainModel() async throws -> Data {
        guard let URL = URL(string: baseURL) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: URL)
        return data
    }
}
