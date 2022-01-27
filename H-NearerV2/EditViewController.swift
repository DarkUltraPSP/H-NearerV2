import UIKit

class EditViewController: UIViewController {
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfLat: UITextField!
    @IBOutlet weak var tfLong: UITextField!
    var tvName = String()
    var points: [Point] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        for pts in points {
            if (tvName == pts.name) {
                tfName.text = pts.name
                tfLat.text = "\(pts.coord.coordinate.latitude)"
                tfLong.text = "\(pts.coord.coordinate.longitude)"
            }
        }
    }
    @IBAction func editBtn(_ sender: Any) {
        if (tfName.text!.isEmpty || tfLat.text!.isEmpty || tfLong.text!.isEmpty) {
            let alert = UIAlertController(title: "Champs vides", message: "Certains de vos champs sont vides, veuillez les completer", preferredStyle:UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default))
            self.present(alert, animated: true, completion: nil)
        } else {
            PointManager.editPoint(oldName: tvName, newName: tfName.text!, newLat: tfLat.text!, newLong: tfLong.text!)
            let alert = UIAlertController(title: "Point édité", message: "Veuillez rafraichir la liste", preferredStyle:UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (_) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
