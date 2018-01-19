//
//  FormulaCells.swift
//  My_App
//
//  Created by shiyuwudi on 16/2/24.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

import Foundation

protocol FormulaCellDelegate {
    func clickForMoreButtonClicked(cell:FormulaCell2)
}

class FormulaCell1: UITableViewCell,StandardCell {
    
    @IBOutlet weak var redBgView: UIView!
    @IBOutlet weak var formulaLabel: UILabel!
    
    override func awakeFromNib() {
        redBgView.layer.cornerRadius = 5
        redBgView.layer.masksToBounds = true
    }
    
    var model : FormulaModel? {
        didSet{
            formulaLabel.text = model?.formula
        }
    }
    
    static func cellHeight() -> CGFloat {
        return 88
    }
    
}

class FormulaCell2: UITableViewCell,StandardCell {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var button: UIButton!
    var delegate:FormulaCellDelegate?
    
    @IBAction func buttonClicked(sender: AnyObject) {
        if (delegate != nil) {
            delegate?.clickForMoreButtonClicked(self)
        }
    }
    
    var model : FormulaModel? {
        didSet{
            
            guard let type = model?.type, model = model else {
                return
            }
            
            switch type {
            case .a:
                label1.text = "数值A"
                label2.text = "= 截止该商品开奖时间点前最后50条全站参与记录"
                if model.showMore{
                    button.setTitle("点击收起", forState: .Normal)
                } else {
                    button.setTitle("点击展开", forState: .Normal)
                }
                label3.attributedText = NSAttributedString(fullStr: "= \(model.numberA)", attributedPart: model.numberA, attribute: [NSForegroundColorAttributeName: UIColor.formulaRed])
            case .b:
                label1.text = "数值B"
                label2.text = "= 最近一期中国福利彩票\"老时时彩\"的开奖结果"
                button.hidden = true
                let pending = "正在等待开奖..."
                if model.numberB == pending {
                    label3.text = pending
                    label3.textColor = UIColor.formulaRed
                } else {
                    label3.attributedText = NSAttributedString(fullStr: "= \(model.numberB) (第\(model.expect)期)", attributedPart: model.numberB, attribute: [NSForegroundColorAttributeName: UIColor.formulaRed])
                }
            default:
                break
            }
            
        }
    }
    
    static func cellHeight() -> CGFloat {
        return 82
    }
    
}

class FormulaCell3: UITableViewCell,StandardCell {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    var model : CloudWinnerRecord? {
        didSet{
            if let stamp = model!.payTimeStamp {
                let redT = "→" + stamp
                let attr = [NSForegroundColorAttributeName:UIColor.formulaRed]
                let str = NSAttributedString(fullStr: model!.payTime + redT, attributedPart: redT, attribute: attr)
                label1.attributedText = str
                label2.text = model!.user_name
            } else {
                //表头
                label1.text = model!.payTime
                label2.text = model!.user_name
            }
            
            
        }
    }
    
    static func cellHeight() -> CGFloat {
        return 44
    }
    
    static func cellHeightWithModel(model:CloudWinnerRecord, index:Int) -> CGFloat {
        
        let ratio = 0.3 as CGFloat
        let margin = 8.0 as CGFloat
        let w = (screenW - 2 * margin) / (1 + ratio) * ratio
        
        let name = model.user_name as NSString
        let font = UIFont.systemFontOfSize(11.0)
        let attr = [NSFontAttributeName:font]
        let size = name.boundingRectWithSize(CGSize(width: w, height: CGFloat.max), options: .UsesLineFragmentOrigin, attributes: attr, context: nil)
        let h = size.height + 8
        return h
    }
    
}

class FormulaCell4: UITableViewCell,StandardCell {
    
    @IBOutlet weak var label: UILabel!
    
    var model: FormulaModel? {
        didSet {
            let attr = [NSForegroundColorAttributeName:UIColor.formulaRed]
            let str = NSAttributedString(fullStr: "幸运号码：" + model!.bingoNumber, attributedPart: model!.bingoNumber, attribute: attr)
            self.label.attributedText = str
        }
    }
    
    static func cellHeight() -> CGFloat {
        return 57
    }
    
}

extension UIColor {
    static var formulaRed : UIColor { return UIColor(red: 219.0/255.0, green: 55.0/255.0, blue: 82.0/255.0, alpha: 1.0) }
}