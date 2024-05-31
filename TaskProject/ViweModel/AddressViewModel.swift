
import Foundation

class AddressViewModel {
    
    func callAddressListMethod(url: String,completion: @escaping (Result<[AddressListModel], Error>) -> Void) {
        ApiCallService().fetchUserData(url: url) { result in
            switch result {
            case .success(let user):
                print("User ID: \(user)")
                // Save the user data to your model or local storage
                completion(.success(user))
            case .failure(let error):
                print("Failed to fetch user data: \(error)")
                completion(.failure(error))
            }
        }
    }
}
