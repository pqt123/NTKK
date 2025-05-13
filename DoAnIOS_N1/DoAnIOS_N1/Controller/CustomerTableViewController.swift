//
//  CustomerTableViewController.swift
//  DoAnIOS_N1
//
//  Created by  User on 13.05.2025.
//

import UIKit

class CustomerTableViewController: UITableViewController {

    //MARK
    
    private var customers = [Customer]()
    @IBOutlet weak var navigation: UINavigationItem!
    private let customerDetailID = "CustomerDetailController"
    
    
    // Tao doi tuong truy van CSDL
    private let dao = Database()
    
    // Dinh nghia kieu du lieu enum dung danh dau duong di
    enum NavigationType {
        case newCustomer
        case editCustomer
    }
    
    // Dinh nghia bien danh dau duong di
    var navigationType:NavigationType = .newCustomer
    
    // Bien luu gia tri Indexpath
    private var selectedIndexpath:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Them Edit Button cho Navigation Bar
        navigation.leftBarButtonItem = editButtonItem
        
        // Doc toan bo du lieu meals tu CSDL neu co
        dao.readCustomers(customers: &customers)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    // So luong layouts (cell) trong tableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // So luong phan tu trong Array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return customers.count
    }
    
    // indexPath = vi tri phan tu trong Array
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "CustomerCell"
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? CustomerCell {
            
            // Lay du lieu tu DataSource
            let customer = customers[indexPath.row]
            
            // Do du lieu tu customer vao cell
            cell.customerInfo.text = customer.customer_name + " - " + customer.customer_phone
            
            /*
             // Bo sung them cho bat su kien theo cach 1
             if cell.onTap == nil {
             // Khoi tao cho doi tuong onTap
             cell.onTap = UITapGestureRecognizer()
             // Bat su kien cho doi tuong onTap
             cell.onTap!.addTarget(self, action: #selector(editCustomer))
             
             // Ket noi doi tuong onTap voi cell
             cell.addGestureRecognizer(cell.onTap!)
             }
             */
            //print(customer.customer_id)
            return cell
        }
        
        // Khong tao duoc cell
        fatalError("Khong the tao cell!")
        
    }
    
    // Dinh nghia ham xu ly su kien cho cell
    @objc private func editCustomer(_ sender: UITapGestureRecognizer) {
        //print("Cell tapped")
        // Tao doi tuong man hinh customerDetailController
        if let customerDetail = self.storyboard!.instantiateViewController(withIdentifier: customerDetailID) as? CustomerDetailController {
            // Lay doi tuong cell duoc tap
            if let cell = sender.view as? CustomerCell {
                // Xac dinh vi tri cua cell trong table view
                if let indexPath = tableView.indexPath(for: cell) {
                    // Truyen customer sang customerDetailController
                    customerDetail.customer = customers[indexPath.row]
                    // Danh dau duong di
                    navigationType = .editCustomer
                    
                    // Luu vi tri cell duoc chon
                    selectedIndexpath = indexPath
                    
                    // Chuyen sang man hinh khac
                    present(customerDetail, animated: true)
                }
            }
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Xoa phan tu tu datasource
            //Lay khach hang can xoa
            let customerDelete = customers[indexPath.row]
            //print("test delete id : \(customerDelete.customer_id)")
            //goi ham xoa trong database
           if dao.deleteCustomer(customer: customerDelete){
                //xoa khoi datasource
                customers.remove(at: indexPath.row)
                // Delete the row from the data source
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            } else{
                print("Xoa khach hang khong thanh cong")
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    
     /*// Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Cell tapped")
        // Tao doi tuong man hinh customerDetailController
        if let customerDetail = self.storyboard!.instantiateViewController(withIdentifier: customerDetailID) as? CustomerDetailController {
            // Lay doi tuong cell duoc tap
            // Truyen customer sang mealDetailController
            customerDetail.customer = customers[indexPath.row]
            
            // Danh dau duong di
            navigationType = .editCustomer
            
            // Luu vi tri cell duoc chon
            selectedIndexpath = indexPath
           // print("data : \(customerDetail.customer)")
            // Chuyen sang man hinh khac
            present(customerDetail, animated: true)
        }
    }
    
    @IBAction func newCustomer(_ sender: UIBarButtonItem) {
        // Tao doi tuong man hinh customerDetailController
        if let customerDetail = self.storyboard!.instantiateViewController(withIdentifier: customerDetailID) as? CustomerDetailController {
            // Danh dau duong di
            navigationType = .newCustomer
            
            // Chuyen sang man hinh khac
            present(customerDetail, animated: true)
        }
        
    }
    // Dinh nghia ham unwind quay ve tu customerDetailController
    @IBAction func unwindFromcustomerCustomerController(_ segue: UIStoryboardSegue) {
        //print("unwind from customer detail")
        // Lay doi tuong man hinh customerDetailController
        if let customerDetail = segue.source as? CustomerDetailController {
            if let customer = customerDetail.customer {
                switch navigationType {
                case .newCustomer:
                    // Them customer moi vao datasource
                    customers.append(customer)
                    // Tao mot dong (cell) moi cho tableView
                    let newIndexPath = IndexPath(row: customers.count - 1, section: 0)
                    tableView.insertRows(at: [newIndexPath], with: .left)
                    // Them customer moi vao CSDL
                    let _ = dao.insertCustomer(customer: customer)
                case .editCustomer :
                    
                    if let indexPath = selectedIndexpath {
                        // Update datasource
                        customers[indexPath.row] = customer
                        
                        // Update tableView cell
                        // Edit customer moi vao CSDL
                        let _ = dao.editCustomer(customer: customer)
                        tableView.reloadRows(at: [indexPath], with: .left)
                    }
                }
            }
        }
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Lay doi tuong man hinh customerDetailController
        if let customerDetail = segue.destination as? CustomerDetailController {
            // Lay doi tuong cell duoc tap
            if let cell = sender as? CustomerCell {
                // Xac dinh vi tri cua cell trong table view
                if let indexPath = tableView.indexPath(for: cell) {
                    // Truyen meal sang mealDetailController
                    customerDetail.customer = customers[indexPath.row]
                    
                    // Danh dau duong di
                    navigationType = .editCustomer
                    
                    // Luu vi tri cell duoc chon
                    selectedIndexpath = indexPath
                    
                    // Chuyen sang man hinh khac
                    //present(customerDetail, animated: true)
                }
            }
        }
    }
}
