import Foundation
import UIKit
import CoreML
import Vision

extension Person {
    static func create(name: String) -> Person {
        Person(name: name)
    }
}

func checkHasSmile(
    imageName: String,
    completion: @escaping (Bool) -> Void
) {
    let positiveThreshold: VNConfidence = 0.85
    let negativeThreshold: VNConfidence = 0.05
    let image = UIImage(named: imageName)!
    let classifier = try! SmileChecker(configuration: .init())
    let model = try! VNCoreMLModel(for: classifier.model)
    let request = VNCoreMLRequest(model: model) { request, error in
        if let results = request.results as? [VNClassificationObservation] {
            var nonSmile: VNClassificationObservation?
            var smile: VNClassificationObservation?
            for result in results {
                if result.identifier == "smile" {
                    smile = result
                } else {
                    nonSmile = result
                }
            }
            let hasSmile = smile!.confidence > positiveThreshold && nonSmile!.confidence < negativeThreshold
            completion(hasSmile)
        }
    }

    let handler = VNImageRequestHandler(cgImage: image.cgImage!)

    try! handler.perform([request])
}
