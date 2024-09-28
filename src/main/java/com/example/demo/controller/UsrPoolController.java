package com.example.demo.controller;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.PoolService;
import com.example.demo.util.CoordinateConverter;
import com.example.demo.vo.Pool;
import com.opencsv.CSVReader;

@Controller
public class UsrPoolController {

	@Autowired
	private PoolService poolService;

	@RequestMapping("/usr/pool/main")
	public String showPoolMain() {
		return "/usr/pool/main";
	}

	@RequestMapping("/usr/pool/map")
	public String showPoolMap(Model model) {

		// Pool 목록을 불러옴 (예: List<Pool>에서 Pool 클래스에 latitude와 longitude가 있음)
		List<Pool> pools = poolService.getAllPools();
		model.addAttribute("pools", pools); // JSP로 전달할 데이터
		
		return "/usr/pool/map";
	}
	
//	@RequestMapping("/usr/pool/search")
//	public ResponseEntity<Pool> searchPoolByName(@RequestParam String name) {
//        Pool pool = poolService.findByName(name);
//        if (pool != null) {
//            return ResponseEntity.ok(pool);
//        } else {
//            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
//        }
//    }

	// 일회성 코드(DB에 있는 중부원점 좌표를 위도/경도로 Update 하기)
	@RequestMapping("/usr/pool/doLatlonUpdate")
	@ResponseBody
	public String doLatlonUpdate() {
		String res = "doLatlonUpdate 성공!";

		// 전체 pool의 갯수 알아오기
		int poolsCount = poolService.getPoolsCount();

		// pool의 갯수만큼 해당 행의
		for (int i = 1; i <= poolsCount; i++) { //
			// 해당 행의...
			// 중부원점 x좌표 알아오기
			String tmpStrLat = poolService.getX(i);
			if (tmpStrLat == "" || tmpStrLat.isEmpty())
				continue;
			double tmpLat = Double.parseDouble(tmpStrLat);
			// 중부원점 y좌표 알아오기
			String tmpStrLon = poolService.getY(i);
			if (tmpStrLon == "" || tmpStrLon.isEmpty())
				continue;
			double tmpLon = Double.parseDouble(tmpStrLon);

			// 알아온 좌표를 위도/경도로 계산하기
			double[] result = CoordinateConverter.convertProj4j(tmpLat, tmpLon);

			// 위도/경도 반영하기
			poolService.setLatLon(i, result[0], result[1]);
		}

		return res + " " + poolsCount;
	}

	// 일회성 코드(DB에 .csv 파일의 내용 넣기)
	@RequestMapping("/usr/pool/doSetting")
	@ResponseBody
	public String doSettingDB() {

		StringBuilder output = new StringBuilder(); // 로그 출력용 StringBuilder
		CSVReader reader = null;

		try {
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream("selectOnlyData_PoolInfo.csv");
			if (inputStream == null) {
				throw new FileNotFoundException("CSV file not found in resources folder");
			}

			reader = new CSVReader(new InputStreamReader(inputStream, "UTF-8"));
			String[] nextLine;

			// CSV 파일에서 한 줄씩 읽어오기
			while ((nextLine = reader.readNext()) != null) {

				String id = nextLine[0]; // 번호

				String statusCode = nextLine[1]; // 영업상태구분코드
				String statusName = nextLine[2]; // 영업상태명
				String detailStatusCode = nextLine[3]; // 상세영업상태코드
				String detailStatusName = nextLine[4]; // 상세영업상태명

				String suspensionStartDate = nextLine[5]; // 휴업시작일자
				String suspensionEndDate = nextLine[6]; // 휴업종료일자

				suspensionStartDate = (suspensionStartDate.isEmpty()) ? null : suspensionStartDate;
				suspensionEndDate = (suspensionEndDate.isEmpty()) ? null : suspensionEndDate;

				String callNumber = nextLine[7]; // 소재지전화
				String postalCodeLocation = nextLine[8]; // 소재지우편번호
				String addressLocation = nextLine[9]; // 소재지전체주소
				String addressStreet = nextLine[10];// 도로명전체주소
				String postalCodeStreet = nextLine[11]; // 도로명우편번호

				String name = nextLine[12];// 사업장명

				String latitude = nextLine[13]; // 좌표정보(x)
				String longitude = nextLine[14]; // 좌표정보(y)

				System.err.println(id);
				int temp = Integer.parseInt(id);

				poolService.doInsertPoolInfo(temp, statusCode, statusName, detailStatusCode, detailStatusName,
						suspensionStartDate, suspensionEndDate, callNumber, postalCodeLocation, addressLocation,
						addressStreet, postalCodeStreet, name, latitude, longitude);

				output.append("Inserted: ").append(id).append(", ").append(statusCode).append(", ").append(statusName)
						.append(", ").append(detailStatusCode).append(", ").append(detailStatusName).append(", ")
						.append(suspensionStartDate).append(", ").append(suspensionEndDate).append(", ")
						.append(callNumber).append(", ").append(postalCodeLocation).append(", ")
						.append(postalCodeStreet).append(", ").append(addressLocation).append(", ")
						.append(addressStreet).append(", ").append(name).append(", ").append(latitude).append(", ")
						.append(longitude).append("<hr>");

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

	// 테스트용 코드
	@RequestMapping("/usr/pool/showCSVData")
	@ResponseBody
	public String showData() {

		StringBuilder output = new StringBuilder(); // CSV 파일 내용을 담을 StringBuilder
		CSVReader reader = null;

		try {
			// 리소스 폴더에서 CSV 파일 읽기
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream("selectOnlyData_PoolInfo.csv");

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
}