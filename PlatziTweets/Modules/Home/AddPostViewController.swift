//
//  AddPostViewController.swift
//  PlatziTweets
//
//  Created by Jackson Cuevas on 12/8/24.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift
import FirebaseStorage
import AVFoundation
import AVKit
import MobileCoreServices
import CoreLocation

class AddPostViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func openCameraAction(_ sender: Any) {
        let alert = UIAlertController(title: "Cámara", message: "Selecciona una opción", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Foto", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Video", style: .default, handler: { _ in
            self.openVideoCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func addPostAction() {
        if currentVideoURL != nil {
            uploadVideoToFirebase()
            return
        }
        
        if previewImageView.image != nil {
            uploadPhotoToFirebase()
            return
        }
        
        savePost(imageUrl: nil, videoUrl: nil)
    }
    
    @IBAction func openPreviewAction() {
        guard let currentVideoURL = currentVideoURL else {
            return
        }
        
        let avPlayer = AVPlayer(url: currentVideoURL)
        
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPlayer
        
        present(avPlayerController, animated: true) {
            avPlayerController.player?.play()
        }
    }
    
    @IBAction func dismissAction() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Properties
    private var imagePicker: UIImagePickerController?
    private var currentVideoURL: URL?
    private var locationManager: CLLocationManager?
    private var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoButton.isHidden = true
        requestLocation()
    }
    
    private func requestLocation() {
        // Validamos que el usuario tenga el GPS activo y disponible.
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    private func openVideoCamera() {
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.mediaTypes = [kUTTypeMovie as String]
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode = .video
        imagePicker?.videoQuality = .typeMedium
        imagePicker?.videoMaximumDuration = TimeInterval(5)
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else {
            return
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    private func openCamera() {
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode = .photo
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else {
            return
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func uploadPhotoToFirebase() {
        // 1. Asegurarnos de que la foto exista
        // 2. Comprimir la imagen y convertila en Data
        
        guard
            let imageSaved = previewImageView.image,
            let imageSacedData: Data = imageSaved.jpegData(compressionQuality: 0.1) else {
            
            return
        }
        
        SVProgressHUD.show()
        
        //3. Configuración para guardar la foto en firebase
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        
        
        //4 . Referencia al storage de firebase
        let storage = Storage.storage()
        
        
        //5. Crear nombre de la imagen a subir
        let imageName = Int.random(in: 100...1000)
        
        // 6. Referencia a la carpeta donde se va a guardar la foto
        let folderReference = storage.reference(withPath: "fotos-tweets/\(imageName).jpg")
        
        
        // 7. Subir la foto a Firebase
        DispatchQueue.global(qos: .background).async {
            folderReference.putData(imageSacedData, metadata: metaDataConfig) { (metaData: StorageMetadata?, error: Error?) in
                
                DispatchQueue.main.async {
                    
                    //Detener la carga
                    SVProgressHUD.dismiss()
                    
                    if let error = error {
                        NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .warning).show()
                        
                        return
                    }
                    
                    // obtener la URL de descarga
                    folderReference.downloadURL{ (url: URL?, error: Error?) in
                        let downloadUrl =   url?.absoluteString
                        self.savePost(imageUrl: downloadUrl, videoUrl: nil)
                    }
                }
                
            }
        }
        
    }
    
    private func uploadVideoToFirebase() {
        // 1. Asegurarnos de que el video exista
        // 2. Convertir en Data el video
        
        guard
            let currentVideoSavedURL = currentVideoURL,
            let videoData: Data = try? Data(contentsOf: currentVideoSavedURL) else {
            
            return
        }
        
        SVProgressHUD.show()
        
        //3. Configuración para guardar la foto en firebase
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "video/MP4"
        
        
        //4 . Referencia al storage de firebase
        let storage = Storage.storage()
        
        
        //5. Crear nombre del video a subir
        let videoName = Int.random(in: 100...1000)
        
        // 6. Referencia a la carpeta donde se va a guardar la foto
        let folderReference = storage.reference(withPath: "video-tweets/\(videoName).mp4")
        
        
        // 7. Subir el video a Firebase
        DispatchQueue.global(qos: .background).async {
            folderReference.putData(videoData, metadata: metaDataConfig) { (metaData: StorageMetadata?, error: Error?) in
                
                DispatchQueue.main.async {
                    
                    //Detener la carga
                    SVProgressHUD.dismiss()
                    
                    if let error = error {
                        NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .warning).show()
                        
                        return
                    }
                    
                    // obtener la URL de descarga
                    folderReference.downloadURL{ (url: URL?, error: Error?) in
                        let downloadUrl =   url?.absoluteString
                        self.savePost(imageUrl: nil, videoUrl: downloadUrl)
                    }
                }
                
            }
        }
        
    }
    
    private func savePost(imageUrl: String?, videoUrl: String?) {
        // Crear un request de locatión
        var postLocation: PostRequestLocation?
        
        if let userLocation = userLocation {
            postLocation = PostRequestLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        }
        
        //1. Crear request
        let request = PostRequest(text: postTextView.text, imageUrl: imageUrl, videoUrl: videoUrl, location: postLocation)
        
        //2. Indicar carga al usuario
        SVProgressHUD.show()
        
        //3. LLamar al servicio del post
        SN.post(endpoint: Endpoints.post, model: request) {(response: SNResultWithEntity<Post, ErrorResponse>) in
            
            //4. Cerrar indicador de carga
            SVProgressHUD.dismiss()
            
            switch  response {
            case .success:
                self.dismiss(animated: true, completion: nil)
            case .error(let error):
                NotificationBanner(subtitle: error.localizedDescription, style: .danger).show()
            case .errorResult(let entity):
                NotificationBanner(subtitle: entity.error, style: .danger).show()
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Cerrar cámara
        imagePicker?.dismiss(animated: true, completion: nil)
        
        // Capturar imagen
        if info.keys.contains(.originalImage) {
            previewImageView.isHidden = false
            
            // Obtenemos la imagen tomada
            previewImageView.image = info[.originalImage] as? UIImage
        }
        
        // Aquí capturamos la url del video
        if info.keys.contains(.mediaURL), let recordedVideoUrl = (info[.mediaURL] as? URL)?.absoluteURL {
            
            videoButton.isHidden = false
            currentVideoURL = recordedVideoUrl
        }
    }
    
}

extension AddPostViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let bestLocation = locations.last else {
            return
        }
        
        // Ya tenemos la ubicación del usuario!
        userLocation = bestLocation
    }
}
