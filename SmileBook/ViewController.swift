import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var smileLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!

    var index: Int = 0

    var people: [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // 全部で6つの要素
        people = [
            Person.create(name: "Allisa"),
            Person.create(name: "Ann"),
            Person.create(name: "Ben"),
            Person.create(name: "Cassie"),
            Person.create(name: "Jack"),
            Person.create(name: "Julia"),
            Person.create(name: "Mike"),
            Person.create(name: "Rola")
        ]
        numberLabel.text = "\(index+1)/8"
        if people[index].hasSmile == true {
            smileLabel.text = people[index].name + "は笑っています○"
        } else {
            smileLabel.text = people[index].name + "は笑っていません×"
        }
        imageView.image = UIImage(named: people[index].name)
    }

    @IBAction func next() {
        if index == 7 {
            index = 0
        } else {
            index += 1
        }
        numberLabel.text = "\(index+1)/8"
        if people[index].hasSmile == true {
            smileLabel.text = people[index].name + "は笑っています○"
        } else {
            smileLabel.text = people[index].name + "は笑っていません×"
        }
        imageView.image = UIImage(named: people[index].name)
    }

    @IBAction func back() {
        if index == 0 {
            index = 7
        } else {
            index -= 1
        }
        numberLabel.text = "\(index+1)/8"
        if people[index].hasSmile == true {
            smileLabel.text = people[index].name + "は笑っています○"
        } else {
            smileLabel.text = people[index].name + "は笑っていません×"
        }
        imageView.image = UIImage(named: people[index].name)
    }
}

