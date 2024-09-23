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

//        NSLayoutConstraint.activate([
//            guideLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 6),
//            guideLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            guideLabel.heightAnchor.constraint(equalToConstant: 72)
//        ])
        
        NSLayoutConstraint.activate([
            guideLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            guideLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            guideLabel.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
    func setupImage() {
        ticketFrameImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ticketFrameImage)
        
        NSLayoutConstraint.activate([
            ticketFrameImage.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 20),
            ticketFrameImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ticketFrameImage.heightAnchor.constraint(equalToConstant: 480),
            ticketFrameImage.widthAnchor.constraint(equalToConstant: 280)
        ])
        
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        ticketFrameImage.addSubview(selectedImageView)

        NSLayoutConstraint.activate([
            selectedImageView.topAnchor.constraint(equalTo: ticketFrameImage.topAnchor),
            selectedImageView.bottomAnchor.constraint(equalTo: ticketFrameImage.bottomAnchor),
            selectedImageView.leadingAnchor.constraint(equalTo: ticketFrameImage.leadingAnchor),
            selectedImageView.trailingAnchor.constraint(equalTo: ticketFrameImage.trailingAnchor)
        ])
    }
    
    func applyImageData() {
        // Apply the passed frame and masked image
        print("Selected Frame in FourVC: \(String(describing: ticketCustomizingVC?.selectedFrame))")
        print("Selected Masked Image in FourVC: \(String(describing: ticketCustomizingVC?.selectedMaskedUserImage))")

        // Apply the selected frame image
//        if let selectedFrame = ticketCustomizingVC?.selectedFrame {
//            ticketFrameImage.image = UIImage(named: "frame\(selectedFrame)")
//        }

        
        if let maskedImage = ticketCustomizingVC?.selectedMaskedUserImage {
            selectedImageView.image = maskedImage // Set the masked image
            print("Masked image applied in FourVC")
        } else {
            print("Masked image is nil in FourVC")
        }
    }
    
    func applyImageMask() {
        // Ensure that the selected image mask is properly set after layout
        applyImageData()
    }
}
