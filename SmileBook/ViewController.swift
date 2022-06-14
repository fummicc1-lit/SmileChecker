import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var smileLabel: UILabel!

    var index: Int = 0

    var people: [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // 全部で8つの要素（人の名前は画像名に一致しているよ）
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
        // MARK: UIを変更する
        if people[index].hasSmile == true {
            smileLabel.text = "\(people[index].name) smiles."
        } else {
            smileLabel.text = "\(people[index].name) does not smile."
        }
        imageView.image = UIImage(named: people[index].name)
    }

    @IBAction func next() {
        // 一番最後まで来たかチェック
        if index == 7 {
            // indexを先頭に戻す
            index = 0
        } else {
            // indexを+1する
            index += 1
        }
        // MARK: UIを変更する
        if people[index].hasSmile == true {
            smileLabel.text = "\(people[index].name) smiles."
        } else {
            smileLabel.text = "\(people[index].name) does not smile"
        }
        imageView.image = UIImage(named: people[index].name)
    }

    @IBAction func back() {
        if index == 0 {
            index = 7
        } else {
            index -= 1
        }
        // MARK: UIを変更する
        if people[index].hasSmile == true {
            smileLabel.text = "\(people[index].name) smiles."
        } else {
            smileLabel.text = "\(people[index].name) does not smile."
        }
        imageView.image = UIImage(named: people[index].name)
    }
}

