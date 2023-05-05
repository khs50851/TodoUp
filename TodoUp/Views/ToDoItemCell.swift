//
//  ToDoItemCell.swift
//  TodoUp
//
//  Created by user on 2023/04/08.
//

import UIKit

class ToDoItemCell: UITableViewCell {


    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var toDoTextLabel: UILabel!
    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    
    @IBOutlet weak var miniView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
    }

    // Item을 전달받을 변수 (전달 받으면 ==> 표시하는 메서드 실행) ⭐️
    var item: Item? {
        didSet {
            configureUIwithData()
        }
    }
    
    // (델리게이트 대신에) 실행하고 싶은 클로저 저장
    // 뷰컨트롤러에 있는 클로저 저장할 예정 (셀(자신)을 전달)
    var deleteBtnPressed: (ToDoItemCell) -> Void = { (sender) in }
    var checkBtnPressed: (ToDoItemCell) -> Void = { (sender) in }
    
    // 기본 UI
    func configureUI() {
        bgView.clipsToBounds = true
        bgView.layer.cornerRadius = 8
        
        deleteBtn.clipsToBounds = true
        deleteBtn.layer.cornerRadius = 10
        deleteBtn.tintColor = .darkGray
        
        checkBtn.layer.borderWidth = 2
        checkBtn.layer.borderColor = UIColor.lightGray.cgColor
        checkBtn.clipsToBounds = true
        checkBtn.layer.cornerRadius = 10
    }
    
  
    func configureUIwithData() {
        toDoTextLabel.text = item?.content
        dateTextLabel.text = item?.dateString
        checkBtn.tintColor = .darkGray
        deleteBtn.setTitleColor(.white, for: .normal)
        
        guard let colorNum = item?.color else { return }
        
        let color = MyColor(rawValue: colorNum) ?? .pink
        miniView.backgroundColor = color.buttonColor
        bgView.backgroundColor = color.buttonColor
        
        guard let done = item?.checkdone else {return}
        
        if done {
            checkBtn.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
            checkBtn.layer.borderWidth = 0
        }else {
            checkBtn.setImage(UIImage(), for: .normal)
            checkBtn.layer.borderWidth = 2
        }
    }
    
    @IBAction func deleteBtnTapped(_ sender: UIButton) {
        deleteBtnPressed(self)
    }
    
    @IBAction func checkBtnTapped(_ sender: UIButton) {
        checkBtn.tintColor = .darkGray
        if item?.checkdone == false  {
            checkBtn.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
            checkBtn.layer.borderWidth = 0
        }else {
            checkBtn.setImage(UIImage(), for: .normal)
            checkBtn.layer.borderWidth = 2
        }
        checkBtnPressed(self)
    }
}
