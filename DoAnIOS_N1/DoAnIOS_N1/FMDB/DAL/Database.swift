//
//  Database.swift
//  DoAnIOS_N1
//
//  Created by  User on 24.04.2025.
//

import Foundation
import UIKit
import os.log

class Database{
    // MARK: Dinh ngia cac thuoc tinh chung cua CSDL
    //private let DB_NAME = "products.sqlite"
    private let DB_NAME = "appstoremini.sqlite"
    private let DB_PATH:String?
    private let database:FMDatabase?
    // MARK: Dinh nghia thuoc tinh cua cac bang du lieu
    // 1. Bang product
    private let PRODUCT_TABLE_NAME = "products"
    private let PRODUCT_ID = "_id"
    private let PRODUCT_NAME = "prod_name"
    private let PRODUCT_QTY = "prod_qty"
    private let PRODUCT_PRICE = "prod_price"
    private let PRODUCT_IMAGE = "prod_image"
    // 2. Bang user
    private let USER_TABLE_NAME = "users"
    private let USER_ID = "_id"
    private let USER_NAME = "user_username"
    private let USER_PASSWORD = "user_password"
    // 3. Bang Invoice
    private let INV_TABLE_NAME = "invoices"
    private let INV_ID = "_id"
    private let INV_DATE = "inv_date"
    private let INV_CUSTOMER_ID = "inv_customer_id"
    private let INV_TOTAL = "inv_total"
    // 4. Bang Invoice detail = INV_DTL
    private let INV_DTL_TABLE_NAME = "invoice_details"
    private let INV_DTL_ID = "_id"
    private let INV_DTL_INV_ID = "inv_dtl_inv_id"
    private let INV_DTL_PROD_ID = "inv_dtl_prod_id"
    private let INV_DTL_QTY = "inv_dtl_qty"
    private let INV_DTL_PRICE = "inv_dtl_price"
    // 5. Bang customer
    private let CUSTOMER_TABLE_NAME = "customers"
    private let CUSTOMER_ID = "_id"
    private let CUSTOMER_NAME = "customer_name"
    private let CUSTOMER_PHONE = "customer_phone"
    // MARK: Constructors
    init() {
        // Lay cac thu muc co san trong ung dung ios
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        // Khoi tao DB_PATH
        DB_PATH=directories[0] + "/" + DB_NAME
        // Khoi tao CSDL
        database = FMDatabase(path: DB_PATH)
        // Thong bao su thanh cong cua CSDL
        if database != nil {
            os_log("Khoi tao CSDL thanh cong 1")
            // Tao cac bang du lieu o day
           /*let dropInvDTL = "DROP TABLE IF EXISTS \(INV_DTL_TABLE_NAME)"
            do{
                try database?.executeUpdate(dropInvDTL, values: nil)
                os_log("thanh cong")
            } catch{
                os_log("ko thanh cong")
            }
            let dropInv = "DROP TABLE IF EXISTS \(INV_TABLE_NAME)"
            do{
                try database?.executeUpdate(dropInv, values: nil)
                os_log("thanh cong")
            } catch{
                os_log("ko thanh cong")
            }*/
            
            
            // 5.Tao bang customers
            let custSQL = "CREATE TABLE \(CUSTOMER_TABLE_NAME)("
            + "\(CUSTOMER_ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "\(CUSTOMER_NAME) TEXT, "
            + "\(CUSTOMER_PHONE) TEXT )"
            let _ = tableCreate(sql: custSQL, tableName: CUSTOMER_TABLE_NAME)
            
            // 4 Tao bang invoices detail
            let invdetailSQL = "CREATE TABLE \(INV_DTL_TABLE_NAME)("
            + "\(INV_DTL_ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "\(INV_DTL_INV_ID) INTEGER, "
            + "\(INV_DTL_PROD_ID) INTEGER, "
            + "\(INV_DTL_QTY) INTEGER, "
            + "\(INV_DTL_PRICE) DOUBLE, "
            + "FOREIGN KEY (\(INV_DTL_PROD_ID)) REFERENCES \(PRODUCT_TABLE_NAME)(\(PRODUCT_ID)),"
            + "FOREIGN KEY (\(INV_DTL_INV_ID)) REFERENCES \(INV_TABLE_NAME)(\(INV_ID)))"
            let _ = tableCreate(sql: invdetailSQL, tableName: INV_DTL_TABLE_NAME)
            
            // 3 Tao bang invoices
            let invSQL = "CREATE TABLE \(INV_TABLE_NAME)("
            + "\(INV_ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "\(INV_DATE) TEXT, "
            + "\(INV_CUSTOMER_ID) INTEGER, "
            + "\(INV_TOTAL) DOUBLE, "
            + "FOREIGN KEY (\(INV_CUSTOMER_ID)) REFERENCES \(CUSTOMER_TABLE_NAME)(\(CUSTOMER_ID)))"
            let _ = tableCreate(sql: invSQL, tableName: INV_TABLE_NAME)
            
            
            // 2.Tao bang products
            let sql = "CREATE TABLE \(PRODUCT_TABLE_NAME)("
            + "\(PRODUCT_ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "\(PRODUCT_NAME) TEXT, "
            + "\(PRODUCT_QTY) INTEGER, "
            + "\(PRODUCT_PRICE) DOUBLE, "
            + "\(PRODUCT_IMAGE) TEXT)"
            let _ = tableCreate(sql: sql, tableName: PRODUCT_TABLE_NAME)
            
            // 1 Tao bang users
            let userSQL = "CREATE TABLE \(USER_TABLE_NAME)("
            + "\(USER_ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "\(USER_NAME) TEXT, "
            + "\(USER_PASSWORD) TEXT)"
            let _ = tableCreate(sql: userSQL, tableName: USER_TABLE_NAME)
            
        }
        else{
            os_log("Khoi tao CSDL khong thanh cong")
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////
    // MARK: Dinh nghia cac ham primitives cua CSDL
    ////////////////////////////////////////////////////////////////////////////////////
    // 1 Mo CSDL
    private func open()->Bool{
        var OK = false
        if database != nil {
            if database!.open() {
                os_log("Mo CSDL thanh cong")
                OK = true
            }
            else{
                os_log("Mo CSDL khong thanh cong")
            }
        }
        return OK
    }
    // 2 Dong CSDL
    private func close(){
        if database != nil {
            database!.close()
        }
    }
    // 3 Ham tao bang du lieu
    private func tableCreate(sql:String, tableName:String)->Bool {
        var OK = false
        if open(){
            // Kiem tra xem bang du lieu ton tai hay chua
            if !database!.tableExists(tableName) {
                // Goi ham tao bang trong FMDB
                if database!.executeStatements(sql) {
                    os_log("Tao bang du lieu \(tableName) thanh cong")
                    OK = true
                }
                else{
                    os_log("Tao bang du lieu \(tableName) khong thanh cong")
                }
            }
        }
        return OK
    }
    ////////////////////////////////////////////////////////////////////////////////////
    // MARK: Dinh nghia cac ham APIS cua CSDL
    ////////////////////////////////////////////////////////////////////////////////////
    /////1. Them customer vao CSDL
    func insertCustomer(customer:Customer)->Bool {
        var OK = false
        if open() {
            if database!.tableExists(CUSTOMER_TABLE_NAME){
                // Cau lenh SQL
                let sql = "INSERT INTO \(CUSTOMER_TABLE_NAME)(\(CUSTOMER_NAME),  \(CUSTOMER_PHONE)) VALUES (?, ?)"
                // Ghi du lieu vao bang customer cua CSDL
                if database!.executeUpdate(sql, withArgumentsIn: [customer.customer_name, customer.customer_phone]){
                    os_log("Them du lieu customer thanh cong")
                    OK = true
                }
                else{
                    os_log("Them du lieu khong thanh cong")
                }
                // Dong CSDL
                close()
            }
            else{
                os_log("Bang du lieu chua ton tai ")
            }
        }
        return OK
    }
    // 2 Doc toan bo customers tu CSDL
    func readCustomers(customers: inout [Customer]){
        if open(){
            if database!.tableExists(CUSTOMER_TABLE_NAME){
                // Cau lenh SQL
                let sql = "SELECT * FROM \(CUSTOMER_TABLE_NAME) ORDER BY \(CUSTOMER_ID) DESC"
                // Khai bao bien chua du lieu doc ve tu CSDL
                var result:FMResultSet?
                do{
                    result = try database!.executeQuery(sql, values: nil)
                }
                catch{
                    os_log("Khong the truy van CSDL")
                }
                // Doc du lieu tu bien result
                if let result = result {
                    while result.next(){
                        let customer_id = result.int(forColumn: CUSTOMER_ID)
                        let customer_name = result.string(forColumn: CUSTOMER_NAME) ?? ""
                        let customer_phone = result.string(forColumn: CUSTOMER_PHONE) ?? ""
                        // Tao doi tuong user tu CSDL
                        //print("data: \(customer_phone)")
                        if let customer = Customer(customer_id: Int(customer_id), customer_name: customer_name, customer_phone: customer_phone){
                            // Dua vao datasource cua TableView
                            //print("\(customer)")
                            customers.append(customer)
                            
                        }
                    }
                }
            }
        }
    }
    
    // 3 Sua thong tin customer
    func editCustomer(customer: Customer) -> Bool {
        var OK = false
        if open() {
            if database!.tableExists(CUSTOMER_TABLE_NAME) {
                // Câu lệnh UPDATE, giả sử bạn xác định sản phẩm theo customer ID
                let sql = "UPDATE \(CUSTOMER_TABLE_NAME) SET \(CUSTOMER_NAME) = ?, \(CUSTOMER_PHONE) = ? WHERE \(CUSTOMER_ID) = ?"

                // ghi du lie vao bang
                if database!.executeUpdate(sql, withArgumentsIn: [customer.customer_name, customer.customer_phone, customer.customer_id]) {
                    os_log("Cap nhat thong tin khach hang thanh cong")
                    OK = true
                } else {
                    os_log("Cap nhat thong tin khachs hang khong thanh cong", database!.lastErrorMessage())
                }

                close()
            } else {
                os_log("Bang du lieu Customer khong ton tai")
            }
        }
        return OK
    }
    
    // 4 Xoa thong tin customer
    func deleteCustomer(customer: Customer) -> Bool {
        var OK = false
        if open() {
            if database!.tableExists(CUSTOMER_TABLE_NAME) {
                // cau lenh xoa customer theo customer id
                let sql = "DELETE FROM \(CUSTOMER_TABLE_NAME)  WHERE \(CUSTOMER_ID) = ?"

                // ghi du lie vao bang
                if database!.executeUpdate(sql, withArgumentsIn: [ customer.customer_id]) {
                    os_log("Xoa khach hang thanh cong")
                    OK = true
                } else {
                    os_log("Xoa khach hang khong thanh cong", database!.lastErrorMessage())
                }

                close()
            } else {
                os_log("Bang du lieu Customer khong ton tai")
            }
        }
        return OK
    }
    // 5 Tim kiem customer theo so dien thoai tu CSDL
    func searchCustomer(keyword: String, customers: inout [Customer]){
        if open(){
            if database!.tableExists(CUSTOMER_TABLE_NAME){
                // Cau lenh SQL
                let sql = "SELECT * FROM \(CUSTOMER_TABLE_NAME) WHERE  \(CUSTOMER_PHONE) LIKE ?  ORDER BY \(CUSTOMER_ID) DESC"
                // Khai bao bien chua du lieu doc ve tu CSDL
                var result:FMResultSet?
                do{
                    result = try database!.executeQuery(sql, values:["%\(keyword)%"])
                }
                catch{
                    os_log("Khong the truy van tu khoa Customer: ", keyword)
                    
                }
                // Doc du lieu tu bien result
                if let result = result {
                    while result.next(){
                        let customer_id = result.int(forColumn: CUSTOMER_ID)
                        let customer_name = result.string(forColumn: CUSTOMER_NAME) ?? ""
                        let customer_phone = result.string(forColumn: CUSTOMER_PHONE) ?? ""
                        // Tao doi tuong user tu CSDL
                        //print("data: \(customer_phone)")
                        if let customer = Customer(customer_id: Int(customer_id), customer_name: customer_name, customer_phone: customer_phone){
                            // Dua vao datasource cua TableView
                            print("\(customer.customer_name)")
                            customers.append(customer)
                            
                        }
                    }
                }
            }
        }
    }
    ///1.Them invoices vao CSDL
    func insertInvoice(invoice: Invoice) -> Int? {
        var insertedId: Int? = nil
            if open() {
                let sql = "INSERT INTO \(INV_TABLE_NAME) (\(INV_DATE), \(INV_CUSTOMER_ID), \(INV_TOTAL)) VALUES (?, ?, ?)"
                if database!.executeUpdate(sql, withArgumentsIn: [invoice.inv_date, invoice.inv_customer_id, invoice.inv_total]) {
                    //Id vua duoc insert
                    insertedId = Int(database!.lastInsertRowId)
                }
                close()
            }
            return insertedId
    }
    // 2 Doc toan bo invoices tu CSDL
    func readInvoices(invoices: inout [Invoice]) {
        if open() {
            if database!.tableExists(INV_TABLE_NAME) && database!.tableExists(CUSTOMER_TABLE_NAME) {
                // Câu SQL join để lấy thêm tên khách hàng
                let sql = """
                SELECT inv.\(INV_ID), inv.\(INV_DATE), inv.\(INV_CUSTOMER_ID), inv.\(INV_TOTAL),
                       cust.\(CUSTOMER_NAME),  cust.\(CUSTOMER_PHONE)               FROM \(INV_TABLE_NAME) AS inv
                LEFT JOIN \(CUSTOMER_TABLE_NAME) AS cust ON inv.\(INV_CUSTOMER_ID) = cust.\(CUSTOMER_ID)
                ORDER BY inv.\(INV_ID) DESC
                """

                var result: FMResultSet?
                do {
                    result = try database!.executeQuery(sql, values: nil)
                } catch {
                    os_log("Khong the truy van CSDL")
                }

                if let result = result {
                    while result.next() {
                        let inv_id = result.int(forColumn: INV_ID)
                        let inv_date = result.string(forColumn: INV_DATE) ?? ""
                        let inv_customer_id = result.int(forColumn: INV_CUSTOMER_ID)
                        let inv_total = result.double(forColumn: INV_TOTAL)
                        let customer_name = result.string(forColumn: CUSTOMER_NAME) ?? ""
                        let customer_phone = result.string(forColumn: CUSTOMER_PHONE) ?? ""
                        // Khởi tạo Invoice với tên khách hàng (nếu model Invoice hỗ trợ)
                        if let invoice = Invoice(inv_id: Int(inv_id),
                                                 inv_date: inv_date,
                                                 inv_customer_id: Int(inv_customer_id),
                                                 inv_total: inv_total,
                                                 customer_name: customer_name,
                                                 customer_phone: customer_phone
                                            )
                        {
                          //  print("inv : \(invoice.inv_customer_id) - \(invoice.customer_name)")                            //Dua vao datasource cua TableView
                            invoices.append(invoice)
                        }
                    }
                }
            }
        }
    }
    // 5 huy hoa don
    func invoiceCancel(invoice: Invoice) -> Bool {
        var OK = false
        if open() {
            if database!.tableExists(INV_TABLE_NAME) {
                //Xoa data dua theo product id
                let sql = "DELETE FROM \(INV_TABLE_NAME)  WHERE \(INV_ID) = ?"

                // ghi du lie vao bang
                if database!.executeUpdate(sql, withArgumentsIn: [invoice.inv_id]) {
                    os_log("Xoa hoa don thanh cong")
                    OK = true
                } else {
                    os_log("Xoa hoa don khong thanh cong", database!.lastErrorMessage())
                }

                close()
            } else {
                os_log("Bang du lieu Invoice khong ton tai")
            }
        }
        return OK
    }
    //1. Them invoice detail vao du lieu
    func insertInvoiceDetail(invoicedetail: InvoiceDetail) -> Bool {
        var OK = false
        if open() {
            let sql = "INSERT INTO \(INV_DTL_TABLE_NAME)(\(INV_DTL_INV_ID),  \(INV_DTL_PROD_ID), \(INV_DTL_QTY), \(INV_DTL_PRICE)) VALUES (?, ?, ?, ?)"
            OK = database!.executeUpdate(sql, withArgumentsIn: [invoicedetail.inv_dtl_inv_id, invoicedetail.inv_dtl_prod_id, invoicedetail.inv_dtl_qty, invoicedetail.inv_dtl_price])
            close()
        }
        return OK
    }
    // 2 Doc toan bo invoicedetails tu CSDL
    func readInvoiceDetails(for invoiceID: Int, invoicedetails: inout [InvoiceDetail]) {
        if open() {
            if database!.tableExists(INV_DTL_TABLE_NAME) {
                let sql = "SELECT * FROM \(INV_DTL_TABLE_NAME) WHERE \(INV_DTL_INV_ID) = ?"
                
                var result: FMResultSet?
                do {
                    result = try database!.executeQuery(sql, values: [invoiceID])
                } catch {
                    os_log("Không thể truy vấn CSDL")
                }
                
                if let result = result {
                    while result.next() {
                        let inv_dtl_id = result.int(forColumn: INV_DTL_ID)
                        let inv_dtl_inv_id = result.int(forColumn: INV_DTL_INV_ID)
                        let inv_dtl_prod_id = result.int(forColumn: INV_DTL_PROD_ID)
                        let inv_dtl_qty = result.int(forColumn: INV_DTL_QTY)
                        let inv_dtl_price = result.double(forColumn: INV_DTL_PRICE)
                        
                        if let invoicedetail = InvoiceDetail(
                            inv_dtl_id: Int(inv_dtl_id),
                            inv_dtl_inv_id: Int(inv_dtl_inv_id),
                            inv_dtl_prod_id: Int(inv_dtl_prod_id),
                            inv_dtl_qty: Int(inv_dtl_qty),
                            inv_dtl_price: Double(inv_dtl_price)
                        ) {
                            print("kiem tra du lieu : \(invoicedetail.inv_dtl_inv_id)")
                            invoicedetails.append(invoicedetail)
                        }
                    }
                }
            }
        }
    }
    // 5 Xoa  invoice detai hoa don chi tietl
    func deleteInvoiceDetail(for invoiceID: Int) -> Bool {
        var OK = false
        if open() {
            if database!.tableExists(INV_DTL_TABLE_NAME) {
                //Xoa data dua theo product id
                let sql = "DELETE FROM \(INV_DTL_TABLE_NAME)  WHERE \(INV_DTL_INV_ID) = ?"

                // ghi du lie vao bang
                if database!.executeUpdate(sql, withArgumentsIn: [invoiceID]) {
                    os_log("Xoa hoa don detail thanh cong inv_id: \(invoiceID)")
                    OK = true
                } else {
                    os_log("Xoa hoa don detail khong thanh cong", database!.lastErrorMessage())
                }

                close()
            } else {
                os_log("Bang du lieu invoice detail khong ton tai")
            }
        }
        return OK
    }
    //4 Update so luong trong bang product
    func updateProductQty(productid: Int, newQuantity: Int) -> Bool {
        var OK = false
        if open() {
            if database!.tableExists(PRODUCT_TABLE_NAME) {
                // Cau lenh update qty theo product id
                let sql = "UPDATE \(PRODUCT_TABLE_NAME) SET \(PRODUCT_QTY) = ?  WHERE \(PRODUCT_ID) = ?"
                // ghi du lie vao bang
                if database!.executeUpdate(sql, withArgumentsIn: [newQuantity ,productid]) {
                    os_log("Cap nhat so luong san pham thanh cong, pro_id : \(productid)")
                    OK = true
                } else {
                    os_log("Cap nhat so luong san pham khong thanh cong", database!.lastErrorMessage())
                }
                
                close()
            } else {
                os_log("Bang du lieu khong ton tai")
            }
        }
        return OK
    }
    
    //3. ham truy van san pham theo product id
    func getProductByID(productid: Int)-> Product?{
       if open(), database!.tableExists(PRODUCT_TABLE_NAME) {
               let sql =  "SELECT * FROM \(PRODUCT_TABLE_NAME) WHERE \(PRODUCT_ID) = ?"
                if let result = try? database!.executeQuery(sql, values: [productid]),
                    result.next() {
                        return Product(
                            prod_id: Int(result.int(forColumn: PRODUCT_ID)),
                            prod_name: result.string(forColumn: PRODUCT_NAME) ?? "",
                            prod_qty: Int(result.int(forColumn: PRODUCT_QTY)),
                            prod_price: Double(result.int(forColumn: PRODUCT_PRICE))
                    )
                }
            }
        return nil
    }
    //1. Them user vao CSDL
    func insertUser(user:User)->Bool {
        var OK = false
        if open() {
            if database!.tableExists(USER_TABLE_NAME){
                // Cau lenh SQL
                let sql = "INSERT INTO \(USER_TABLE_NAME)(\(USER_NAME),  \(USER_PASSWORD)) VALUES (?, ?)"
                // Ghi du lieu vao bang meals cua CSDL
                if database!.executeUpdate(sql, withArgumentsIn: [user.user_nameuser, user.user_password]){
                    os_log("Them du lieu thanh cong")
                    OK = true
                }
                else{
                    os_log("Them du lieu khong thanh cong")
                }
                // Dong CSDL
                close()
            }
            else{
                os_log("Bang du lieu chua ton tai ")
            }
        }
        return OK
    }
    // 2 Doc toan bo users tu CSDL
    func readUsers(users: inout [User]){
        if open(){
            if database!.tableExists(USER_TABLE_NAME){
                // Cau lenh SQL
                let sql = "SELECT * FROM \(USER_TABLE_NAME) ORDER BY \(USER_ID) DESC"
                // Khai bao bien chua du lieu doc ve tu CSDL
                var result:FMResultSet?
                do{
                    result = try database!.executeQuery(sql, values: nil)
                }
                catch{
                    os_log("Khong the truy van CSDL")
                }
                // Doc du lieu tu bien result
                 if let result = result {
                    while result.next(){
                        let user_id = result.int(forColumn: USER_ID)
                        let user_username = result.string(forColumn: USER_NAME) ?? ""
                        let user_password = result.string(forColumn: USER_PASSWORD) ?? ""
                        // Tao doi tuong user tu CSDL
                        if let user = User(user_id: Int(user_id),
                                           user_nameuser: user_username,
                                           user_password: user_password) {
                        // Dua vao datasource cua TableView
                            users.append(user)
                        }
                    }
                }
            }
        }
    }
    //3.Kiem tra UserName da ton tai chua
    func isUsernameExist(user_username: String) -> Bool {
        var isExist = false
        if open() {
            let sql = "SELECT * FROM \(USER_TABLE_NAME) WHERE \(USER_NAME) = ?"
            do {
                let result = try database!.executeQuery(sql, values: [user_username])
                if result.next() {
                    isExist = true
                    // Ten nguoi dung co ton tai
                }
            } catch {
                os_log("Khong the truy van CSDL")
            }
            close()
        }
        return isExist
    }
    //4. Kiểm tra thông tin đăng nhập
    func checkLogin(user_username: String, user_password: String) ->User? {
        if open() {
            let sql = "SELECT * FROM \(USER_TABLE_NAME) WHERE \(USER_NAME) = ? AND \(USER_PASSWORD) = ?"
            do {
                let result = try database!.executeQuery(sql, values: [user_username, user_password])
                if result.next() {
                    let user_id = result.int(forColumn: USER_ID)
                    let user_username = result.string(forColumn: USER_NAME) ?? ""
                    let user_password = result.string(forColumn: USER_PASSWORD) ?? ""
                    close()
                    // Tra ve User
                     return User(user_id : Int(user_id),
                                       user_nameuser: user_username,
                                 user_password: user_password)
                }
            } catch {
                os_log("Khong the truy van CSDL")
            }
            close()
        }
        return nil
    }
    //5. Change password
    func updateUserPassword(user:User)->Bool {
        var OK = false
        if open() {
            if database!.tableExists(USER_TABLE_NAME){
                // Cau lenh SQL
                let sql = "UPDATE \(USER_TABLE_NAME) SET \(USER_PASSWORD) = ? WHERE \(USER_ID) = ?"
                // Ghi du lieu vao bang meals cua CSDL
                if database!.executeUpdate(sql, withArgumentsIn: [user.user_password, user.user_id]){
                    os_log("Cap nhat password thanh cong")
                    OK = true
                }
                else{
                    os_log("Cap nhat password khong thanh cong")
                }
                // Dong CSDL
                close()
            }
            else{
                os_log("Bang du lieu chua ton tai ")
            }
        }
        return OK
    }
    
    
    // 1 Them product vao CSDL
    func insertProduct(product:Product)->Bool {
        var OK = false
        if open() {
            if database!.tableExists(PRODUCT_TABLE_NAME){
                // Cau lenh SQL
                let sql = "INSERT INTO \(PRODUCT_TABLE_NAME)(\(PRODUCT_NAME), \(PRODUCT_QTY), \(PRODUCT_PRICE), \(PRODUCT_IMAGE)) VALUES (?, ?, ?, ?)"
                // Chuyen anh thanh chuoi
                var strImage = ""
                if let image = product.prod_image {
                    // B1 Chuyen anh thanh ns data
                    let nsdataImage = image.pngData()! as NSData
                    // B2 Chuyen nsdataImage thanh chuoi
                    strImage = nsdataImage.base64EncodedString(options: .lineLength64Characters)
                }
                // Ghi du lieu vao bang meals cua CSDL
                if database!.executeUpdate(sql, withArgumentsIn: [product.prod_name, product.prod_qty, product.prod_price, strImage]){
                    os_log("Them du lieu thanh cong")
                    OK = true
                }
                else{
                    os_log("Them du lieu khong thanh cong")
                }
                // Dong CSDL
                close()
            }
            else{
                os_log("Bang du lieu chua ton tai ")
            }
        }
        return OK
    }
    //edit product
    // 2 Sua thong tin san pham
    func editProduct(product: Product) -> Bool {
        var OK = false
        if open() {
            if database!.tableExists(PRODUCT_TABLE_NAME) {
                // Câu lệnh UPDATE, giả sử bạn xác định sản phẩm theo product ID
                let sql = "UPDATE \(PRODUCT_TABLE_NAME) SET \(PRODUCT_NAME) = ?, \(PRODUCT_QTY) = ?, \(PRODUCT_PRICE) = ?, \(PRODUCT_IMAGE) = ? WHERE \(PRODUCT_ID) = ?"
                
                // Chuyen anh thanh chuoi
                var strImage = ""
                if let image = product.prod_image {
                    // B1 Chuyen anh thanh ns data
                    let nsdataImage = image.pngData()! as NSData
                    // B2 Chuyen nsdataImage thanh chuoi
                    strImage = nsdataImage.base64EncodedString(options: .lineLength64Characters)
                }
                // ghi du lie vao bang
                if database!.executeUpdate(sql, withArgumentsIn: [product.prod_name, product.prod_qty, product.prod_price, strImage, product.prod_id]) {
                    os_log("Cap nhat san pham thanh cong")
                    OK = true
                } else {
                    os_log("Cap nhat san pham khong thanh cong", database!.lastErrorMessage())
                }

                close()
            } else {
                os_log("Bang du lieu khong ton tai")
            }
        }
        return OK
    }
    // 4 Xoa thong tin customer
    func deleteProduct(product: Product) -> Bool {
        var OK = false
        if open() {
            if database!.tableExists(PRODUCT_TABLE_NAME) {
                //Xoa data dua theo product id
                let sql = "DELETE FROM \(PRODUCT_TABLE_NAME)  WHERE \(PRODUCT_ID) = ?"

                // ghi du lie vao bang
                if database!.executeUpdate(sql, withArgumentsIn: [product.prod_id]) {
                    os_log("Xoa san pham thanh cong")
                    OK = true
                } else {
                    os_log("Xoa san pham khong thanh cong", database!.lastErrorMessage())
                }

                close()
            } else {
                os_log("Bang du lieu Customer khong ton tai")
            }
        }
        return OK
    }
    //5.Tim kiem ten san pham
    func searchProduct(keyword: String, products: inout [Product]) {
        if open() {
            if database!.tableExists(PRODUCT_TABLE_NAME) {
                // Câu lệnh SQL có điều kiện tìm kiếm
                let sql = "SELECT * FROM \(PRODUCT_TABLE_NAME) WHERE \(PRODUCT_NAME) LIKE ? ORDER BY \(PRODUCT_ID) DESC"
                var result: FMResultSet?
                do {
                    result = try database!.executeQuery(sql, values: ["%\(keyword)%"])
                } catch {
                    os_log("Khong the truy van tu khoa Product : ", keyword)
                }

                // Xử lý kết quả trả về
                if let result = result {
                    while result.next(){
                        let prod_id = result.int(forColumn: PRODUCT_ID)
                        let prod_name = result.string(forColumn: PRODUCT_NAME) ?? ""
                        let prod_qty = result.int(forColumn: PRODUCT_QTY)
                        let prod_price = result.double(forColumn: PRODUCT_PRICE)
                        var prod_image:UIImage? = nil
                        if let strImage = result.string(forColumn: PRODUCT_IMAGE){
                            if !strImage.isEmpty{
                                // Chuyen chuoi thanh anh image
                                // B1 Chuyen chuoi thanh Data
                                let dataImage = Data(base64Encoded: strImage, options: .ignoreUnknownCharacters)
                                // B2 Chuyen dataImage thanh UIImage
                                prod_image = UIImage(data: dataImage!)
                            }
                        }
                        // Tao doi tuong product tu CSDL
                        if let product = Product(prod_id: Int(prod_id),
                                                 prod_name: prod_name,
                                                 prod_qty: Int(prod_qty),
                                                 prod_price: Double(prod_price),
                                                 prod_image: prod_image) {
                            // Dua vao datasource cua TableView
                            products.append(product)
                            }
                        }
                    }
                }
            }
        }
    // 2 Doc toan bo products tu CSDL
    func readProducts(products: inout [Product]){
        if open(){
            if database!.tableExists(PRODUCT_TABLE_NAME){
                // Cau lenh SQL
                let sql = "SELECT * FROM \(PRODUCT_TABLE_NAME) ORDER BY \(PRODUCT_ID) DESC"
                // Khai bao bien chua du lieu doc ve tu CSDL
                var result:FMResultSet?
                do{
                    result = try database!.executeQuery(sql, values: nil)
                    os_log("result: \(result)")
                }
                catch{
                    os_log("Khong the truy van CSDL")
                }
                // Doc du lieu tu bien result
                if let result = result {
                    while result.next(){
                        let prod_id = result.int(forColumn: PRODUCT_ID)
                        let prod_name = result.string(forColumn: PRODUCT_NAME) ?? ""
                        let prod_qty = result.int(forColumn: PRODUCT_QTY)
                        let prod_price = result.double(forColumn: PRODUCT_PRICE)
                        var prod_image:UIImage? = nil
                        if let strImage = result.string(forColumn: PRODUCT_IMAGE){
                            if !strImage.isEmpty{
                                // Chuyen chuoi thanh anh image
                                // B1 Chuyen chuoi thanh Data
                                let dataImage = Data(base64Encoded: strImage, options: .ignoreUnknownCharacters)
                                // B2 Chuyen dataImage thanh UIImage
                                prod_image = UIImage(data: dataImage!)
                            }
                        }
                        // Tao doi tuong meal tu CSDL
                        if let product = Product(prod_id: Int(prod_id),
                                                 prod_name: prod_name,
                                                 prod_qty: Int(prod_qty),
                                                 prod_price: Double(prod_price),
                                                 prod_image: prod_image) {
                            // Dua vao datasource cua TableView
                            products.append(product)
                        }
                    }
                }
            }
        }
    }
}
