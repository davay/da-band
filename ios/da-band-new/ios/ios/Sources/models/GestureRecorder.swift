import Foundation
import CoreML

class GestureDataManager: ObservableObject {
    @Published var gestureData: [(Int, Double, Double, Double, Double)] = []
    @Published var isRecording = false
    var model: MLModel? = nil
    var predictionResult: String? = nil
    var currentLabel: Int = 0
    
    // Should check if core ML is more comfortable with SQL or csv strings, if with SQL, could record into
    // SQL and send csv strings at the same time.
    func startNewGesturesRecording(countdown: Int, completion: @escaping () -> Void) {
        isRecording = true
        gestureData = []
        model = nil
        predictionResult = nil
        self.currentLabel += 1
        
        var remainingTime = countdown
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in // Test purpose, can set time interval lower
            if remainingTime > 0 {
                let randomTuple: (Int, Double, Double, Double, Double) = (
                    self.currentLabel,
                    Double.random(in: 0...1),
                    Double.random(in: 0...1),
                    Double.random(in: 0...1),
                    Double.random(in: 0...1)
                )
                self.gestureData.append(randomTuple)
                remainingTime -= 1
            } else {
                timer.invalidate()
                self.isRecording = false
                self.sendDataToServer(completion: completion)
            }
        }
    }
    
    private func sendDataToServer(completion: @escaping () -> Void) {
        // Generate the CSV string
        let csvString = gestureData.map { tuple in
            "\(tuple.0),\(tuple.1),\(tuple.2),\(tuple.3),\(tuple.4)"
        }.joined(separator: "\n")
        
        // Debugging: Print the generated CSV string
        print("Generated CSV String:\n\(csvString)")
        
        // Check if the string is empty
        guard !csvString.isEmpty else {
            print("Error: Generated CSV string is empty!")
            return
        }
        
        // Server info here
        guard let url = URL(string: "http://127.0.0.1:5001") else {
            print("Invalid server URL.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/csv", forHTTPHeaderField: "Content-Type")
        request.httpBody = csvString.data(using: .utf8)
        
        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received from the server.")
                return
            }
            
            // Print the server response
            if let responseString = String(data: data, encoding: .utf8) {
                print("Server Response: \(responseString)")
            }
            
            completion()
        }.resume()
    }

    
    
    // Receive
    func fetchGestureModel(completion: @escaping (Result<MLModel, Error>) -> Void) {
        // Define the server URL
        guard let url = URL(string: "http://127.0.0.1:5001") else {
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
}
