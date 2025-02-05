import Foundation
import CoreML

struct GestureProcessor {
    static func useGestures(
        model: MLModel?,
        gestureData: [(String, Int, Int16, Double, Double, Double)],
        predictionResult: inout String?
    ) {
        guard let model = model else {
            print("No model available.")
            predictionResult = "No model available for prediction."
            return
        }

        guard let lastGesture = gestureData.last else {
            print("No gesture data available.")
            predictionResult = "No gesture data available for prediction."
            return
        }

        // Change these for related data
        let features = [
            "serialNumber": lastGesture.0,
            "battery_level": lastGesture.1,
            "muscle_level": lastGesture.2,
            "pitch": lastGesture.3,
            "roll": lastGesture.4,
            "yaw": lastGesture.5
        ] as [String : Any]

        do {
            let predictionInput = try MLDictionaryFeatureProvider(dictionary: features)
            let predictionOutput = try model.prediction(from: predictionInput)
            predictionResult = predictionOutput.featureValue(for: "label")?.stringValue
            print("Prediction: \(predictionResult ?? "Unknown")")
        } catch {
            print("Prediction failed: \(error)")
            predictionResult = "Unrecognized gesture."
        }
    }
}
