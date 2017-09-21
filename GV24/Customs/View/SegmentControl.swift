//
//  SegmentControl.swift
//

import Foundation
import UIKit



// MARK: - Appearance

public struct SegmentedControlAppearance {
    public var backgroundColor: UIColor
    public var selectedBackgroundColor: UIColor
    public var textColor: UIColor
    public var font: UIFont
    public var selectedTextColor: UIColor
    public var selectedFont: UIFont
    public var bottomLineColor: UIColor
    public var selectorColor: UIColor
    public var bottomLineHeight: CGFloat
    public var selectorHeight: CGFloat
    public var labelTopPadding: CGFloat
}

// MARK: - Control Item

typealias SegmentedControlItemAction = (_ item: SegmentedControlItem) -> Void

class SegmentedControlItem: UIControl {
    // MARK: Properties
    
    private var willPress: SegmentedControlItemAction?
    private var didPress: SegmentedControlItemAction?
    var label: UILabel!
    
    // MARK: Init
    
    init(frame: CGRect,
         text: String,
         appearance: SegmentedControlAppearance,
         willPress: SegmentedControlItemAction?,
         didPress: SegmentedControlItemAction?) {
        super.init(frame: frame)
        self.willPress = willPress
        self.didPress = didPress
        
        commonInit()
        label.textColor = appearance.textColor
        label.font = appearance.font
        label.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init (coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        let views: [String: Any] = ["label": label]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: views))
    }
    
    // MARK: Events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        willPress?(self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        didPress?(self)
    }
}


// MARK: - Control

public protocol SegmentedControlDelegate: class {
    func segmentedControl(_ segmentedControl: SegmentedControl, willPressItemAt index: Int)
    func segmentedControl(_ segmentedControl: SegmentedControl, didPressItemAt index: Int)
}

public typealias SegmentedControlAction = (_ segmentedControl: SegmentedControl, _ index: Int) -> Void

public class SegmentedControl: UIView {
    
    // MARK: Properties
    
    weak var delegate: SegmentedControlDelegate?
    public var action: SegmentedControlAction?
    
    public var appearance: SegmentedControlAppearance! {
        didSet {
            self.draw()
        }
    }
    
    public var titles: [String]! {
        didSet {
            if appearance == nil {
                defaultAppearance()
            }
            else {            }
        }
    }
    
    var items = [SegmentedControlItem]()
    var selector = UIView()
    var bottomLine = CALayer()
    
    // MARK: Init

    public init (frame: CGRect, titles: [String], action: SegmentedControlAction? = nil) {
        super.init (frame: frame)
        self.action = action
        self.titles = titles
        defaultAppearance()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name(rawValue: "LCLLanguageChangeNotification"), object: nil)
    }
    
    required public init? (coder aDecoder: NSCoder) {
        super.init (coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateUI() {
        print("SegmentController.updateUI be called!")
        for i in 0..<items.count {
            let item = items[i]
            let title = titles[i]
            item.label.text = title.localize
        }
        
    }
    
    // MARK: Draw
    
    private func reset() {
        for sub in subviews {
            let v = sub
            v.removeFromSuperview()
        }
        
        items.removeAll()
    }

    private func draw() {
        reset()
        backgroundColor = AppColor.white
        for title in titles {
            let item = SegmentedControlItem(
                frame: .zero,
                text: title.localize,
                appearance: appearance,
                willPress: { [weak self] segmentedControlItem in
                    guard let weakSelf = self else {
                        return
                    }
                    
                    let index = weakSelf.items.index(of: segmentedControlItem)!
                    weakSelf.delegate?.segmentedControl(weakSelf, willPressItemAt: index)
                },
                didPress: { [weak self] segmentedControlItem in
                    guard let weakSelf = self else {
                        return
                    }
                    
                    let index = weakSelf.items.index(of: segmentedControlItem)!
                    weakSelf.selectItem(at: index, withAnimation: true)
                    weakSelf.action?(weakSelf, index)
                    weakSelf.delegate?.segmentedControl(weakSelf, didPressItemAt: index)
            })
            addSubview(item)
            items.append(item)
        }
        // bottom line
        bottomLine.backgroundColor = appearance.bottomLineColor.cgColor
        layer.addSublayer(bottomLine)
        // selector
        selector.backgroundColor = appearance.selectorColor
        addSubview(selector)
        
        selectItem(at: 0, withAnimation: true)
        
        setNeedsLayout()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = frame.size.width / CGFloat(titles.count)
        var currentX: CGFloat = 0
        
        for item in items {
            item.frame = CGRect(
                x: currentX,
                y: appearance.labelTopPadding,
                width: width,
                height: frame.size.height - appearance.labelTopPadding)
            currentX += width
        }
        
        bottomLine.frame = CGRect(
            x: 0,
            y: frame.size.height - appearance.bottomLineHeight,
            width: frame.size.width,
            height: 0)
        
        selector.frame = CGRect (
            x: selector.frame.origin.x,
            y: frame.size.height - appearance.selectorHeight,
            width: width,
            height: 0)
    }
    
    private func defaultAppearance() {
        appearance = SegmentedControlAppearance(
            backgroundColor: AppColor.white,
            selectedBackgroundColor: AppColor.backButton,
            textColor: AppColor.backButton,
            font: fontSize.fontName(name: .bold, size: 13),
            selectedTextColor: AppColor.white,
            selectedFont: fontSize.fontName(name: .bold, size: 13),
            bottomLineColor: .clear,
            selectorColor:  AppColor.backButton,
            bottomLineHeight: 0,
            selectorHeight: 2,
            labelTopPadding: 0)
    }
    
    // MARK: Select
    
    public func selectItem(at index: Int, withAnimation animation: Bool) {
        moveSelector(at: index, withAnimation: animation)
        for item in items {
            if item == items[index] {
                item.label.textColor = appearance.selectedTextColor
                item.label.font = appearance.selectedFont
                item.backgroundColor = appearance.selectedBackgroundColor
            } else {
                item.label.textColor = appearance.textColor
                item.label.font = appearance.font
                item.backgroundColor = appearance.backgroundColor
            }
        }
    }
    
    private func moveSelector(at index: Int, withAnimation animation: Bool) {
        let width = frame.size.width / CGFloat(items.count)
        let target = width * CGFloat(index)
        UIView.animate(withDuration: animation ? 0.3 : 0,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        [unowned self] in
                        self.selector.frame.origin.x = target
                        self.layoutIfNeeded()
            },
                       completion: nil)
    }
}
