//
//  InvoiceTableViewController.swift
//  DoAnIOS_Product
//
//  Created by  User on 07.05.2025.
//

import UIKit

class InvoiceTableViewController: UITableViewController {

    private var invoices = [Invoice]()
    private let dao = Database()
    private let invoiceDetailID = "InvoiceDetailController"

    enum NavigationType {
        case newInvoice
        case editInvoice
    }

    var navigationType: NavigationType = .newInvoice
    private var selectedIndexpath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        dao.readInvoices(invoices: &invoices)
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoices.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "InvoiceCell"

        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? InvoiceCell {
                    
            // Lay du lieu tu DataSource
            let invoice = invoices[indexPath.row]
            
            // Do du lieu tu invoice vao cell
            cell.invDate.text = invoice.inv_date
            cell.invCustomer.text = invoice.customer_name
            cell.invTotal.text = String(format: "%.2f", invoice.inv_total)
            
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
            print("\(invoice.inv_customer_id)")
            return cell
        }
        
        // Khong tao duoc cell
        fatalError("Khong the tao cell!")
    }

    @IBAction func newInvoice(_ sender: UIBarButtonItem) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: invoiceDetailID) as? InvoiceDetailController {
            navigationType = .newInvoice
            present(detailVC, animated: true)
        }
        
    }
    
    @IBAction func reloadTableInv(_ sender: UIBarButtonItem) {
        invoices.removeAll()
        let _ = dao.readInvoices(invoices: &invoices)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let invoiceDetail = self.storyboard!.instantiateViewController(withIdentifier: invoiceDetailID) as? InvoiceDetailController {
                // Lay doi tuong cell duoc tap
                // Truyen invoicedetail sang InvoiceDetailController
                invoiceDetail.invoice = invoices[indexPath.row]
                
                // Danh dau duong di
                navigationType = .editInvoice
                
                // Luu vi tri cell duoc chon
                selectedIndexpath = indexPath
                //print("data : \(invoiceDetail.invoice)")
                // Chuyen sang man hinh khac
                present(invoiceDetail, animated: true)
            }
        
    }
    // Override to support editing the table view.
  /*  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Xoa phan tu tu datasource
            invoices.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }*/
    
    

    @IBAction func unwindFromInvoiceDetail(_ segue: UIStoryboardSegue) {
        if let detailVC = segue.source as? InvoiceDetailController,
           let invoice = detailVC.invoice {
            switch navigationType {
            case .newInvoice:
                invoices.append(invoice)
               let newIndexPath = IndexPath(row: invoices.count - 1, section: 0)
              tableView.insertRows(at: [newIndexPath], with: .left)
                
                //Them invoice moi vao CSDL
                //let _ = dao.insertInvoice(invoice: invoice)
            case .editInvoice:
                if let indexPath = selectedIndexpath {
                    // Update datasource
                    invoices[indexPath.row] = invoice
                    
                    // Update tableView cell
                    // Edit product moi vao CSDL
                   // let _ = dao.editProduct(product: product)
                    tableView.reloadRows(at: [indexPath], with: .left)
                }
            }
        }
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Lay doi tuong man hinh MealDetailController
        if let invDetail = segue.destination as? InvoiceDetailController {
            // Lay doi tuong cell duoc tap
            if let cell = sender as? InvoiceCell {
                // Xac dinh vi tri cua cell trong table view
                if let indexPath = tableView.indexPath(for: cell) {
                    // Truyen meal sang mealDetailController
                    invDetail.invoice = invoices[indexPath.row]
                    
                    // Danh dau duong di
                    navigationType = .editInvoice
                    
                    // Luu vi tri cell duoc chon
                    selectedIndexpath = indexPath
                    
                    print("tetttt22222")
                    // Chuyen sang man hinh khac
                    //present(mealDetail, animated: true)
                }
            }
        }
    }
    //Format total
    func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "vi_VN")
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
}
