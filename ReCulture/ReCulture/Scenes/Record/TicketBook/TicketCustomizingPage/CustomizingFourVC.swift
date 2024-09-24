//
//  CustomizingFourVC.swift
//  ReCulture
//
//  Created by Jini on 6/2/24.
//

import UIKit

class CustomizingFourVC: UIViewController {
    weak var ticketCustomizingVC: TicketCustomizingVC?

    let guideLabel: UILabel = {
        let label = UILabel()
        label.text = "이대로 티켓을 완성할까요?"
        label.font = UIFont.rcFont24B()
        label.numberOfLines = 0
        return label
    }()
    
    private let lineView1: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ticketLine")
        return view
    }()
    
    private let lineView2: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ticketLine")
        return view
    }()
    
    private let ticketTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .rcFont20B()
        label.text = "title"
        return label
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .rcFont36B()
        label.text = "emoji"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .rcGray400
        label.text = "date"
        label.font = .rcFont16B()
        return label
    }()
    
    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.font = .rcFont14SB()
        label.numberOfLines = 0
        return label
    }()
    
    private let barcodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "barcode")
        return imageView
    }()
    
    private let ticketImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        view.isOpaque = true
        return view
    }()
    
    private let detailContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    let ticketFrameImage: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds = true
        imageview.isUserInteractionEnabled = true
        return imageview
    }()
    
    let selectedImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.alpha = 1.0
        view.clipsToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        setupGuide()
        setTicketImageView()
        setDetailView()
        //setupImage()
        //applyImageData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Reapply the mask after layout to ensure correct bounds
        applyImageMask()
    }
    
    func setupGuide() {
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(guideLabel)
      
        NSLayoutConstraint.activate([
            guideLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 6),
            guideLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            guideLabel.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
    func setTicketImageView() {
        ticketImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(ticketImageView)
        
        ticketImageView.backgroundColor = UIColor.rcGray200
        ticketImageView.image = ticketCustomizingVC?.selectedUserImage
        ticketImageView.alpha = 0.4
        
        NSLayoutConstraint.activate([
            ticketImageView.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 20),
            ticketImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 60),
            ticketImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -60),
            ticketImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            ticketImageView.heightAnchor.constraint(equalToConstant: 480)
        ])
    }
    
    private func setDetailView(){
        detailContentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(detailContentView)
        //detailContentView.addSubview(detailStackView)
        
        //detailContentView.isHidden = true
        detailContentView.backgroundColor = .clear
        
        detailContentView.addSubview(emojiLabel)
        detailContentView.addSubview(ticketTitleLabel)
        detailContentView.addSubview(dateLabel)
        detailContentView.addSubview(reviewLabel)
        detailContentView.addSubview(barcodeImageView)
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        ticketTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewLabel.translatesAutoresizingMaskIntoConstraints = false
        barcodeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        lineView1.translatesAutoresizingMaskIntoConstraints = false
        lineView2.translatesAutoresizingMaskIntoConstraints = false
        detailContentView.addSubview(lineView1)
        detailContentView.addSubview(lineView2)
        
        emojiLabel.text = ticketCustomizingVC?.emojiText
        ticketTitleLabel.text = ticketCustomizingVC?.titleText
        dateLabel.text = ticketCustomizingVC?.dateText
        reviewLabel.text = ticketCustomizingVC?.commentText
        
        NSLayoutConstraint.activate([
            detailContentView.topAnchor.constraint(equalTo: ticketImageView.topAnchor),
            detailContentView.leadingAnchor.constraint(equalTo: ticketImageView.leadingAnchor),
            detailContentView.trailingAnchor.constraint(equalTo: ticketImageView.trailingAnchor),
            detailContentView.bottomAnchor.constraint(equalTo: ticketImageView.bottomAnchor),
        ])
        
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        ticketFrameImage.addSubview(selectedImageView)

        NSLayoutConstraint.activate([
            lineView1.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor, constant: 26),
            lineView1.trailingAnchor.constraint(equalTo: detailContentView.trailingAnchor, constant: -26),
            lineView1.topAnchor.constraint(equalTo: detailContentView.topAnchor, constant: 65),
            lineView1.heightAnchor.constraint(equalToConstant: 2),

            // Ticket Title Label
            ticketTitleLabel.topAnchor.constraint(equalTo: lineView1.bottomAnchor, constant: 26),
            ticketTitleLabel.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor, constant: 28),
            ticketTitleLabel.heightAnchor.constraint(equalToConstant: 24),
            
            lineView2.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor, constant: 26),
            lineView2.trailingAnchor.constraint(equalTo: detailContentView.trailingAnchor, constant: -26),
            lineView2.topAnchor.constraint(equalTo: ticketTitleLabel.bottomAnchor, constant: 26),
            lineView2.heightAnchor.constraint(equalToConstant: 2),
            
            // Date Label
            dateLabel.topAnchor.constraint(equalTo: lineView2.bottomAnchor, constant: 14),
            dateLabel.trailingAnchor.constraint(equalTo: detailContentView.trailingAnchor, constant: -28),
            dateLabel.heightAnchor.constraint(equalToConstant: 22),
            
            // Review Label
            reviewLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 14),
            reviewLabel.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor, constant: 26),
            reviewLabel.trailingAnchor.constraint(equalTo: detailContentView.trailingAnchor, constant: -26),
            
            emojiLabel.bottomAnchor.constraint(equalTo: barcodeImageView.topAnchor, constant: -14),
            emojiLabel.trailingAnchor.constraint(equalTo: detailContentView.trailingAnchor, constant: -22),
            emojiLabel.heightAnchor.constraint(equalToConstant: 30),
            
            // Barcode Image View
            barcodeImageView.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor, constant: 20),
            barcodeImageView.trailingAnchor.constraint(equalTo: detailContentView.trailingAnchor, constant: -20),
            barcodeImageView.bottomAnchor.constraint(equalTo: detailContentView.bottomAnchor, constant: -65),
            barcodeImageView.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
//    func setupImage() {
//        ticketFrameImage.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(ticketFrameImage)
//        
//        NSLayoutConstraint.activate([
//            ticketFrameImage.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 20),
//            ticketFrameImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            ticketFrameImage.heightAnchor.constraint(equalToConstant: 480),
//            ticketFrameImage.widthAnchor.constraint(equalToConstant: 280)
//        ])
//        
//        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
//        ticketFrameImage.addSubview(selectedImageView)
//
//        NSLayoutConstraint.activate([
//            selectedImageView.topAnchor.constraint(equalTo: ticketFrameImage.topAnchor),
//            selectedImageView.bottomAnchor.constraint(equalTo: ticketFrameImage.bottomAnchor),
//            selectedImageView.leadingAnchor.constraint(equalTo: ticketFrameImage.leadingAnchor),
//            selectedImageView.trailingAnchor.constraint(equalTo: ticketFrameImage.trailingAnchor)
//        ])
//    }
    
    func applyImageMask() {
        guard let selectedFrame = ticketCustomizingVC?.selectedFrame else { return }
        guard let maskImage = UIImage(named: "frame\(selectedFrame)")?.cgImage else { return }
        
        let maskLayer = CALayer()
        maskLayer.contents = maskImage
        maskLayer.frame = ticketImageView.bounds
        
        ticketImageView.layer.mask = maskLayer
        ticketImageView.layer.masksToBounds = true
    }
}
