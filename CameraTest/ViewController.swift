//
//  ViewController.swift
//  CameraTest
//
//  Created by Semyon on 09.07.2020.
//  Copyright © 2020 Semyon. All rights reserved.
//


/*
 
 +++Отключить поворот экрана
 Исправить появление первого фото через CaptureControllerDelegate
 Фото аутпут
 ретина флеш
 просмотр фоток в swiftui
 
 */

import UIKit
import SwiftUI
import Combine
import AVFoundation

class CameraConstants {
    static let controllBarHeight: CGFloat = 161
}

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    // Интерфейс ожидания съемки
    var textLabelAwait:     UILabel!
    var activityView:       UIActivityIndicatorView!
    
    // Сессия съемки
    var cameraVisor:        UIView!
    var captureSession:     AVCaptureSession!
    var previewView:        PreviewView!
    var currentVideoInput:  AVCaptureDeviceInput!
    var currentDevice:      AVCaptureDevice!
    var capturePhotoOutput: AVCapturePhotoOutput!
    
    // Интерфейс съемки
    private var switchCamera:       AnyCancellable!
    private var switchFlashLight:   AnyCancellable!
    private var takeShoot:          AnyCancellable!
    var cameraHeader:               UIHostingController<CameraHeader>!
    var captureController:          UIHostingController<CaptureController>!
    var cameraHeaderDelegate:       CameraHeaderDelegate!
    var captureUIDelegate:          CaptureControllerDelegate!
    
    // константы
    var statusBarHeight: CGFloat!
    var safeAreaHeight:  CGFloat!
    var topSpace:        CGFloat!
    
    // Данные
    var takenPhotos:     [UIImage] = [UIImage(named: "1.jpg")!, UIImage(named: "2.jpg")!, UIImage(named: "3.jpg")!, UIImage(named: "1.jpg")!, UIImage(named: "2.jpg")!, UIImage(named: "3.jpg")!]
    
    // Папка с фотками
    var showFolderBlurCancellable: AnyCancellable!
    var showFolderBlur: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupBaseUI()
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.setupCaptureSession()
                } else {
                    DispatchQueue.main.async {
                        self.ifAccessDenied()
                    }
                }
            }
        case .denied:
            DispatchQueue.main.async {
                self.ifAccessDenied()
            }
        case .restricted:
            DispatchQueue.main.async {
                self.ifAccessDenied()
            }
        @unknown default:
            return
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let cameraVisor = self.cameraVisor else { return }
        // Инициализируем кастомный вид, отвечающий за вид из камеры
        self.previewView = PreviewView()
        cameraVisor.addSubview(self.previewView)
        self.statusBarHeight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        self.safeAreaHeight  = self.view.window?.safeAreaInsets.top ?? 0
        self.topSpace        = self.statusBarHeight + self.safeAreaHeight
        // Вычисляем отступ сверху для позиционирования "от края"
        self.previewView.frame = CGRect(x: 0, y: -topSpace, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        // Присваиваем сессию записи к view, привязанного к главному ребенку контроллера
        // При изменении параметров сессии, может понадоюбится перезагрузка
        // ?
        // ?
        // ?
        
        self.previewView.videoPreviewLayer.session = captureSession
        self.captureSession.startRunning()
        
        // Если все успешно, удаляем UI загрузки
        if self.activityView != nil {
            self.activityView.stopAnimating()
            self.activityView.removeFromSuperview()
        }
        if self.textLabelAwait != nil {
            self.textLabelAwait.removeFromSuperview()
        }
        // И добавляем UI для фото/видео
        self.createCaptureUI()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print(error?.localizedDescription ?? "Ошибка во время исполнения кода при создании фотографии")
            return
        }
        guard let imageData = photo.fileDataRepresentation() else {
            print("Невозможно получить данные об изображении")
            return
        }
        if let image = UIImage(data: imageData) {
            if self.cameraHeader != nil {
                self.cameraHeader.rootView.setPhotoToShow(photo: image)
            }
        } else {
            print("Невозможно преобразовать")
        }
    }
    
    private func createCaptureUI() {
        // Функция, обеспечивающая пользовательский
        // интерфейс взаимодействия с камерой
        captureUIDelegate = CaptureControllerDelegate()
        captureController = UIHostingController(rootView: CaptureController(delegate: captureUIDelegate, parent: self))
        let controllerHeight = CameraConstants.controllBarHeight
        let controllerWidth = UIScreen.main.bounds.size.width
        let controllerXPos = 0
        let controllerYPos = UIScreen.main.bounds.size.height - CGFloat(controllerHeight)
        captureController.view.frame = CGRect(x: CGFloat(controllerXPos), y: controllerYPos, width: controllerWidth, height: CGFloat(controllerHeight))
        addChild(captureController)
        self.cameraVisor.addSubview(captureController.view)
        captureController.didMove(toParent: self)
        
        // Определяем стек фоток и
        // кнопку для возвращения назад с помощью SwiftUI
        cameraHeaderDelegate = CameraHeaderDelegate(newPhoto: nil)
        cameraHeader   = UIHostingController(rootView: CameraHeader(delegate: cameraHeaderDelegate, image: "chevron.left", text: "Назад", parent: self))
        cameraHeader.view.backgroundColor = .clear
        let headerXPos: CGFloat = 0
        let headerYPos: CGFloat = 0
        let headerWidth: CGFloat = UIScreen.main.bounds.size.width
        let headerHeight: CGFloat = UIScreen.main.bounds.size.height// - CameraConstants.controllBarHeight
        
        cameraHeader.view.frame = CGRect(x: headerXPos, y: headerYPos, width: headerWidth, height: headerHeight)
        
        addChild(cameraHeader)
        
        self.cameraVisor.addSubview(cameraHeader.view)
        cameraHeader.didMove(toParent: self)
        
//        self.showFolderBlurCancellable = captureUIDelegate.$showFolderBlur.sink { showFolder in
//            self.showFolderBlur = showFolder
//            self.toggleFolderBlur()
//        }
//        self.switchFlashLight = captureUIDelegate.$flashLight.sink { value in
//            self.switchFlash(value)
//        }
    }
    
