//
//  Database.swift
//  DoAnIOS_Product
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
    //private let MEAL_RATING = "rating"
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
    private let INV_DTL_PRODUCT_ID = "inv_dtl_prod_id"
    private let INV_DTL_QTY = "inv_dtl_qty"    // MARK: Constructors
    init() {
        // Lay cac thu muc co san trong ung dung ios
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        // Khoi tao DB_PATH
        DB_PATH=directories[0] + "/" + DB_NAME
        // Khoi tao CSDL
        database = FMDatabase(path: DB_PATH)
        // Thong bao su thanh cong cua CSDL
        if database != nil {
            os_log("Khoi tao CSDL thanh cong")
            // Tao cac bang du lieu o day
            
            // 4 Tao bang invoices detail
            let invdetailSQL = "CREATE TABLE \(INV_DTL_TABLE_NAME)("
            + "\(INV_DTL_ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "\(INV_DTL_INV_ID) INTEGER, "
            + "\(INV_DTL_PRODUCT_ID) INTEGER, "
            + "\(INV_DTL_QTY) INTEGER)"
            let _ = tableCreate(sql: invdetailSQL, tableName: INV_DTL_TABLE_NAME)
            
            // 3 Tao bang invoices
            let invSQL = "CREATE TABLE \(INV_TABLE_NAME)("
            + "\(INV_ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "\(INV_DATE) TEXT, "
            + "\(INV_CUSTOMER_ID) INTEGER),"
            + "\(INV_TOTAL) DOUBLE)"
            let _ = tableCreate(sql: invSQL, tableName: INV_TABLE_NAME)
            
            
            // 2Tao bang products
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
    ///Them invoices vao CSDL
    func insertInvoice(invoice: Invoice) -> Int? {
        var insertedId: Int? = nil
            if open() {
                let sql = "INSERT INTO \(INV_TABLE_NAME) (\(INV_DATE), \(INV_CUSTOMER_ID), \(INV_TOTAL) VALUES (?, ?, ?)"
                if database!.executeUpdate(sql, withArgumentsIn: [invoice.inv_date, invoice.inv_customer_id, invoice.inv_total]) {
                    //Id vua duoc insert
                    insertedId = Int(database!.lastInsertRowId)
                }
                close()
            }
            return insertedId
    }
    //insert invoice detail
    func insertInvoiceDetail(invoicedetail: InvoiceDetail) -> Bool {
        var OK = false
        if open() {
            let sql = "INSERT INTO \(INV_DTL_TABLE_NAME)(\(INV_DTL_INV_ID),  \(INV_DTL_PRODUCT_ID), \(INV_DTL_QTY) VALUES (?, ?, ?)"
            OK = database!.executeUpdate(sql, withArgumentsIn: [invoicedetail.inv_dtl_inv_id, invoicedetail.inv_dtl_prod_id, invoicedetail.inv_dtl_qty])
            close()
        }
        return OK
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
                        let user_username = result.string(forColumn: USER_NAME) ?? ""
                        let user_password = result.string(forColumn: USER_PASSWORD) ?? ""
                        // Tao doi tuong user tu CSDL
                        if let user = User(user_nameuser: user_username, user_password: user_password){
                            // Dua vao datasource cua TableView
                            users.append(user)
                            
                        }
                    }
                }
            }
        }
    }
    //Kiem tra UserName da ton tai chua
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
    // Kiểm tra thông tin đăng nhập
    func checkLogin(user_username: String, user_password: String) -> Bool {
        var OK = false
        if open() {
            let sql = "SELECT * FROM \(USER_TABLE_NAME) WHERE \(USER_NAME) = ? AND \(USER_PASSWORD) = ?"
            do {
                let result = try database!.executeQuery(sql, values: [user_username, user_password])
                if result.next() {
                    OK = true //Neu tim thay ket qua, dang nhap thanh cong
                }
            } catch {
                os_log("Khong the truy van CSDL")
            }
            close()
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
                        let prod_qty = result.string(forColumn: PRODUCT_QTY) ?? ""
                        let prod_price = result.string(forColumn: PRODUCT_PRICE) ?? ""
                      //  let rating = result.int(forColumn: MEAL_RATING)
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
                        //Ep kieu
                        if let qty = Int(prod_qty),
                           let price = Double(prod_price) {
                            if let product = Product(prod_id: Int(prod_id),
                                                     prod_name: prod_name,
                                                     prod_qty: qty,
                                                     prod_price: price,
                                                     prod_image: prod_image) {
                                // Thêm vào datasource của TableView
                                products.append(product)
                            }
                        }
                        /*if let product = Product(prod_name: prod_name, prod_qty: Int(prod_qty), prod_price: Double(prod_price), prod_image: prod_image){
                            // Dua vao datasource cua TableView
                            products.append(product)
                        }*/
                    }
                }
            }
        }
    }
}

