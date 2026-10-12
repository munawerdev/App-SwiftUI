import Foundation

struct MultipartFormData {
    let boundary = "Boundary-\(UUID().uuidString)"
    private var data = Data()

    var contentType: String { "multipart/form-data; boundary=\(boundary)" }

    var body: Data {
        var result = data
        result.append("--\(boundary)--\r\n")
        return result
    }

    mutating func addField(name: String, value: String) {
        data.append("--\(boundary)\r\n")
        data.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
        data.append("\(value)\r\n")
    }

    mutating func addFile(
        name: String,
        fileName: String,
        mimeType: String,
        fileData: Data
    ) {
        data.append("--\(boundary)\r\n")
        data.append(
            "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n"
        )
        data.append("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.append("\r\n")
    }
}

extension Data {
    fileprivate mutating func append(_ string: String) {
        append(Data(string.utf8))
    }
}
