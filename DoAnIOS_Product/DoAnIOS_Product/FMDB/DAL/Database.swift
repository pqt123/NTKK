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
    private let DB_NAME = "products.sqlite"
    private let DB_PATH:String?
    private let database:FMDatabase?
    // MARK: Dinh nghia thuoc tinh cua cac bang du lieu
    // 1. Bang meals
    private let PRODUCT_TABLE_NAME = "products"
    private let PRODUCT_ID = "_id"
    private let PRODUCT_NAME = "prod_name"
    private let PRODUCT_QTY = "prod_qty"
    private let PRODUCT_PRICE = "prod_price"
    private let PRODUCT_IMAGE = "prod_image"
    //private let MEAL_RATING = "rating"
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
            os_log("Khoi tao CSDL thanh cong")
            // Tao cac bang du lieu o day
            // 1 Tao bang meals
            let sql = "CREATE TABLE \(PRODUCT_TABLE_NAME)("
            + "\(PRODUCT_ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "\(PRODUCT_NAME) TEXT, "
            + "\(PRODUCT_QTY) INTEGER, "
            + "\(PRODUCT_PRICE) DOUBLE, "
            + "\(PRODUCT_IMAGE) TEXT)"
            let _ = tableCreate(sql: sql, tableName: PRODUCT_TABLE_NAME)
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
    // 1 Them meal vao CSDL
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
    // 2 Doc toan bo meals tu CSDL
    func readProducts(products: inout [Product]){
        if open(){
            if database!.tableExists(PRODUCT_TABLE_NAME){
                // Cau lenh SQL
                let sql = "SELECT * FROM \(PRODUCT_TABLE_NAME) ORDER BY \(PRODUCT_ID) DESC"
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
                        if let qty = Int(prod_qty),
                           let price = Double(prod_price) {
                            
                            // Tạo đối tượng Product nếu ép kiểu thành công
                            if let product = Product(prod_name: prod_name,
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
