package com.example.demo.controller;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.BeachService;
import com.example.demo.vo.Beach;
import com.opencsv.CSVReader;

@Controller
public class UsrBeachController {

	@Autowired
	private BeachService beachService;

	// 네이버 지도 API 키 설정
	String CLIENT_ID = "ecu9lnpu4v"; // 발급받은 Client ID
	String CLIENT_SECRET = "VqB29c50SvbH3Rlyvz1A1d9vOO7MH1oUrXH8z1nx"; // 발급받은 Client Secret

	@RequestMapping("/usr/beach/main")
	public String showBeachMain() {
		return "/usr/beach/main";
	}

	@RequestMapping("/usr/beach/map")
	public String showBeachMap() {
		return "/usr/beach/map";
	}

	@RequestMapping("/usr/beach/test")
	@ResponseBody
	public String test() {

		double latitude = 0.0;
		double longitude = 0.0;

		String address = "서울특별시 강남구 테헤란로 152";

		try {
			String encodedAddress = URLEncoder.encode(address, "UTF-8");
			String apiURL = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=" + encodedAddress;
			URL url = new URL(apiURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setRequestProperty("X-NCP-APIGW-API-KEY-ID", CLIENT_ID);
			conn.setRequestProperty("X-NCP-APIGW-API-KEY", CLIENT_SECRET);

			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			StringBuilder response = new StringBuilder();
			String line;
			while ((line = br.readLine()) != null) {
				response.append(line);
			}
			br.close();

			JSONObject jsonObj = new JSONObject(response.toString());
			JSONArray addresses = jsonObj.getJSONArray("addresses");
			if (addresses.length() > 0) {
				JSONObject location = addresses.getJSONObject(0);
				latitude = location.getDouble("y");
				longitude = location.getDouble("x");
				System.out.println("위도: " + latitude + ", 경도: " + longitude);
			} else {
				System.out.println("해당 주소의 좌표를 찾을 수 없습니다.");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return "위도 : " + latitude + " 경도 : " + longitude;
	}

	@RequestMapping("/usr/beach/test2")
	@ResponseBody
	public String test2() {
		StringBuilder result = new StringBuilder();

		// 서비스 계층에서 해수욕장 리스트를 가져옵니다.
		List<Beach> beaches = beachService.getAllBeaches();

		if (beaches.isEmpty()) {
			return "데이터베이스에 해수욕장 정보가 없습니다.";
		}

		for (Beach beach : beaches) {
			double latitude = 0.0;
			double longitude = 0.0;
			String address = beach.getAddress();

			try {
				// 네이버 Geocoding API 호출
				String encodedAddress = URLEncoder.encode(address, "UTF-8");
				String apiURL = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=" + encodedAddress;
				URL url = new URL(apiURL);
				HttpURLConnection conn = (HttpURLConnection) url.openConnection();
				conn.setRequestMethod("GET");
				conn.setRequestProperty("X-NCP-APIGW-API-KEY-ID", CLIENT_ID);
				conn.setRequestProperty("X-NCP-APIGW-API-KEY", CLIENT_SECRET);

				BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				StringBuilder response = new StringBuilder();
				String line;
				while ((line = br.readLine()) != null) {
					response.append(line);
				}
				br.close();

				// JSON 파싱 및 위도 경도 추출
				JSONObject jsonObj = new JSONObject(response.toString());
				JSONArray addressArray = jsonObj.getJSONArray("addresses");
				if (addressArray.length() > 0) {
					JSONObject location = addressArray.getJSONObject(0);
					latitude = location.getDouble("y");
					longitude = location.getDouble("x");
					result.append("해수욕장: ").append(beach.getName()).append(", 주소: ").append(beach.getAddress())
							.append(", 위도: ").append(latitude).append(", 경도: ").append(longitude).append("<br>");
				} else {
					result.append("해당 주소의 좌표를 찾을 수 없습니다: ").append(address).append("<br>");
				}
			} catch (Exception e) {
				e.printStackTrace();
				result.append("에러가 발생했습니다: ").append(e.getMessage()).append("<br>");
			}
		}

		return result.toString();
	}

	// 일회성 코드(DB에 있는 주소값을 이용하여 위/경도 채우기)
	@RequestMapping("/usr/beach/doSetting/latlon")
	@ResponseBody
	public String doSettingDB() {
		StringBuilder output = new StringBuilder();

        // 서비스 계층에서 모든 해수욕장 리스트를 가져옵니다.
        List<Beach> beaches = beachService.getAllBeaches();

        if (beaches.isEmpty()) {
            return "데이터베이스에 해수욕장 정보가 없습니다.";
        }

        // 모든 해수욕장에 대해 주소로 위도/경도 가져오기
        for (Beach beach : beaches) {
            double latitude = 0.0;
            double longitude = 0.0;
            String address = beach.getAddress();

            try {
                // 네이버 Geocoding API 호출
                String encodedAddress = URLEncoder.encode(address, "UTF-8");
                String apiURL = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=" + encodedAddress;
                URL url = new URL(apiURL);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");
                conn.setRequestProperty("X-NCP-APIGW-API-KEY-ID", CLIENT_ID);
                conn.setRequestProperty("X-NCP-APIGW-API-KEY", CLIENT_SECRET);

                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line);
                }
                br.close();

                // JSON 파싱 및 위도 경도 추출
                JSONObject jsonObj = new JSONObject(response.toString());
                JSONArray addressArray = jsonObj.getJSONArray("addresses");
                if (addressArray.length() > 0) {
                    JSONObject location = addressArray.getJSONObject(0);
                    latitude = location.getDouble("y");
                    longitude = location.getDouble("x");

                    // 위도/경도를 데이터베이스에 업데이트
                    beachService.updateLatLon(beach.getId(), latitude, longitude);

                    // 출력값에 추가
                    output.append("해수욕장: ").append(beach.getName())
                          .append(", 주소: ").append(beach.getAddress())
                          .append(", 위도: ").append(latitude)
                          .append(", 경도: ").append(longitude)
                          .append("<hr>");
                } else {
                    output.append("해당 주소의 좌표를 찾을 수 없습니다: ").append(address).append("<hr>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                output.append("에러가 발생했습니다: ").append(e.getMessage()).append("<hr>");
            }
        }

        return output.toString();
	}
	
	// 테스트용 코드
	@RequestMapping("/usr/beach/showCSVData")
	@ResponseBody
	public String showData() {

		StringBuilder output = new StringBuilder(); // CSV 파일 내용을 담을 StringBuilder
		CSVReader reader = null;

		try {
			// 리소스 폴더에서 CSV 파일 읽기
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream("beach_info.csv");

			if (inputStream == null) {
				throw new FileNotFoundException("CSV file not found in resources folder");
			}

			// InputStreamReader에 UTF-8 인코딩을 명시적으로 지정
			reader = new CSVReader(new InputStreamReader(inputStream, "UTF-8"));
			String[] nextLine;

			// CSV 파일에서 한 줄씩 읽어와 StringBuilder에 추가
			while ((nextLine = reader.readNext()) != null) {
				for (String token : nextLine) {
					output.append(token).append(" "); // 각 CSV 값을 공백으로 구분하여 추가
				}
				output.append("<br>"); // 줄 바꿈 추가 (HTML)
			}

		} catch (Exception e) {
			e.printStackTrace();
			return "Error occurred: " + e.getMessage();
		} finally {
			try {
				if (reader != null) {
					reader.close(); // 리소스 해제
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		return "showCSVData 성공! <hr>" + output.toString(); // CSV 파일 내용 출력
	}

	public static List<String[]> readCSV(String filePath) throws Exception {
		CSVReader reader = new CSVReader(new FileReader(filePath));
		List<String[]> data = reader.readAll();
		reader.close();
		return data;
	}

	// 일회성 코드(DB에 .csv 파일의 내용 넣기)
	@RequestMapping("/usr/beach/doSetting/CSV")
	@ResponseBody
	public String doSettingCSV() {

		StringBuilder output = new StringBuilder(); // 로그 출력용 StringBuilder
		CSVReader reader = null;

		try {
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream("beach_info.csv");
			if (inputStream == null) {
				throw new FileNotFoundException("CSV file not found in resources folder");
			}

			reader = new CSVReader(new InputStreamReader(inputStream, "UTF-8"));
			String[] nextLine;

			// CSV 파일에서 한 줄씩 읽어오기
			while ((nextLine = reader.readNext()) != null) {

				String id = nextLine[0]; // 번호
				String localGovernment = nextLine[1];// 지자체
				String managementOffice = nextLine[2];// 관리청
				String name = nextLine[3]; // 해수욕장명
				String address = nextLine[4]; // 주소

				System.err.println(id);
				int temp = Integer.parseInt(id);

				beachService.doInsertBeachInfo(temp, localGovernment, managementOffice, name, address);

				output.append("Inserted: ").append(id).append(", ").append(localGovernment).append(", ")
						.append(managementOffice).append(", ").append(name).append(", ").append(address).append("<hr>");

			}

		} catch (Exception e) {
			e.printStackTrace();
			return "Error occurred: " + e.getMessage();
		} finally {
			try {
				if (reader != null) {
					reader.close(); // 리소스 해제
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		return "CSV to DB Insert 성공! <hr>" + output.toString();
	}

}