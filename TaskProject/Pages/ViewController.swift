
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var listTblView: UITableView!
    @IBOutlet var scrollSubView: UIView!
    
    @IBOutlet var imageView: UIImageView!
    
    var canLoadApi = false
    var currentPage = 1
    var limit:Int = 10
    
    var addressList : [AddressListModel]?
    var addAddressList : [AddressListModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.fetchListAPICall()
    }
}

extension ViewController {
    func fetchListAPICall() {
        if currentPage == 1 {
            self.addressList?.removeAll()
            self.addAddressList?.removeAll()
        }
        let baseurl = apiBaseUrl + "_page=\(self.currentPage)&_limit=\(self.limit)"
        AddressViewModel().callAddressListMethod(url: baseurl) { result in
            switch result {
            case .success(let user):
                self.addressList = user
                if self.addressList?.count != 0 {
                    if self.currentPage == 1 {
                        self.addAddressList = self.addressList
                    }
                    else if self.currentPage != 1{
                        if  (self.addressList?.count ?? 0) > 0 {
                            self.addAddressList! += (self.addressList)!
                        }
                        self.limit = self.addressList?.count ?? 0
                    }
                }
                else {
                    if self.currentPage == 1 {
                        print("No Items")
                    }
                }
                if self.addressList?.count != 0 {
                    DispatchQueue.main.async {
                        self.listTblView.reloadData()
                    }
                }
            case .failure(let error):
                print("Failed to fetch user data: \(error)")
                
            }
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addAddressList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if self.addAddressList?.count != 0 {
            let dic = self.addAddressList?[indexPath.row]
            let title = "Title - \(dic?.title ?? "")"
            let id = "Id - \(dic?.id ?? 0)"
            cell.textLabel?.text = title + "\n" + id
            cell.textLabel?.numberOfLines = 3
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.addAddressList?.count != 0 {
            let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            sb.addressList = self.addAddressList?[indexPath.row]
            self.navigationController?.pushViewController(sb, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("Will display cell for row \(indexPath.row)")
        if addAddressList!.count != 0 {
            if indexPath.row == (addAddressList?.count ?? 0) - 1 {
                currentPage += 1
                fetchListAPICall()
            }
        }
        // Add any additional configuration for the cell here
    }
}
