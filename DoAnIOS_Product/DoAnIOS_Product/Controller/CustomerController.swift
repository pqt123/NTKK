//
//  CustomerController.swift
//  DoAnIOS_Product
//
//  Created by  User on 06.05.2025.
//

import UIKit

protocol SelectCustomerDelegate: AnyObject {
    func didSelectCustomer(customer: Customer)
}
class CustomerController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var customerTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    private var customers = [Customer]()
    weak var delegate: SelectCustomerDelegate?

    private let dao = Database()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        print("\(tableView != nil)")
        
        //doc toan bo du lieu customer tu CSDL neu co
        dao.readCustomers(customers: &customers)
        //print("\(customers.count)")
        
    }


    @IBAction func addCustomer(_ sender: UIButton) {
        guard let name = customerTextField.text, !name.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty else {
            print("Ten hoac so dien thoai khong duoc de trong")
            return
        }

        // Tạo customer
        if let newCustomer = Customer(customer_id: 0, customer_name: name, customer_phone: phone) {
            let success = dao.insertCustomer(customer: newCustomer)
            if success {
                print("Them khach hang thanh cong")
                customers.append(newCustomer)
                tableView.reloadData()
                customerTextField.text = ""
                phoneTextField.text = ""
            } else {
                print("Them khach hang khong thanh cong")
            }
        } else {
            print("Khong the khoi tao doi tuong")
        }
    }
    // MARK: - Table view data source
    // So luong layouts (cell) trong tableView
    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "CustomerCell"

        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? CustomerCell {
                    
            // Lay du lieu tu DataSource
            let customer = customers[indexPath.row]
            
            print("kiem tra data customer_id : \(customer.customer_id)")
            
            // Do du lieu tu invoice vao cell
            cell.txtCustomerName.text = customer.customer_name + " - " + customer.customer_phone
            
            /*
             // Bo sung them cho bat su kien theo cach 1
             if cell.onTap == nil {
             // Khoi tao cho doi tuong onTap
             cell.onTap = UITapGestureRecognizer()
             // Bat su kien cho doi tuong onTap
             cell.onTap!.addTarget(self, action: #selector(editMeal))
             
             // Ket noi doi tuong onTap voi cell
             cell.addGestureRecognizer(cell.onTap!)
             }
             */
            
            return cell
        }
        
        // Khong tao duoc cell
        fatalError("Khong the tao cell!")
    }
    // MARK : TableView Delegate - chon khach hang
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCustomer = customers[indexPath.row]
        chooseCustomer(for: selectedCustomer)
    }
    //chon khach hang va gui ve InvoiceDetailController
    func chooseCustomer(for customer: Customer){
        delegate?.didSelectCustomer(customer: customer)
        dismiss(animated: true)
        // present(self, animated: true)
    }
}
