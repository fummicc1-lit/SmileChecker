import Foundation
import UIKit
import CoreML
import Vision

func checkSmile(
    image: CGImage,
    completion: @escaping (Float) -> Void
) {
    let classifier = try! SmileChecker(configuration: .init())
    let model = try! VNCoreMLModel(for: classifier.model)
    let request = VNCoreMLRequest(model: model) { request, error in
        if let results = request.results as? [VNClassificationObservation] {
            var smile: VNClassificationObservation?
            for result in results {
                if result.identifier == "smile" {
                    smile = result
                }
            }
            if let smile = smile {
                completion(smile.confidence)
            }
        }
    }

    let handler = VNImageRequestHandler(cgImage: image)

    try! handler.perform([request])
}
