//
//  SelectProductController.swift
//  DoAnIOS_Product
//
//  Created by  User on 05.05.2025.
//

import UIKit

// MARK: - Protocol gui du lieu Product Cell ve storyboard InvoiceDetailController
protocol SelectProductDelegate: AnyObject {
    func didSelectProduct(product: Product, quantity: Int)
}

class SelectProductController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var products: [Product] = []
    weak var delegate: SelectProductDelegate?
    private let dao = Database()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Đăng ký cell nếu dùng UITableViewCell mặc định
        tableView.delegate = self
        tableView.dataSource = self
        
        //doc toan bo du lieu customer tu CSDL neu co
        dao.readProducts(products: &products)
    }
    
    // MARK: TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "ProductCell")
        
        let product = products[indexPath.row]

        cell.textLabel?.text = product.prod_name
        cell.detailTextLabel?.text = "Giá: \(product.prod_price) - SL: \(product.prod_qty)"
        if let image = product.prod_image {
            cell.imageView?.image = image
        } else {
            cell.imageView?.image = UIImage(systemName: "photo")
        }
        return cell
    }
    
    // MARK: TableView Delegate - chon san pham
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = products[indexPath.row]
        chooseQuantity(for: selectedProduct)
    }
    
    // MARK: User chon so luong can nhap
    func chooseQuantity(for product: Product) {
        let alert = UIAlertController(
            title: "Nhap so luong",
            message: "San pham: \(product.prod_name) - So luong ton: \(product.prod_qty)",
            preferredStyle: .alert
        )
        alert.addTextField { textField in
            textField.placeholder = "Nhap so luong san pham"
            textField.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if let qtyText = alert.textFields?.first?.text,
               let quantity = Int(qtyText),
               quantity > 0,
               quantity <= product.prod_qty {
                print("So luong hop le: \(quantity)")
                self?.delegate?.didSelectProduct(product: product, quantity: quantity)
                self?.dismiss(animated: true)
            } else {
                print("Nhap gia tri khong hop le")
                return
            }
        })
        present(alert, animated: true)
    }
}
