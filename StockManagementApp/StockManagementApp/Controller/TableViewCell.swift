//
//  TableViewCell.swift
//  FM-Task1
//
//  Created by SoiriYuichi on 2022/07/29.
//

import UIKit

protocol TableViewCellDelegate {
    func customCellDelegateDidTapButton(indexPathRow: Int)
    func customCellDelegateDidTapCheckBox(indexPathRow: Int)
    func customCellDelegateDidTapDetail(indexPathRow: Int)
}

class TableViewCell: UITableViewCell {

    var delegate: TableViewCellDelegate?
    var indexPathRow = 0
    let checkOnImage = UIImage(named: "ico_check_on")
    
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //チェックボックスの初期化
        checkBox.setImage(checkOnImage, for: .selected)
        checkBox.isSelected = false
    }

    @IBAction func deleteButton(_ sender: Any) {
        delegate?.customCellDelegateDidTapButton(indexPathRow: indexPathRow)
    }

    @IBAction func checkAction(_ sender: Any) {
        delegate?.customCellDelegateDidTapCheckBox(indexPathRow: indexPathRow)
    }
    
    @IBAction func detailButton(_ sender: Any) {
        delegate?.customCellDelegateDidTapDetail(indexPathRow: indexPathRow)
    }
}
