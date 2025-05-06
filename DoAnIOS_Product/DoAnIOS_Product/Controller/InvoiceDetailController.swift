//
//  InvoiceDetailController.swift
//  DoAnIOS_Product
//
//  Created by  User on 05.05.2025.
//

import UIKit

class InvoiceDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    
    
    var selectedProducts: [Product] = []
    var quantities: [Int] = [] // Số lượng tương ứng từng sản phẩm

    // Tao doi tuong truy van CSDL
    private let dao = Database()
    var invoice:Invoice?
    var invoicedetail:InvoiceDetail?
    private let selectProductID = "SelectProductController"
    private let selectCustomerID = "CustomerController"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        updateTotalAmount()
    }

    func updateTotalAmount() {
        // Tính tổng cho mỗi sản phẩm và tổng cho tất cả sản phẩm
        let total = zip(selectedProducts, quantities).reduce(0.0) {
            result, item in
            // Xem tong tien moi san pham
            let productTotal = Double(item.1) * item.0.prod_price
            print("Ten san pham: \(item.0.prod_name), qty: \(item.1), Thanh tien: \(productTotal) đ")
            // Tong tat ca cac san pham
            return result + productTotal
        }
        // chua dinh dang tien
         totalAmountLabel.text = "Tong: \(total) vnd"
    }
    
    @IBAction func saveInvoice(_ sender: UIButton) {
       /* if let customerName = customerNameTextField.text, !customerName.isEmpty {
            // Báo lỗi
            return
        }*/
        // Kiểm tra xem mảng selectedProducts có dữ liệu không
        if selectedProducts.isEmpty || quantities.isEmpty {
            print("Chưa chọn sản phẩm.")
            return
        }

        let total = zip(selectedProducts, quantities).reduce(0.0) {
            $0 + (Double($1.1) * $1.0.prod_price)
        }

        // Format ngày tháng năm
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = formatter.string(from: Date())
        
        invoice = Invoice(inv_id: 0, inv_date: formattedDate, inv_customer_id: 0, inv_total: total)

        if let invoice = invoice {
            if let invoiceID = dao.insertInvoice(invoice: invoice) {
                for (index, product) in selectedProducts.enumerated() {
                    let invDetail = InvoiceDetail(inv_dtl_id: 0,
                                               inv_dtl_inv_id: invoiceID,
                                               inv_dtl_prod_id: product.prod_id!,
                                               inv_dtl_qty: quantities[index])
                if let invDetail = invDetail {
                    dao.insertInvoiceDetail(invoicedetail: invDetail)
                    
                    // In ra chi tiết hóa đơn sau khi insert
                   print("Đã thêm chi tiết hóa đơn: ID sản phẩm: \(product.prod_id!), Tên: \(product.prod_name), Số lượng: \(quantities[index]), Giá: \(product.prod_price)")
                    
                }
                else {
                    print("Tao chi tiet hoa don khong thanh cong")
                    
                }
                    
            }
        }
    } else {
        print("Tạo hóa đơn thất bại.")
    }

}

    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "ProductCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? ProductCell {
            // Lay du lieu tu DataSource
            let product = selectedProducts[indexPath.row]
            //let product = products[indexPath.row]
            cell.InvProductName.text = "\(product.prod_name) - SL: \(quantities[indexPath.row]) - Gia : \(product.prod_price) - Thanh tien : \(Double(quantities[indexPath.row]) * product.prod_price)"
            return cell
        }
        
        
        // Khong tao duoc cell
        fatalError("Khong the tao cell!")
    }
    //
    // Nut popup add product
    @IBAction func onAddProductTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
       if let selectVC = storyboard.instantiateViewController(withIdentifier: selectProductID) as? SelectProductController {
            selectVC.delegate = self
            self.present(selectVC, animated: true)
        }
    }
    //Nut popup add customer
    @IBAction func onAddCustomerTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let customerVC = storyboard.instantiateViewController(withIdentifier: selectCustomerID) as? CustomerController {
            customerVC.delegate = self
            self.present(customerVC, animated: true)
        }
    }}

// Kết nối protocol để nhận sản phẩm và số lượng
extension InvoiceDetailController: SelectProductDelegate {
    func didSelectProduct(product: Product, quantity: Int) {
        // Thêm vào danh sách sản phẩm đã chọn
        selectedProducts.append(product)
        quantities.append(quantity)
        updateTotalAmount()
        tableView.reloadData()
    }
}
