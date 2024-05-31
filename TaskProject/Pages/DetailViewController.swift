
import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detailTextLbl: UILabel!

    var addressList : AddressListModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        let title = "Title - \(addressList?.title ?? "")"
        let id = "Id - \(addressList?.id ?? 0)"
        let desc = "User id - \(addressList?.userID ?? 0)"
        let body = "Body - \(addressList?.body ?? "")"

        self.detailTextLbl.text = title + "\n\n" + id + "\n\n" + desc + "\n\n" + body
    }
}
