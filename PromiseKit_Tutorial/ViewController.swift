//
//  ViewController.swift
//  promiseKit_tutorial_test
//
//  Created by Jeff Jeong on 2021/02/07.
//

import UIKit


enum MyError : Error {
    case iHateLaundary, iHateCleanMyRoom
}


class ViewController: UIViewController {

    
    @IBOutlet var firstBtn: UIButton!
    @IBOutlet var secondBtn: UIButton!
    @IBOutlet var thirdBtn: UIButton!
    @IBOutlet var fourBtn: UIButton!
    @IBOutlet var fiveBtn: UIButton!
    @IBOutlet var sixBtn: UIButton!
    @IBOutlet var showIndicatorBtn: UIButton!
    @IBOutlet var btns : [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btns.forEach{ $0.addTarget(self, action: #selector(onBtnClicked(_:)), for: .touchUpInside) }
    }
    
    
    @objc fileprivate func onBtnClicked(_ sender: UIButton){
        switch sender {
        case firstBtn:
            print("첫번째 버튼 클릭")
            doHeavyWorkWithReturn("장보기", duration: 1.0, completion: { result in
                self.showAlert(vc: self, title: result)
            })
        case secondBtn:
            print("두번째 버튼 클릭")
            doHeavyWorkWithReturn("장보기", duration: 1.0, completion: { result in
                self.doHeavyWorkWithReturn("\(result) 하고 저녁요리하기", duration: 1.0, completion: { result in
                    self.showAlert(vc: self, title: result)
                })
            })
        case thirdBtn:
            print("세번째 버튼 클릭")
            doHeavyWorkWithReturn("장보기", duration: 1.0, completion: { result in
                self.doHeavyWorkWithReturn("\(result) 하고 저녁요리하기", duration: 1.0, completion: { result in
                    self.doHeavyWorkWithReturn("\(result) 하고 설거지하기", duration: 1.0, completion: { result in
                        self.showAlert(vc: self, title: result)
                    })
                })
            })
        case fourBtn:
            print("네번째 버튼 클릭")
            doLaundary()
        case fiveBtn:
            print("다섯번째 버튼 클릭")
            goShopping()
        case sixBtn:
            print("여섯번째 버튼 클릭")
            goPicnic()
        case showIndicatorBtn:
            doSomethingWithLoading()
        default:
            break
        }
    }

    
    fileprivate func doSomethingWithLoading(){
        self.showLoading()
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in
            print("완료")
            self.hideLoading()
        })
    }
    
    
    fileprivate func doHeavyWork(_ jobTitle: String, duration: Float, completion: (() -> Void)? = nil){
        print("jobTitle: \(jobTitle) 시작")
        Timer.scheduledTimer(withTimeInterval: TimeInterval(duration), repeats: false, block: { _ in
            print("jobTitle: \(jobTitle) 끝")
            completion?()
        })
    }
    
    fileprivate func doHeavyWorkWithReturn(_ jobTitle: String, duration: Float, completion: ((String) -> Void)? = nil){
        print("jobTitle: \(jobTitle) 시작")
        Timer.scheduledTimer(withTimeInterval: TimeInterval(duration), repeats: false, block: { _ in
            print("\(jobTitle) 완료")
            completion?("\(jobTitle) 완료")
        })
    }
    
    fileprivate func doLaundary(){
        print("doLaundary() called")
    }
    
    fileprivate func goShopping(){
        print("goShopping() called")
    }
    
    fileprivate func goPicnic(){
        print("goPicnic() called")
    }
    
    
    fileprivate func showAlert(vc: UIViewController, title: String,  completion: (() -> Void)? = nil ) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            completion?()
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
    
    
}

