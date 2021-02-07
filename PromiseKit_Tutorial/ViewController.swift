//
//  ViewController.swift
//  promiseKit_tutorial_test
//
//  Created by Jeff Jeong on 2021/02/07.
//

import UIKit
import PromiseKit

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
    
    fileprivate func doHeavyWorkWithReturn(_ jobTitle: String, duration: Float) -> Promise<String>{
        print("jobTitle: \(jobTitle) 시작")
        return Promise { seal in
            Timer.scheduledTimer(withTimeInterval: TimeInterval(duration), repeats: false, block: { _ in
                print("\(jobTitle) 완료")
                switch jobTitle {
                case "빨래하기":
                    seal.reject(MyError.iHateLaundary)
                case "내방청소":
                    seal.reject(MyError.iHateCleanMyRoom)
                default:
                    seal.fulfill("\(jobTitle) 완료")
                }
            })
        }
    }
    
    
    fileprivate func doLaundary(){
        print("doLaundary() called")
        firstly{
            doHeavyWorkWithReturn("손빨래하기", duration: 1.0)
        }.then{ result in
            self.doHeavyWorkWithReturn("내방청소", duration: 1.0)
        }.then{ result in
            self.doHeavyWorkWithReturn("\(result) 하고 설거지", duration: 1.0)
        }.done{ result in
            self.showAlert(vc: self, title: result)
        }.catch{ error in
            print("에러가 발생하였다! / error: \(error)")
        }
    }
    
    fileprivate func goShopping(){
        print("goShopping() called")
        
        firstly{
            when(fulfilled: doHeavyWorkWithReturn("청소하기", duration: 1.0),
                doHeavyWorkWithReturn("손빨래하기", duration: 1.0),
                doHeavyWorkWithReturn("빨래건조하기", duration: 1.0))
        }.done{ first, second, third in
            self.showAlert(vc: self, title: "\(first), \(second), \(third) 모두 완료!")
        }.catch{ error in
            print("에러가 발생하였다! / error: \(error)")
        }
    }
    
    fileprivate func goPicnic(){
        print("goPicnic() called")
        firstly{
            self.doHeavyWorkWithReturn("내방청소", duration: 1.0)
        }
        .then { result in
            when(fulfilled: self.doHeavyWorkWithReturn("창고청소하기", duration: 1.0),
                 self.doHeavyWorkWithReturn("손빨래하기", duration: 1.0),
                 self.doHeavyWorkWithReturn("빨래건조하기", duration: 1.0))
        }
        .map{ first, second, third in
            return "완료한 것들: \(first), \(second), \(third)"
        }
        .recover{ error -> Promise<String> in
            guard error as! MyError == MyError.iHateCleanMyRoom else {
                throw error
            }
            return after(seconds: 2.0).then{
                self.doHeavyWorkWithReturn("내방청소하기 싫어도 해", duration: 1.0)
            }
        }
        .done{ result in
            self.showAlert(vc: self, title: "\(result) 모두 완료!")
        }
        .ensure {
            print("이것은 무조건 실행된다")
        }
        .catch{ error in
            print("에러가 발생하였다! / error: \(error)")
        }
        
        
    }
    
    
    fileprivate func showAlert(vc: UIViewController, title: String,  completion: (() -> Void)? = nil ) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            completion?()
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
    
    
}

