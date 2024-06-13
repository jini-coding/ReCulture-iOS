//
//  CustomCalendarView.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/3/24.
//

import UIKit

class CustomCollectionView: UICollectionView {
    override public func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return contentSize
    }
}

class CustomCalendarView: UIView {
    
    // MARK: - Properties
    
    weak var parentVC: HomeVC?
    private let minimumInterItemSpacing:CGFloat = 12
    private let minimumLineSpacing:CGFloat = 20
    private let now = Date()
    private var calendar = Calendar(identifier: .gregorian)  // 현재 사용자가 사용 중인 달력 (ex. gregorian)
    var currentDateComponents = DateComponents()
    private var daysInMonth = 0  // 해당 월이 며칠까지 있는지
    private let dateFormatter = DateFormatter()
    private var weekdayAdding = 0
    private var days: [String] = []
    private let weeks = ["일", "월", "화", "수", "목", "금", "토"]
    
   private var recordCountList = Array(repeating: 0, count: 50) {
        didSet{
            print("recordCountList didset!")
            DispatchQueue.main.async {
                self.calendarCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - Views
    
    private let yearAndMonthLabel: UILabel = {
        let label = UILabel()
        label.font = .rcFont18M()
        label.text = "2024.04"
        return label
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.chevronLeft, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(prevButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.chevronRight, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var calendarCollectionView: CustomCollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumLineSpacing = minimumLineSpacing
        flowlayout.minimumInteritemSpacing = minimumInterItemSpacing
        
        let view = CustomCollectionView(frame: .zero, collectionViewLayout: flowlayout)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        view.register(CalendarDateCell.self, forCellWithReuseIdentifier: CalendarDateCell.identifier)
        return view
    }()
    
    private let dummyView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initCalendar()
//        viewModel.getMyCalendar(year: "2024", month: "6", fromCurrentVC: parentVC!)

        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.rcGray000.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 22
        
        setYearAndMonthLabel()
        setChevronButtons()
        setCalendarCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setYearAndMonthLabel(){
        yearAndMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(yearAndMonthLabel)
        
        NSLayoutConstraint.activate([
            yearAndMonthLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            yearAndMonthLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24)
        ])
    }
    
    private func setChevronButtons(){
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(previousButton)
        addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            previousButton.trailingAnchor.constraint(equalTo: yearAndMonthLabel.leadingAnchor, constant: -8),
            previousButton.centerYAnchor.constraint(equalTo: yearAndMonthLabel.centerYAnchor),
            previousButton.widthAnchor.constraint(equalToConstant: 22),
            previousButton.heightAnchor.constraint(equalToConstant: 22),
            nextButton.leadingAnchor.constraint(equalTo: yearAndMonthLabel.trailingAnchor, constant: 8),
            nextButton.centerYAnchor.constraint(equalTo: yearAndMonthLabel.centerYAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 22),
            nextButton.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    private func setCalendarCollectionView(){
        calendarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(calendarCollectionView)
        
        NSLayoutConstraint.activate([
            calendarCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 27),
            calendarCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -27),
            calendarCollectionView.topAnchor.constraint(equalTo: yearAndMonthLabel.bottomAnchor, constant: 24),
            calendarCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32),
        ])
    }
    
    // MARK: - Actions
    
    @objc func prevButtonTapped(){
        currentDateComponents.month = currentDateComponents.month! - 1
        self.calculateCalendar()
        self.calendarCollectionView.reloadData()
        //parentVC?.setCalendarMonthTo(currentDateComponents.month!)
    }
    
    @objc func nextButtonTapped(){
        currentDateComponents.month = currentDateComponents.month! + 1
        self.calculateCalendar()
        self.calendarCollectionView.reloadData()
        //parentVC?.setCalendarMonthTo(currentDateComponents.month!)
    }
    
    // MARK: - Helpers
    
    private func initCalendarCollectionView(){
        calendarCollectionView.register(CalendarDateCell.self, forCellWithReuseIdentifier: CalendarDateCell.identifier)
    }
    
    private func initCalendar(){
        dateFormatter.dateFormat = "yyyy.MM"  // 달력 위에서 보여줄 년, 월 포맷 설정
        currentDateComponents.year = calendar.component(.year, from: now)  // 현재의 년도 리턴
        currentDateComponents.month = calendar.component(.month, from: now)  // 현재의 월 리턴
        currentDateComponents.day = 1  // 날짜는 1로 초기화
        calculateCalendar()
    }
    
    private func calculateCalendar(){
        print("== current date components ==")
        print(currentDateComponents)
        print(currentDateComponents.day)
        let firstDayOfMonth = calendar.date(from: currentDateComponents)
        print(firstDayOfMonth!)
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth!) // 해당 수로 반환이 됩니다. 1은 일요일 ~ 7은 토요일
        print("== 이번 달의 첫번째 요일 ==")
        print(firstWeekday)
        daysInMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
        
        // 컬렉션 뷰에서 셀을 그릴 때 1일부터 그릴 수 있도록 그 앞에는 빈 값을 넣어주기 위함
        weekdayAdding = 2 - firstWeekday  // ex. 화요일부터 달의 시작인 경우 -> 2 - 3 = -1 -> -1, 0 동안은 빈 값, 1부터 실제 값을 넣게 됨
        let dateFormatterString = dateFormatter.string(from: firstDayOfMonth!)
        self.yearAndMonthLabel.text = dateFormatterString.replacingOccurrences(of: ".", with: "년 ") + "월"
        parentVC?.setCalendarMonthTo(Int(dateFormatterString.components(separatedBy: ".")[1])!)
        self.days.removeAll()

        for day in weekdayAdding...daysInMonth {
            if day < 1 { // 1보다 작을 경우는 비워줘야 하기 때문에 빈 값을 넣어준다.
                self.days.append("")
            } else {
                self.days.append(String(day))
            }
        }
    }
    
    func updateCollectionViewHeight() {
        calendarCollectionView.constraints[0].identifier
        calendarCollectionView.heightAnchor.constraint(equalToConstant: calendarCollectionView.collectionViewLayout.collectionViewContentSize.height).isActive = true
        calendarCollectionView.layoutIfNeeded()
    }
    
    func setRecordCountList(_ dict: [Int: Int]?) {
        print("set record count list")
        if let dict = dict {
            dict.keys.forEach { key in
                print("=== dict key ===")
                print(key)
                print(dict[key])
                recordCountList[key] = dict[key]!
            }
        }
        print("record count list")
        print(recordCountList)
    }
}

// MARK: - Extension; CollectionView
extension CustomCalendarView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 7 // 맨 위에 나오는 요일을 보여주는 섹션은 7로 고정
        default:
            return self.days.count // 일의 수
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarDateCell.identifier, for: indexPath) as? CalendarDateCell else { return UICollectionViewCell() }
        
        let row = indexPath.row
        print("row:\(row)")
        switch indexPath.section {
        case 0:
            cell.configure(section: 0, dateOrDay: weeks[indexPath.row])  // 요일 세팅
        default:
            cell.configure(section: 1, dateOrDay: days[row], recordCount: recordCountList[Int(days[row]) ?? 0])  // 일
        }
        
        return cell
    }
}

extension CustomCalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let mainBoundWidth: CGFloat = UIScreen.main.bounds.size.width
        let cellSize : CGFloat = (mainBoundWidth - 32 - 54 - minimumInterItemSpacing*6) / 7
        return CGSize(width: cellSize, height: cellSize)
    }
}
