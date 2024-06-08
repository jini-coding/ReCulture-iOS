//
//  TicketCustomizingVC.swift
//  ReCulture
//
//  Created by Jini on 5/29/24.
//

import UIKit

class TicketCustomizingVC: UIViewController {
    
    var pageViewController: UIPageViewController!
    var pages: [UIViewController] = []
    
    let pageControl = UIPageControl()
    let nextBtn = UIButton()
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupNavigationBar()
        setupPages()
        setupPageViewController()
        setupButton()
        setupPageControl()
    }
    
    func setupPages() {
        pages = [CustomizingOneVC(), CustomizingTwoVC(), CustomizingThreeVC(), CustomizingFourVC()]
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "티켓 커스터마이징"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)]
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let initialPage = 0
        pageViewController.setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
        self.addChild(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        // Auto Layout 설정
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120) // pageControl 높이를 고려
        ])
    }
    
    func setupPageControl() {
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.rcMain
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 8)
        ])
    }
    
    func setupButton() {
        nextBtn.backgroundColor = UIColor.rcMain
        nextBtn.setTitle("다음", for: .normal)
        nextBtn.setTitleColor(UIColor.white, for: .normal)
        nextBtn.titleLabel?.font = UIFont.rcFont18B()
        nextBtn.layer.cornerRadius = 12
        
        nextBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextBtn)
        
        NSLayoutConstraint.activate([
            nextBtn.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nextBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nextBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            nextBtn.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        nextBtn.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
            
    }
    
    @objc func nextButtonPressed() {
        let currentPage = pageControl.currentPage
        let nextPage = currentPage + 1
        
        if nextPage < pages.count {
            pageViewController.setViewControllers([pages[nextPage]], direction: .forward, animated: true, completion: { completed in
                if completed {
                    self.pageControl.currentPage = nextPage
                    self.updateButtonTitle(for: nextPage)
                }
            })
        } else if nextPage == pages.count {
            confirmButtonTapped()
        }
    }
     
    @objc func pageControlTapped(_ sender: UIPageControl) {
        let currentPage = pageViewController.viewControllers?.first.flatMap { pages.firstIndex(of: $0) } ?? 0
        let direction: UIPageViewController.NavigationDirection = sender.currentPage > currentPage ? .forward : .reverse
        pageViewController.setViewControllers([pages[sender.currentPage]], direction: direction, animated: true, completion: { completed in
            if completed {
                self.updateButtonTitle(for: sender.currentPage)
            }
        })
    }
    
    func updateButtonTitle(for pageIndex: Int) {
        if pageIndex == pages.count - 1 {
            nextBtn.setTitle("완성하기", for: .normal)
        } else {
            nextBtn.setTitle("다음", for: .normal)
        }
    }
    
    @objc func confirmButtonTapped() {
        presentCompleteModal()
    }
    
    func presentCompleteModal() {
        guard let tabBarController = tabBarController else { return }
        
        // Add the overlay view to the tab bar controller's view
        tabBarController.view.addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: tabBarController.view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: tabBarController.view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: tabBarController.view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: tabBarController.view.bottomAnchor)
        ])
        
        let vc = CompleteCustomizingModal() // 로그아웃 완료 팝업 띄우기
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension TicketCustomizingVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // 앞으로 가는 것 막음
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else {
            return nil
        }
        return nil
    }
}

extension TicketCustomizingVC: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = pageViewController.viewControllers?.first, let index = pages.firstIndex(of: visibleViewController) {
            pageControl.currentPage = index
            updateButtonTitle(for: index)
        }
    }
}