//    func toggleFolderBlur() {
//        if self.showFolderBlur == false {
//            self.cameraHeader.rootView.toggleFolder()
//        }
//    }
    
    func takePhoto() {
        self.disableTakePhotoButton()
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoRedEyeReductionEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @objc func switchCameraInput(_ sender: UIButton? = nil) {
        guard let captureSession = self.captureSession else { return }
        // Начинаем конфигурацию
        self.captureSession.beginConfiguration()
        
        // Удаляем старый ресурс
        if !captureSession.inputs.isEmpty {
            self.captureSession.removeInput(self.currentVideoInput)
        }
        
        // Выбираем камеру для захвата картинки
        if self.currentDevice != nil {
            if self.currentDevice.position == .back {
                self.currentDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            } else if self.currentDevice.position == .front {
                self.currentDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            }
        }
        
        // Передаем данные с утройств на вход виду из камеры
        guard let tmpInput = try? AVCaptureDeviceInput(device: self.currentDevice!) else {
            print("Unexpectidly found nil while creating AVCaptureDeviceInput from \"\(self.currentDevice.position.rawValue)\" camera.")
            // !!!
            // Одна из камер не доступна,
            // Вывести предупреждение
            return
        }
        
        self.currentVideoInput = tmpInput
        
        // Проверяем, можно ли добавить данные с устройства на вход
        guard captureSession.canAddInput(self.currentVideoInput) else {
            print("Unexpectidly capture session is unable to add input: \"\(String(describing: self.currentVideoInput))\".")
            return
        }
        
        // Добавляем данные с другой камеры на вход
        // и подтверждаем изменения
        self.captureSession.addInput(self.currentVideoInput)
        self.captureSession.commitConfiguration()
        //self.captureSession.startRunning()
    }
    
    func switchFlash() {
        if currentDevice.hasTorch {
            do {
                try self.currentDevice.lockForConfiguration()
                if self.currentDevice.torchMode == .on {
                    self.currentDevice.torchMode = .off
                    self.captureController.rootView.changeFlashLightIcon(toImage: "bolt.slash.fill")
                } else if self.currentDevice.torchMode == .off {
                    self.currentDevice.torchMode = .auto
                    self.captureController.rootView.changeFlashLightIcon(toImage: "bolt.badge.a.fill")
                } else if self.currentDevice.torchMode == .auto {
                    self.currentDevice.torchMode = .on
                    self.captureController.rootView.changeFlashLightIcon(toImage: "bolt.fill")
                }
                self.currentDevice.unlockForConfiguration()
            } catch {
                print("Unable to lock camera device for configuration or toggle the torch.")
            }
        } else if currentDevice.hasFlash {
//            do {
//                try self.currentDevice.lockForConfiguration()
//                if self.captureSession == .off {
//                    self.currentDevice.flashMode = .auto
//                }
//            }
        }
    }
    
    private func ifAccessDenied() {
        // Если пользователь не разрешил доступ к камере,
        // обработаем отказ, позволив поменять решение в настройках
        let ac = UIAlertController(title: "Извините", message: "В случае, если вы ограничиваете приложению доступ к камере и/или микрофону, вы сможете загружать лишь фото из галереи. Изменить это всегда можно в Настройках.", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Открыть \"Настройки\"", style: .default) { _ in
            // Перейдем по ссылке на настройки чтобы активировать разрешения
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl) { succes in
                    if succes {
                        print("User went to settings after recieving warning on being unable to acces camera in Aspect")
                    } else {
                        print("Some error occured during switching to Settings app")
                    }
                }
            }
        })
        
        ac.addAction(UIAlertAction(title: "Закрыть", style: .destructive))
        
        self.present(ac, animated: true)
    }
    
    private func setupBaseUI() {
        // Настраивает стандартный интерфейс для подгрузки устройств записи
        // и взаимодействия с приватностью
        
        // Установка базового вида для объектива
        cameraVisor                 = UIView()
        cameraVisor.backgroundColor = .systemPink
        cameraVisor.frame           = self.view.bounds
        
        self.view.addSubview(cameraVisor)
        
        // Текст ожидания подключения записывающих устройств
        textLabelAwait                      = UILabel()
        textLabelAwait.text                 = "Ожидаем подключения устройств"
        textLabelAwait.textColor            =  .white
        textLabelAwait.applyShadow()
        
        self.cameraVisor.addSubview(textLabelAwait)
        
        textLabelAwait.translatesAutoresizingMaskIntoConstraints = false
        textLabelAwait.centerXAnchor.constraint(equalTo: self.cameraVisor.centerXAnchor).isActive = true
        textLabelAwait.centerYAnchor.constraint(equalTo: self.cameraVisor.centerYAnchor).isActive = true
        
        // Индикатор подгрузки устройств записи
        activityView                        = UIActivityIndicatorView(style: .large)
        activityView.color                  = .white
        activityView.applyShadow()
        
        self.cameraVisor.addSubview(activityView)
        
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerXAnchor.constraint(equalTo: self.cameraVisor.centerXAnchor).isActive = true
        activityView.bottomAnchor.constraint(equalTo: textLabelAwait.topAnchor, constant:  -(activityView.frame.height / 2)).isActive = true
        activityView.startAnimating()
    }
    
    private func setupCaptureSession() {
        // Настройка и установка сессии работы с камерой
        // Включается лишь после получения разрешения на доступ к камере
        
        // Проверяем, не была ли установлена сессия ранее
        if self.captureSession == nil {
            self.captureSession = AVCaptureSession()
        }
        // Начинаем настройку сессии
        self.captureSession.beginConfiguration()
        // Определяем устройства захвата
        currentDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        // Проверяем, возможно ли использование устройства захвата как входа данных для сессии
        guard let videoInput = try? AVCaptureDeviceInput(device: currentDevice!) else { return }
        self.currentVideoInput = videoInput
        guard self.captureSession.canAddInput(currentVideoInput) else { return }
        // Если функция продолжает работать, добавляем устройство в сессию
        self.captureSession.addInput(currentVideoInput)
        
        // Добавляем направление выхода фото
        self.capturePhotoOutput = AVCapturePhotoOutput()
        
        self.capturePhotoOutput.isHighResolutionCaptureEnabled = true
        guard self.captureSession.canAddOutput(capturePhotoOutput) else { return }
        // Формат получаемого материала = фото
        self.captureSession.sessionPreset = .hd1920x1080
        self.captureSession.addOutput(self.capturePhotoOutput)
        
        // Подтверждаем изменения в конфигурации
        self.captureSession.commitConfiguration()
    }
    
    func disableTakePhotoButton() {
        self.captureController.rootView.takePhotoButtonIsEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.captureController.rootView.takePhotoButtonIsEnabled = true
        }
    }
}

class PreviewView: UIView {
    // Класс для отображения изображения, получаемого с камеры
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}

extension UIView {
    func applyShadow() {
        self.layer.shadowColor    = UIColor.black.cgColor
        self.layer.shadowOpacity  = 0.6
        self.layer.shadowOffset   = CGSize(width: 3, height: 3)
    }
}
