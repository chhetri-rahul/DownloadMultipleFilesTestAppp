//
//  ViewController.swift
//  DownloadMultipleFilesTestApp
//

import UIKit
import OSLog

class ViewController: UIViewController {
    
    let logger = Logger(subsystem: "com.mycompany.DownloadMultipleFilesTestApp", category: "ViewController")
    
    // 5mb pdf file url
    let url_5mb_file = URL(string: "https://download.support.xerox.com/pub/docs/FlowPort2/userdocs/any-os/en/fp_dc_setup_guide.pdf")!
    // 4kb pdf file url
    let url_4kb_file = URL(string: "https://s29.q4cdn.com/175625835/files/doc_downloads/test.pdf")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func downloadClicked(_ sender: Any) {
        downloadFiles()
    }
    
    func downloadFiles() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        logger.debug("Beginning download at time: \(formatter.string(from: Date()), privacy: .public)")
        
        for i in 0..<500 {
            let bgConfig = URLSessionConfiguration.background(withIdentifier: "com.mycompany.DownloadMultipleFilesTestApp-\(i)")
            let urlSession = URLSession(configuration: bgConfig, delegate: self, delegateQueue: nil)
            let myTask = urlSession.downloadTask(with: url_4kb_file)
            myTask.resume()
            logger.debug("Starting download for: \(i) at time: \(formatter.string(from: Date()), privacy: .public)")
        }
        logger.debug("All download started at time: \(formatter.string(from: Date()), privacy: .public)")
    }
}

extension ViewController: URLSessionDownloadDelegate, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let dir = urls[0]
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        
        if let httpResponse = downloadTask.response as? HTTPURLResponse {
            logger.debug("server error: NO for location: \(location.lastPathComponent, privacy: .public), for config.id: \(session.configuration.identifier ?? "no-id", privacy: .public), task.id: \(downloadTask.taskIdentifier, privacy: .public), at time: \(formatter.string(from: Date()), privacy: .public)")
            if (200...299).contains(httpResponse.statusCode) {
                logger.debug("status code: \(httpResponse.statusCode) [satisfied] for location: \(location.lastPathComponent, privacy: .public), for config.id: \(session.configuration.identifier ?? "no-id", privacy: .public), task.id: \(downloadTask.taskIdentifier, privacy: .public), at time: \(formatter.string(from: Date()), privacy: .public)")
            } else {
                logger.debug("status code: \(httpResponse.statusCode) [not satisfied] for location: \(location.lastPathComponent, privacy: .public),for config.id: \(session.configuration.identifier ?? "no-id", privacy: .public), task.id: \(downloadTask.taskIdentifier, privacy: .public), at time: \(formatter.string(from: Date()), privacy: .public)")
            }
        } else {
            logger.debug("server error: YES for location: \(location.lastPathComponent, privacy: .public), for config.id: \(session.configuration.identifier ?? "no-id", privacy: .public), task.id: \(downloadTask.taskIdentifier, privacy: .public), at time: \(formatter.string(from: Date()), privacy: .public)")
        }
        
        logger.debug("didFinishDownloadingTo location: \(location.lastPathComponent, privacy: .public),for config.id: \(session.configuration.identifier ?? "no-id", privacy: .public), task.id: \(downloadTask.taskIdentifier, privacy: .public), at time: \(formatter.string(from: Date()), privacy: .public)")
        
        let dirToBeMovedTo = dir.appendingPathComponent("file-\(UUID().uuidString.suffix(6)).pdf")
        do {
            logger.debug("before move file exists at location: \(FileManager.default.fileExists(atPath: location.path()), privacy: .public), for config.id: \(session.configuration.identifier ?? "no-id", privacy: .public), task.id: \(downloadTask.taskIdentifier, privacy: .public), at time: \(formatter.string(from: Date()), privacy: .public)")
            try FileManager.default.moveItem(at: location, to: dirToBeMovedTo)
            logger.debug("after move file exists at location: \(FileManager.default.fileExists(atPath: location.path()), privacy: .public),for config.id: \(session.configuration.identifier ?? "no-id", privacy: .public),  task.id: \(downloadTask.taskIdentifier, privacy: .public), at time: \(formatter.string(from: Date()), privacy: .public)")
            logger.debug("moved successfully file: \(location.lastPathComponent, privacy: .public) to path: \(dirToBeMovedTo.lastPathComponent, privacy: .public) for config.id: \(session.configuration.identifier ?? "no-id", privacy: .public),  task.id: \(downloadTask.taskIdentifier, privacy: .public), at time: \(formatter.string(from: Date()), privacy: .public)")
        } catch {
            logger.debug("\(error) - error when moving file: \(location.lastPathComponent, privacy: .public), current config.id: \(session.configuration.identifier ?? "no-id", privacy: .public),  task.id: \(downloadTask.taskIdentifier, privacy: .public), at time: \(formatter.string(from: Date()), privacy: .public)")
        }
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        logger.debug("called urlSessionDidFinishEvents, for: \(session.configuration.identifier ?? "no-id", privacy: .public), at time: \(formatter.string(from: Date()), privacy: .public)")
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                self.logger.debug("executing completion handler for: \(session.configuration.identifier ?? "no-id", privacy: .public) at time: \(formatter.string(from: Date()), privacy: .public)")
                appDelegate.bgHandlers[session.configuration.identifier!]!()
                appDelegate.bgHandlers[session.configuration.identifier!] = nil
            } else {
                self.logger.debug("could not cast to Appdelegate for: \(session.configuration.identifier ?? "no-id", privacy: .public) at time: \(formatter.string(from: Date()), privacy: .public)")
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        logger.debug("didCompleteWithError for session: \(session.configuration.identifier ?? "no-id", privacy: .public), error: \(error) at time: \(formatter.string(from: Date()), privacy: .public)")
    }
    
    func urlSession(_ session: URLSession, didCreateTask task: URLSessionTask) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        logger.debug("didCreateTask for session: \(session.configuration.identifier ?? "no-id", privacy: .public), task.id: \(task.taskIdentifier, privacy: .public), task.state: \(task.state.rawValue, privacy: .public), at time: \(formatter.string(from: Date()), privacy: .public)")
    }
}

