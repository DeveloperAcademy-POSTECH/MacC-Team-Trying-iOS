//
//  AddCourseRepositoryImpl.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/27.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class AddCourseRepositoryImpl: AddCourseRepository {
    // FIXME: token 수정하기
    private let url = "http://15.165.72.196:3059/courses"
    private let method = "POST"
    private let token = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJpZCI6ImRmMTg4ZTllLTg1ODItNGI2ZC1hM2NmLWEzNTNmY2FkMzE5NSIsImF1dGgiOiJVU0VSIn0.iemX4cOign5PyhkaixHK3GEDP5X6ABuWSt_ar4HzMEOhEX888SCauHYla_lRMgZTeQnmOAa8oqpAiuvcytzqdg"
    
    func addCourse(addCourseDTO: AddCourseDTO, images: [UIImage]) async throws {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method
        request.setValue(token, forHTTPHeaderField: "accessToken")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=data\r\n".data(using: .utf8)!)
        data.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
        data.append(try JSONEncoder().encode(addCourseDTO))
        
        images.forEach { image in
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=images; filename=image.png\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            data.append(image.pngData()!)
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        }
        
        let (responseData, response) = try await URLSession.shared.upload(for: request, from: data)
        if (response as! HTTPURLResponse).statusCode == 200 {
            dump(try JSONDecoder().decode(AddCourseResponse.self, from: responseData))
        } else {
            print((response as! HTTPURLResponse).statusCode)
            dump(try JSONDecoder().decode(AddCourseError.self, from: responseData))
        }
    }
}
