//
//  CustomerController.swift
//  DoAnIOS_Product
//
//  Created by  User on 06.05.2025.
//

import UIKit

protocol CustomerSelectionDelegate: AnyObject {
    func didSelectCustomer(name: String)
}
class CustomerController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var customerTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    var customers: [Customer] = []
    weak var delegate: CustomerSelectionDelegate?

    private let dao = Database()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadCustomers()
    }

    func loadCustomers() {
        //doc du lieu
        customers = dao.getAllCustomers()
        tableView.reloadData()
    }

    @IBAction func addCustomer(_ sender: UIButton) {
        guard let name = customerTextField.text, !name.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty else {
            print("Tên hoặc số điện thoại không được để trống")
            return
        }

        let newCustomer = Customer(id: 0, name: name, phone: phone)
        if dao.insertCustomer(newCustomer) {
            print("Đã thêm khách hàng mới")
            loadCustomers()
            customerTextField.text = ""
            phoneTextField.text = ""
        } else {
            print("Thêm khách hàng thất bại")
        }
    }

    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath)
        let customer = customers[indexPath.row]
        cell.textLabel?.text = "\(customer.name) - \(customer.phone)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCustomer = customers[indexPath.row]
        delegate?.didSelectCustomer(name: selectedCustomer.name)
        self.dismiss(animated: true)
    }
    
}
extension InvoiceDetailController: CustomerSelectionDelegate {
    func didSelectCustomer(name: String) {
        customerNameTextField.text = name
    }
}
