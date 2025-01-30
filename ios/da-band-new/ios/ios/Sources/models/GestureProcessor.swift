import Foundation
import CoreML

struct GestureProcessor {
    static func useGestures(
        model: MLModel?,
        gestureData: [(Int, Double, Double, Double, Double)],
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
            "feature1": lastGesture.1, // First feature (Double)
            "feature2": lastGesture.2, // Second feature (Double)
            "feature3": lastGesture.3, // Third feature (Double)
            "feature4": lastGesture.4  // Fourth feature (Double)
        ]

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
