import Foundation

class Person {
    init(name: String) {
        self.name = name
        self.hasSmile = false
        checkHasSmile(imageName: name) { hasSmile in
            self.hasSmile = hasSmile
        }
    }

    var name: String
    var hasSmile: Bool
}
