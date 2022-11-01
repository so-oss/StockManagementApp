//
//  ViewController.swift
//  FM-Task1
//
//  Created by SoiriYuichi on 2022/06/24.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentField: UITextField!
    
//    var cellList = [CellModel]()
    var mytimer:Timer!
    var count = 0

    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        countLabel.text = String(count)
        displayTimer()
        prepareDelegate()
    }

    @IBAction func countUpButton(_ sender: Any) {
        if count < 9999 {
            //+ボタンで１を足す
            count += 1
            countLabel.text = String.localizedStringWithFormat("%d", count)
        }
    }
    
    @IBAction func countDownButton(_ sender: Any) {
        if count > 0 {
            //-ボタンで１を引く
            count -= 1
            countLabel.text = String.localizedStringWithFormat("%d", count)
        }
    }
    
    @IBAction func addStockList(_ sender: Any) {
        let cellModel = CellModel()
        cellModel.time = date.text!
        cellModel.stockCount = countLabel.text!
        cellModel.comment = commentField.text!
        cellModel.check = false
        try! realm.write{
            realm.add(cellModel)
        }
//        cellList.append(cellModel)
        commentField.text = ""
        tableView.reloadData()
    }
    
    @IBAction func clearButton(_ sender: Any) {
        try!realm.write{
            realm.deleteAll()
        }
        tableView.reloadData()
    }
    
    @IBAction func calcButton(_ sender: Any) {
        let calcList = realm.objects(CellModel.self).filter({ $0.check})
        var sumValue = 0

        for i in calcList {
            sumValue += Int(i.stockCount)!
        }
        
        //アラートのタイトル
        let dialog = UIAlertController(title: nil, message: "合計\(sumValue)です。", preferredStyle: .alert)
        //ボタンのタイトル
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //表示させる
        self.present(dialog, animated: true, completion: nil)
    }

    func prepareDelegate(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = true
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
    }
    
    func displayTimer(){
        timecheck()
        mytimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timecheck), userInfo: nil, repeats: true)
    }
    
    @objc func timecheck(){
        //時間を表示する
        let nowdate = Date()
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("Hms")
        date.text = formatter.string(from: nowdate)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(CellModel.self).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        let cellList = realm.objects(CellModel.self)
        
        cell.indexPathRow = indexPath.row
        cell.delegate = self

        cell.timeLabel.text = cellList[indexPath.row].time
        cell.countLabel.text = cellList[indexPath.row].stockCount
        cell.commentLabel.text = cellList[indexPath.row].comment
        cell.checkBox.isSelected = cellList[indexPath.row].check
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
  
        if cell.checkBox.isSelected == true {
            cell.backgroundColor = UIColor.systemGreen
        } else {
            if cell.indexPathRow % 2 == 0{
                cell.backgroundColor = UIColor.lightGray
            } else {
                cell.backgroundColor = UIColor.white
            }
        }
        return cell
    }
}

extension ViewController: TableViewCellDelegate {
    func customCellDelegateDidTapButton(indexPathRow: Int) {
        let cellList = realm.objects(CellModel.self)
        let targetCell = cellList[indexPathRow]
        try!realm.write{
            realm.delete(targetCell)
        }
        tableView.reloadData()
    }

    func customCellDelegateDidTapCheckBox(indexPathRow: Int) {
        let cellList = realm.objects(CellModel.self)
        cellList[indexPathRow].check = !cellList[indexPathRow].check
        tableView.reloadData()
    }
    
    func customCellDelegateDidTapDetail(indexPathRow: Int) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Detail", bundle: nil)
        let detailView = storyboard.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        
        detailView.delegate = self
        
        let cellList = realm.objects(CellModel.self)
        let cell = cellList[indexPathRow]
        
        let navigationTitleLabel = cell.time + "　" + cell.stockCount + "　" + cell.comment
        detailView.navigationTitle = navigationTitleLabel
        detailView.indexPathRow = indexPathRow
    
        let pictureView = cell.image
        detailView.image = pictureView
        detailView.modalPresentationStyle = .fullScreen
        self.present(detailView, animated: true, completion: nil)
    }
}

extension ViewController: PictureDelegate {
    func pictureDelegate(image: UIImage, indexPathRow: Int) {
        let cellList = realm.objects(CellModel.self)
        try!realm.write{
            cellList[indexPathRow].image = image
        }
    }
}
