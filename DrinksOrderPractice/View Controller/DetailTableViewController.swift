//
//  DetailTableViewController.swift
//  DrinksOrderPractice
//
//  Created by Tai Chin Huang on 2021/5/3.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var drinkButton: UIButton!
    @IBOutlet weak var sizeSegment: UISegmentedControl!
    @IBOutlet weak var iceSegment: UISegmentedControl!
    @IBOutlet weak var sugarSegment: UISegmentedControl!
    @IBOutlet weak var toppingSegment: UISegmentedControl!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    var orderer = ""
    var drinkName = ""
    var selectedDrink: DrinkData
    var order = Order(drinkName: nil, sizeLevel: nil, iceLevel: nil, sugarLevel: nil, extraToppings: nil, totalPrice: nil)
    
    var totalPrice = 0
    // 將enum用allCases轉換成array
    var sizeLevel = SizeLevel.allCases
    var iceLevel = IceLevel.allCases
    var sugarLevel = SugarLevel.allCases
    var extraToppings = ExtraToppings.allCases
    // init再來接收上一頁傳遞的資料
    init?(coder: NSCoder, selectedDrink: DrinkData) {
        self.selectedDrink = selectedDrink
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 載入上一頁選的菜單資訊
        loadingInfo()
    }
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    // 載入基本顯示資料，包括飲料名稱/圖片/價錢
    func loadingInfo() {
        drinkNameLabel.text = drinkName
        fetchImage()
        drinkButton.setTitle(drinkName, for: .normal)
        priceLabel.text = selectedDrink.priceM.value
    }
    func fetchImage() {
        let url = URL(string: selectedDrink.imageUrl.value)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    self.drinkImageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }
    // 確認使用者有沒有輸入完全，成功執行completeOrderAlert(並將資料上傳到訂單google sheet-執行postOrder())
    @IBAction func confirmOrder(_ sender: UIButton) {
        orderPreference()
        if let _ = order.drinkName,
           let _ = order.sizeLevel,
           let _ = order.iceLevel,
           let _ = order.sugarLevel {
            completeOrderAlert()
        } else {
            incompleteOrderAlert()
        }
    }
    // 點完餐點轉換到OrderListTableViewController
    func goToOrderList() {
        if let controller = storyboard?.instantiateViewController(identifier: "\(OrderListTableViewController.self)") {
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true, completion: nil)
        }
    }
    // 將資料上傳到google sheet上面
    func postOrder() {
        orderPreference()
        let orderItem = OrderInfo(orderer: nameTextField.text!,
                                  drinkName: order.drinkName!,
                                  sizeLevel: order.sizeLevel!.rawValue,
                                  iceLevel: order.iceLevel!.rawValue,
                                  sugarLevel: order.sugarLevel!.rawValue,
                                  extraToppings: order.extraToppings!.rawValue,
                                  totalPrice: "\(order.totalPrice!)")
        let postOrder = PostOrder(data: orderItem)
        let url = URL(string: "https://sheetdb.io/api/v1/ocn6qrzzdg1mn")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(postOrder) {
            request.httpBody = data
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data,
                   let content = String(data: data, encoding: .utf8) {
                    print(content)
                    DispatchQueue.main.async {
                        self.goToOrderList()
                    }
                } else {
                    print(error!)
                }
            }.resume()
        }
    }
    // 儲存使用者選取的項目，包括名字/飲料/大小/冰塊/甜度/加料/價錢
    func orderPreference() {
        guard let name = nameTextField.text, name.count > 0 else { return incompleteOrderAlert() }
        orderer = nameTextField.text!
        order.drinkName = drinkButton.currentTitle!
        /*
         sizeSegment.selectedSegmentIndex回傳index數值，代表了=右邊sizeLevel array所代表的大小
         ex: sizeSegment.selectedSegment == 0, 則sizeLevel[0]代表"中杯"的意思(從enum SizeLevel來的)
         */
        order.sizeLevel = sizeLevel[sizeSegment.selectedSegmentIndex]
        order.iceLevel = iceLevel[iceSegment.selectedSegmentIndex]
        order.sugarLevel = sugarLevel[sugarSegment.selectedSegmentIndex]
        order.extraToppings = extraToppings[toppingSegment.selectedSegmentIndex]
        checkTotalPrice()
        order.totalPrice = totalPrice
    }
    // 選擇大小跟加料即時更新價錢
    @IBAction func chooseSize(_ sender: UISegmentedControl) {
        checkTotalPrice()
    }
    @IBAction func chooseExtra(_ sender: UISegmentedControl) {
        checkTotalPrice()
    }
    // 依照選取的大小與加料更新價格
    func checkTotalPrice() {
        let size = sizeLevel[sizeSegment.selectedSegmentIndex]
        let extra = extraToppings[toppingSegment.selectedSegmentIndex]
        if size == .medium {
            let priceM = selectedDrink.priceM.value
            totalPrice = Int(priceM)!
            switch extra {
            case .none:
                totalPrice = Int(priceM)!
                priceLabel.text = "\(totalPrice)"
            case .boba:
                totalPrice = Int(priceM)! + 10
                priceLabel.text = "\(totalPrice)"
            }
        } else if size == .large {
            let priceL = selectedDrink.priceL.value
            totalPrice = Int(priceL)!
            if extra == .none {
                totalPrice = Int(priceL)!
                priceLabel.text = "\(totalPrice)"
            } else if extra == .boba {
                totalPrice = Int(priceL)! + 10
                priceLabel.text = "\(totalPrice)"
            }
        }
    }
    //MARK: - UIAlertViewController
    func completeOrderAlert() {
        let controller = UIAlertController(title: "訂單完成！", message: "\n\(order.drinkName!)\n\(order.sizeLevel!.rawValue)\n冰量：\(order.iceLevel!.rawValue)\n甜度：\(order.sugarLevel!.rawValue)\n加料：\(order.extraToppings!.rawValue)\n總共：\(order.totalPrice!)元", preferredStyle: .alert)
        // 取消
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        // 確認
        let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
            // 上傳database
            self.postOrder()
        }
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    func incompleteOrderAlert() {
        let controller = UIAlertController(title: "有未完成選項！", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "確定", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
}
