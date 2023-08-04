import Foundation
import Moya

final class MoyaLoggerPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        guard let httpReqest = request.request else {
            print("유효하지 않은 통신")
            return
        }
        let url = httpReqest.description
        let method = httpReqest.httpMethod ?? "no method"
        var log = "----------------------------------------------------\n[\(method)]\(url)\n----------------------------------------------------\n"
        log.append("API: \(target)\n")
        if let headers = httpReqest.allHTTPHeaderFields, !headers.isEmpty {
            log.append("headers: \(headers)\n")
        }
        if let body = httpReqest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
            log.append("body: \(bodyString)\n")
        }
        log.append("------------------- END \(method) --------------------------")
        print(log)
    }
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            onSuceed(response, target: target, isFromError: false)
        case .failure(let error):
            onFail(error, target: target)
        }
    }
    func onSuceed(_ response: Response, target: TargetType, isFromError: Bool) {
        let request = response.request
        let url = request?.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode
        var log = "------------------- 네트워크 통신 성공(isFromError: \(isFromError)) -------------------"
        log.append("\n[\(statusCode)] \(url)\n----------------------------------------------------\n")
        log.append("API: \(target)\n")
        response.response?.allHeaderFields.forEach {
            log.append("\($0): \($1)\n")
        }
        if let reString = String(bytes: response.data, encoding: String.Encoding.utf8) {
            log.append("\(reString)\n")
        }
        log.append("------------------- END HTTP (\(response.data.count)-byte body) -------------------")
        print(log)
    }
    func onFail(_ error: MoyaError, target: TargetType) {
        if let response = error.response {
            onSuceed(response, target: target, isFromError: true)
            return
        }
        var log = "네트워크 오류\n"
        log.append("\(error.errorCode) \(target)\n")
        log.append("\(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
        log.append("<-- END HTTP")
        print(log)
    }
}

