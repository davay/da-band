import Foundation
import CoreML

func fetchGestureModel(completion: @escaping (Result<MLModel, Error>) -> Void) {
    // Define the server URL
    guard let url = URL(string: "http://<your-server-ip>:5000/get-gesture-model") else {
        print("Invalid URL")
        return
    }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data else {
            let error = NSError(domain: "No data received", code: 0, userInfo: nil)
            completion(.failure(error))
            return
        }

        do {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let modelURL = documentsDirectory.appendingPathComponent("GestureModel.mlmodel")

            try data.write(to: modelURL, options: .atomic)

            let model = try MLModel(contentsOf: modelURL)
            print("New model saved and loaded successfully at \(modelURL)")

            completion(.success(model))
        } catch {
            completion(.failure(error))
        }
    }
    task.resume()
}
