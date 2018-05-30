//
//  SoundViewController.swift
//  Snapchat
//
//  Created by Johan Miranda on 5/29/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class SoundViewController: UIViewController {
    var soundID = NSUUID().uuidString
    var audioURL:URL?
    var audioRecorder:AVAudioRecorder?
    var audioPlayer:AVAudioPlayer?
    var audio:Bool = true
    @IBOutlet weak var recordButton: UIButton!
    
    @IBAction func recordTapped(_ sender: Any) {
        if audioRecorder!.isRecording{
            //detener la grabacion
            audioRecorder?.stop()
            //cambiar texto del boton grabar
            recordButton.setTitle("Grabar Audio", for: .normal)
        }else{
            //empezar a grabar
            audioRecorder?.record()
            //cambiar el texto del boton grabar a detener
            recordButton.setTitle("Detener", for: .normal)
        }
    }
    @IBAction func playTapped(_ sender: Any) {
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        }catch{}
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let soundFolder = Storage.storage().reference().child("audios")
        let soundData = NSData(contentsOf: audioURL!)!
        let sound = soundFolder.child("\(soundID).mp4")
        sound.putData(soundData as Data, metadata: nil){(metadata,error) in
            if error != nil {
                self.mostrarAlerta(title: "Error", message: "Se produjo un error al subir el archivo. Vuelve a intentarlo", action: "Cancelar")
                print("Ocurrio un error al subir archivo: \(error)")
                return
            }else{
                self.performSegue(withIdentifier: "sendSoundSegue", sender: self.audioURL?.absoluteString)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.soundURL = sender as! String
        siguienteVC.soundID = soundID
        siguienteVC.audio = audio
    }
    
    func setupRecorder(){
        do{
            //creando sesion de audio
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //creando direccion para el archivo de audio
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath,"\(soundID).m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            print("***********************")
            print(audioURL!)
            print("***********************")
            
            //crear opciones para el grabador de audio
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            settings[AVEncoderAudioQualityKey] = AVAudioQuality.low.rawValue as AnyObject
            
            //crear el objecto de grabacion de audio
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func mostrarAlerta(title: String, message: String, action: String){
        let alertaGuia = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelok = UIAlertAction(title: action, style: .default, handler: nil)
        alertaGuia.addAction(cancelok)
        present(alertaGuia, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
