//
//  DetailViewController.swift
//  TodoUp
//
//  Created by user on 2023/04/09.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var yellowBtn: UIButton!
    @IBOutlet weak var greenBtn: UIButton!
    @IBOutlet weak var blueBtn: UIButton!
    @IBOutlet weak var pinkBtn: UIButton!
    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var saveBtn: UIButton!
    
    lazy var buttons: [UIButton] = {
        return [yellowBtn, greenBtn, blueBtn, pinkBtn]
    }()
    
    var dataManager = CoreDataManager.shared
    
    var item: Item? {
        didSet {
            colorNum = item?.color
        }
    }
    
    var colorNum: Int64? = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureUI()
        setupKeyboardDown()
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
    }
    
    func setupKeyboardDown() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        myScrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func setup() {
        mainTextView.delegate = self
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 10
        saveBtn.clipsToBounds = true
        saveBtn.layer.cornerRadius = 8
        setupBtnColors()
    }
    
    func configureUI() {
        
        if let item = self.item {
            self.title = "Modify Item"
            
            guard let content = item.content else {return}
            mainTextView.text = content
            
            mainTextView.textColor = .black
            
            saveBtn.setTitleColor(UIColor.white, for: .normal)
            saveBtn.setTitle("UPDATE", for: .normal)
        
            let color = MyColor(rawValue: item.color)
            setupColorTheme(color: color)
            mainTextView.becomeFirstResponder()
        }else {
            self.title = "Create New Item"
            
            mainTextView.text = "Please input your text."
            mainTextView.textColor = .lightGray
            saveBtn.setTitleColor(UIColor.white, for: .normal)
            saveBtn.setTitle("SAVE", for: .normal)
            setupColorTheme(color: .yellow)
        }
        setupPressedBtnColor(num: colorNum ?? 1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        buttons.forEach { btn in
            btn.clipsToBounds = true
            btn.layer.cornerRadius = btn.bounds.height / 2
        }
    }
    
    @IBAction func colorBtnTapped(_ sender: UIButton) {
        
        self.colorNum = Int64(sender.tag)

        let color = MyColor(rawValue: Int64(sender.tag))
        setupColorTheme(color: color)
        setupBtnColors()
        setupPressedBtnColor(num: Int64(sender.tag))
        
    }
    
    func setupColorTheme(color: MyColor? = .yellow) {
        backgroundView.backgroundColor = color?.backgoundColor
        mainTextView.backgroundColor = color?.backgoundColor
        saveBtn.backgroundColor = color?.buttonColor
    }
    
    func setupBtnColors() {
        yellowBtn.backgroundColor = MyColor.yellow.backgoundColor
        yellowBtn.setTitleColor(MyColor.yellow.buttonColor, for: .normal)
        greenBtn.backgroundColor = MyColor.green.backgoundColor
        greenBtn.setTitleColor(MyColor.green.buttonColor, for: .normal)
        blueBtn.backgroundColor = MyColor.blue.backgoundColor
        blueBtn.setTitleColor(MyColor.blue.buttonColor, for: .normal)
        pinkBtn.backgroundColor = MyColor.pink.backgoundColor
        pinkBtn.setTitleColor(MyColor.pink.buttonColor, for: .normal)
        
    }
    
    func setupPressedBtnColor(num: Int64) {
        switch num {
        case 1:
            yellowBtn.backgroundColor = MyColor.yellow.buttonColor
            yellowBtn.setTitleColor(.white, for: .normal)
        case 2:
            greenBtn.backgroundColor = MyColor.green.buttonColor
            greenBtn.setTitleColor(.white, for: .normal)
        case 3:
            blueBtn.backgroundColor = MyColor.blue.buttonColor
            blueBtn.setTitleColor(.white, for: .normal)
        case 4:
            pinkBtn.backgroundColor = MyColor.pink.buttonColor
            pinkBtn.setTitleColor(.white, for: .normal)
        default :
            yellowBtn.backgroundColor = MyColor.yellow.buttonColor
            yellowBtn.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        
        if let item = self.item {
            
            item.content = mainTextView.text
            item.color = colorNum ?? 1
            dataManager.updateItem(updateItem: item){
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            let text = mainTextView.text
            dataManager.saveItem(itemText: text, colorInt: colorNum ?? 1) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension DetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Please input your text." {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Please input your text."
            textView.textColor = .lightGray
        }
    }
}
