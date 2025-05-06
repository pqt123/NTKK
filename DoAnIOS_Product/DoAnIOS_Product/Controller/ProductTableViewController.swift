//
//  ProductTableViewController.swift
//  DoAnIOS_Product
//
//  Created by  User on 23.04.2025.
//

import UIKit

class ProductTableViewController: UITableViewController {
    //MARK
    
    private var products = [Product]()
    @IBOutlet weak var navigation: UINavigationItem!
    private let productDetailID = "ProductDetailController"
    
    
    // Tao doi tuong truy van CSDL
    private let dao = Database()
    
    // Dinh nghia kieu du lieu enum dung danh dau duong di
    enum NavigationType {
        case newProduct
        case editProduct
    }
    
    // Dinh nghia bien danh dau duong di
    var navigationType:NavigationType = .newProduct
    
    // Bien luu gia tri Indexpath
    private var selectedIndexpath:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Them Edit Button cho Navigation Bar
        navigation.leftBarButtonItem = editButtonItem
        
        // Doc toan bo du lieu meals tu CSDL neu co
        dao.readProducts(products: &products)
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
        return products.count
    }
    
    // indexPath = vi tri phan tu trong Array
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "ProductCell"
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? ProductCell {
            
            // Lay du lieu tu DataSource
            let product = products[indexPath.row]
            
            // Do du lieu tu product vao cell
            cell.productName.text = product.prod_name
            cell.productQty.text = String(product.prod_qty)
            cell.productPrice.text = String(format: "%.2f", product.prod_price)
            cell.productImage.image = product.prod_image
           // cell.rating.rating = product.ratingValue
            /*
             // Bo sung them cho bat su kien theo cach 1
             if cell.onTap == nil {
             // Khoi tao cho doi tuong onTap
             cell.onTap = UITapGestureRecognizer()
             // Bat su kien cho doi tuong onTap
             cell.onTap!.addTarget(self, action: #selector(editProduct))
             
             // Ket noi doi tuong onTap voi cell
             cell.addGestureRecognizer(cell.onTap!)
             }
             */
            print(product.prod_id)
            return cell
        }
        
        // Khong tao duoc cell
        fatalError("Khong the tao cell!")
        
    }
    
    // Dinh nghia ham xu ly su kien cho cell
    @objc private func editProduct(_ sender: UITapGestureRecognizer) {
        //print("Cell tapped")
        // Tao doi tuong man hinh ProductDetailController
        if let productDetail = self.storyboard!.instantiateViewController(withIdentifier: productDetailID) as? ProductDetailController {
            // Lay doi tuong cell duoc tap
            if let cell = sender.view as? ProductCell {
                // Xac dinh vi tri cua cell trong table view
                if let indexPath = tableView.indexPath(for: cell) {
                    // Truyen meal sang ProductDetailController
                    productDetail.product = products[indexPath.row]
                    // Danh dau duong di
                    navigationType = .editProduct
                    
                    // Luu vi tri cell duoc chon
                    selectedIndexpath = indexPath
                    
                    // Chuyen sang man hinh khac
                    present(productDetail, animated: true)
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
            products.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Cell tapped")
        // Tao doi tuong man hinh ProductDetailController
        if let productDetail = self.storyboard!.instantiateViewController(withIdentifier: productDetailID) as? ProductDetailController {
            // Lay doi tuong cell duoc tap
            // Truyen product sang mealDetailController
            productDetail.product = products[indexPath.row]
            
            // Danh dau duong di
            navigationType = .editProduct
            
            // Luu vi tri cell duoc chon
            selectedIndexpath = indexPath
           // print("data : \(productDetail.product)")
            // Chuyen sang man hinh khac
            present(productDetail, animated: true)
        }
    }
    
    @IBAction func newProduct(_ sender: UIBarButtonItem) {
        // Tao doi tuong man hinh ProductDetailController
        if let productDetail = self.storyboard!.instantiateViewController(withIdentifier: productDetailID) as? ProductDetailController {
            // Danh dau duong di
            navigationType = .newProduct
            
            // Chuyen sang man hinh khac
            present(productDetail, animated: true)
            print("test")
        }
        
    }
    // Dinh nghia ham unwind quay ve tu ProductDetailController
    @IBAction func unwindFromProductDetailController(_ segue: UIStoryboardSegue) {
        //print("unwind from product detail")
        // Lay doi tuong man hinh ProductDetailController
        if let productDetail = segue.source as? ProductDetailController {
            if let product = productDetail.product {
                switch navigationType {
                case .newProduct:
                    // Them product moi vao datasource
                    products.append(product)
                    // Tao mot dong (cell) moi cho tableView
                    let newIndexPath = IndexPath(row: products.count - 1, section: 0)
                    tableView.insertRows(at: [newIndexPath], with: .left)
                    // Them product moi vao CSDL
                    let _ = dao.insertProduct(product: product)
                case .editProduct :
                    
                    if let indexPath = selectedIndexpath {
                        // Update datasource
                        products[indexPath.row] = product
                        
                        // Update tableView cell
                        // Edit product moi vao CSDL
                        let _ = dao.editProduct(product: product)
                        tableView.reloadRows(at: [indexPath], with: .left)
                    }
                }
            }
        }
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Lay doi tuong man hinh ProductDetailController
        if let productDetail = segue.destination as? ProductDetailController {
            // Lay doi tuong cell duoc tap
            if let cell = sender as? ProductCell {
                // Xac dinh vi tri cua cell trong table view
                if let indexPath = tableView.indexPath(for: cell) {
                    // Truyen meal sang mealDetailController
                    productDetail.product = products[indexPath.row]
                    
                    // Danh dau duong di
                    navigationType = .editProduct
                    
                    // Luu vi tri cell duoc chon
                    selectedIndexpath = indexPath
                    
                    // Chuyen sang man hinh khac
                    //present(productDetail, animated: true)
                }
            }
        }
    }
    
    
}
