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
    
    
    //Khai bao
    var selectedProducts: [Product] = []
    var quantities: [Int] = [] // So luong ma ban da nhap cho san pham ban chon
    var selectCustomer: Customer?

    // Tao doi tuong truy van CSDL
    private let dao = Database()
    var invoice:Invoice?
    var invoiceDetail:InvoiceDetail?
    private let selectProductID = "SelectProductController"
    private let selectCustomerID = "CustomerController"
    var cust_id = 0
    var invoiceDetails: [InvoiceDetail] = []
    //Khai bao kiem tra
    var isViewInvoiceDetail =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        updateTotalAmount()
        showCustomer()
        
        //Lay du lieu truyen sang neu co
        if let invoice = invoice{
            isViewInvoiceDetail = true
            customerNameTextField.text = invoice.customer_name
            if let inv_id = invoice.inv_id {
                print("check_inv : \(inv_id)")
                totalAmountLabel.text = String(format: "%.2f", invoice.inv_total)
                let _ = dao.readInvoiceDetails(for: inv_id, invoicedetails: &invoiceDetails)
                tableView.reloadData()
            }else{
                print("khong co data")
            }

        }
        
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
    func showCustomer(){
        if let customer = selectCustomer{
            customerNameTextField.text = customer.customer_name
            cust_id = customer.customer_id
        }else{
            customerNameTextField.text = ""
            cust_id = 0
        }
            
    }
    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isViewInvoiceDetail ? invoiceDetails.count : selectedProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "InvoiceCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? InvoiceCell {
            
            if isViewInvoiceDetail {
                let detail = invoiceDetails[indexPath.row]
                if let product = dao.getProductByID(productid: detail.inv_dtl_prod_id){
                    cell.InvProductName.text = "\(product.prod_name) - SL: \(detail.inv_dtl_qty) - Gia : \(detail.inv_dtl_price) - Thanh tien : \(Double(detail.inv_dtl_qty) * detail.inv_dtl_price)"
                    }
                    else {
                        cell.InvProductName.text = "San pham khong ton tai"
                    }
                } else {
                // Lay du lieu tu DataSource
                let product = selectedProducts[indexPath.row]
                //let product = products[indexPath.row]
                cell.InvProductName.text = "\(product.prod_name) - SL: \(quantities[indexPath.row]) - Gia : \(product.prod_price) - Thanh tien : \(Double(quantities[indexPath.row]) * product.prod_price)"
                }
            return cell
        }
        // Khong tao duoc cell
        fatalError("Khong the tao cell!")
    }
    //
    // Override to support editing the table view. ===>check lai
   /* func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
       
        guard !isViewInvoiceDetail else { return }
        
        if editingStyle == .delete {
           
            selectedProducts.remove(at: indexPath.row)
            quantities.remove(at: indexPath.row)
            
          
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateTotalAmount()
        }
    }
    func tableView(_ tableView: UITableView,
                   titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete111"
    }*/
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
        if let customerVC = storyboard.instantiateViewController(withIdentifier: selectCustomerID) as? SelectCustomerController {
            customerVC.delegate = self
            self.present(customerVC, animated: true)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
              /* if let customerName = customerNameTextField.text, !customerName.isEmpty {
                   // Báo lỗi
                   return
               }*/
               // Kiểm tra xem mảng selectedProducts có dữ liệu không
               if selectedProducts.isEmpty || quantities.isEmpty {
                   print("Ban chua chon san pham.")
                   return
               }

               let total = zip(selectedProducts, quantities).reduce(0.0) {
                   $0 + (Double($1.1) * $1.0.prod_price)
               }

               // Format ngày tháng năm
               let formatter = DateFormatter()
               formatter.dateFormat = "yyyy-MM-dd"
               let formattedDate = formatter.string(from: Date())
               let customer_name = customerNameTextField.text ?? ""
               
               invoice = Invoice(inv_id: 0, inv_date: formattedDate, inv_customer_id: cust_id, inv_total: total, customer_name: customer_name, customer_phone: "")

               if let invoice = invoice {
                   if let invoiceID = dao.insertInvoice(invoice: invoice) {
                       for (index, product) in selectedProducts.enumerated() {
                           let invDetail = InvoiceDetail(inv_dtl_id: 0,
                                                      inv_dtl_inv_id: invoiceID,
                                                      inv_dtl_prod_id: product.prod_id!,
                                                      inv_dtl_qty: quantities[index],
                                                         inv_dtl_price: Double(product.prod_price)
                                                   )
                       if let invDetail = invDetail {
                           let _ = dao.insertInvoiceDetail(invoicedetail: invDetail)
                           
                           // Show chi tiet hoa don sau khi select
                          print("Da them san pham: san pham id: \(product.prod_id!), ten san pham: \(product.prod_name), so luong xuat: \(quantities[index]), gia san pham: \(product.prod_price)")
                           
                       }
                       else {
                           print("Tao chi tiet hoa don khong thanh cong")
                           
                       }
                           
                   }
               }
           } else {
               print("Tao hoa don khong thanh cong.")
           }
       }
}

// Kết nối protocol để nhận sản phẩm và số lượng
extension InvoiceDetailController: SelectProductDelegate, SelectCustomerDelegate {
    func didSelectProduct(product: Product, quantity: Int) {
        // Thêm vào danh sách sản phẩm đã chọn
        selectedProducts.append(product)
        quantities.append(quantity)
        updateTotalAmount()
        tableView.reloadData()
        print("check didSelectProduct hoat dong")
    }
    func didSelectCustomer(customer: Customer) {
        // Them vao customer da chon
        selectCustomer = customer
        showCustomer()
        print("check didSelectCustomer hoat dong")
    }
    
}
