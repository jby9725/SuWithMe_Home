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
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.BeachService;
import com.example.demo.vo.Beach;
import com.example.demo.vo.Weather;
import com.opencsv.CSVReader;

@Controller
public class UsrBeachController {

	@Autowired
	private BeachService beachService;

	// 네이버 지도 API 키 설정
	String CLIENT_ID = "ecu9lnpu4v"; // 발급받은 Client ID
	String CLIENT_SECRET = "VqB29c50SvbH3Rlyvz1A1d9vOO7MH1oUrXH8z1nx"; // 발급받은 Client Secret

	// 공공데이터 API 키 설정
	static String serviceKey = "%2FllRGslbdoyOeIv03DzWYbGc6BcoPrGod7I%2BlQv1eaVXKCreSVZ4SCslcElCklrbG8ZBaBxo18jchTywR0pdCQ%3D%3D";

	@RequestMapping("/usr/beach/main")
	public String showBeachMain() {
		return "/usr/beach/main";
	}

	@RequestMapping("/usr/beach/map")
	public String showBeachMap(Model model) {
		// 데이터베이스에서 해수욕장 정보를 가져옴
		List<Beach> beaches = beachService.getAllBeaches();
		// 모델에 해수욕장 리스트 추가
		model.addAttribute("beaches", beaches);
		return "/usr/beach/map";
	}

	@RequestMapping("/usr/beach/weather")
	@ResponseBody
	public ResponseEntity<Map<String, Weather>> getWeatherData(
	        @RequestParam("nx") String nx,
	        @RequestParam("ny") String ny,
	        @RequestParam("numOfRows") int numOfRows) {

	    Map<String, Weather> weatherDataMap = new HashMap<>();

	    try {
	        // API 요청 URL 설정
	        String baseDate = getCurrentBaseDate(); // 기준 날짜 (오늘 날짜)
	        String baseTime = "0800"; // 기준 시간 (고정 시간: 08:00)
	        String apiURL = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst";
	        StringBuilder urlBuilder = new StringBuilder(apiURL);
	        urlBuilder.append("?" + URLEncoder.encode("serviceKey", "UTF-8") + "=" + serviceKey);
	        urlBuilder.append("&" + URLEncoder.encode("pageNo", "UTF-8") + "=1");
	        urlBuilder.append("&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + numOfRows);
	        urlBuilder.append("&" + URLEncoder.encode("dataType", "UTF-8") + "=JSON");
	        urlBuilder.append("&" + URLEncoder.encode("base_date", "UTF-8") + "=" + baseDate);
	        urlBuilder.append("&" + URLEncoder.encode("base_time", "UTF-8") + "=" + baseTime);
	        urlBuilder.append("&" + URLEncoder.encode("nx", "UTF-8") + "=" + nx);
	        urlBuilder.append("&" + URLEncoder.encode("ny", "UTF-8") + "=" + ny);

	        URL url = new URL(urlBuilder.toString());
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	        conn.setRequestMethod("GET");

	        BufferedReader rd;
	        if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
	            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        } else {
	            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
	        }
	        StringBuilder result = new StringBuilder();
	        String line;
	        while ((line = rd.readLine()) != null) {
	            result.append(line);
	        }
	        rd.close();
	        conn.disconnect();

	        JSONObject jsonResponse = new JSONObject(result.toString());
	        JSONObject responseObject = jsonResponse.getJSONObject("response");
	        JSONObject header = responseObject.getJSONObject("header");
	        String resultCode = header.getString("resultCode");

	        if (!"00".equals(resultCode)) {
	            return ResponseEntity.ok(weatherDataMap);
	        }

	        JSONObject body = responseObject.getJSONObject("body");
	        JSONArray items = body.getJSONObject("items").getJSONArray("item");

	        // 각 기준 시간별로 데이터를 통합해서 저장
	        for (int i = 0; i < items.length(); i++) {
	            JSONObject item = items.getJSONObject(i);
	            String baseTime1 = item.getString("fcstTime");
	            String category = item.getString("category");
	            String value = item.getString("fcstValue");

	            Weather weather;
	            if (weatherDataMap.containsKey(baseTime1)) {
	                weather = weatherDataMap.get(baseTime1);
	            } else {
	                weather = new Weather();
	                weather.setBaseTime(baseTime1);
	                weatherDataMap.put(baseTime1, weather);
	            }

	            switch (category) {
	                case "TMP":
	                    weather.setTemperature(value + "℃");
	                    break;
	                case "PTY":
	                    weather.setPrecipitationType(getRainType(value));
	                    break;
	                case "POP":
	                    weather.setPrecipitationProbability(value + "%");
	                    break;
	            }
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return ResponseEntity.ok(weatherDataMap);
	}

	// 필요한 날씨 정보를 추출하는 함수
	private JSONObject extractWeatherInfo(JSONArray items) {
		JSONObject weatherInfo = new JSONObject();
		String baseTime = ""; // baseTime을 저장할 변수

		for (int i = 0; i < items.length(); i++) {
			JSONObject item = items.getJSONObject(i);
			String category = item.getString("category");

			// baseTime 값을 한번만 설정하도록 체크
			if (baseTime.isEmpty()) {
				baseTime = item.getString("baseTime"); // baseTime 값을 추출
			}

			switch (category) {
			case "TMP": // 기온
				weatherInfo.put("temperature", item.getString("fcstValue") + "℃");
				break;
			case "PTY": // 강수 형태
				String rainType = getRainType(item.getString("fcstValue"));
				weatherInfo.put("precipitationType", rainType);
				break;
			case "POP": // 강수 확률
				weatherInfo.put("precipitationProbability", item.getString("fcstValue"));
				break;
			}
		}
		weatherInfo.put("baseTime", baseTime); // baseTime 추가
		return weatherInfo;
	}

	private static String getCurrentBaseDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		Calendar calendar = Calendar.getInstance();
		return sdf.format(calendar.getTime());
	}

	private static String getRainType(String fcstValue) {
		switch (fcstValue) {
		case "0":
			return "없음";
		case "1":
			return "비";
		case "2":
			return "비/눈";
		case "3":
			return "눈";
		case "4":
			return "소나기";
		default:
			return "알 수 없음";
		}
	}

	// 하늘 상태 해석 함수
	private static String getSkyStatus(String fcstValue) {
		switch (fcstValue) {
		case "1":
			return "맑음";
		case "3":
			return "구름 많음";
		case "4":
			return "흐림";
		default:
			return "알 수 없음";
		}
	}

	// 대전 시청 기준 오전 9시부터 날씨 데이터 가져오기
	@RequestMapping("/usr/beach/weatherForecast")
	@ResponseBody
	public static String getWeatherForecast() {
		StringBuilder sb = new StringBuilder();

		try {
			// API 엔드포인트 및 파라미터 설정
			String baseDate = getCurrentBaseDate(); // 기준 날짜 (오늘 날짜)
			String baseTime = "0800"; // 기준 시간 (고정 시간: 08:00)
			String nx = "67"; // 격자 X 좌표 (대전 시청 기준)
			String ny = "100"; // 격자 Y 좌표 (대전 시청 기준)
			int pageNo = 1; // 페이지 번호
			int numOfRows = 600; // 한 페이지당 데이터 수

			// 첫 번째 API 호출로 24시간 예보 데이터 가져오기
			JSONArray firstDayData = fetchWeatherData(serviceKey, baseDate, baseTime, nx, ny, pageNo, numOfRows);

			// 두 번째 API 호출로 다음 날 예보 데이터 가져오기
			String nextDate = incrementDate(baseDate, 1);
			JSONArray secondDayData = fetchWeatherData(serviceKey, nextDate, baseTime, nx, ny, pageNo, numOfRows);

			// 두 데이터 세트를 하나로 합치기
			JSONArray combinedData = new JSONArray();
			for (int i = 0; i < firstDayData.length(); i++) {
				combinedData.put(firstDayData.getJSONObject(i));
			}
			for (int i = 0; i < secondDayData.length(); i++) {
				combinedData.put(secondDayData.getJSONObject(i));
			}

			// 3시간 간격으로 데이터를 필터링하여 출력
			sb.append("=== ").append(baseDate).append(" ").append(formatTime(baseTime))
					.append(" 이후 48시간 3시간 간격 예보 ===\n");
			String lastFcstTime = "";
			for (int i = 0; i < combinedData.length(); i++) {
				JSONObject item = combinedData.getJSONObject(i);
				String category = item.getString("category");
				String fcstTime = item.getString("fcstTime");
				String fcstDate = item.getString("fcstDate");
				String fcstValue = item.getString("fcstValue");

				// 3시간 간격 (예: 0800, 1100, 1400, ...)인지 확인하여 필터링
				if (isThreeHourInterval(fcstTime)) {
					// 시간대가 변경될 때마다 날짜와 시간 출력
					if (!fcstTime.equals(lastFcstTime)) {
						sb.append("\n[").append(fcstDate).append(" ").append(formatTime(fcstTime)).append("]\n");
						lastFcstTime = fcstTime;
					}

					// 원하는 카테고리만 추출하여 보기 좋게 출력
					switch (category) {
					case "TMP": // 기온
						sb.append("기온: ").append(fcstValue).append("℃\n");
						break;
					case "PTY": // 강수 형태
						String rainType = getRainType(fcstValue);
						sb.append("강수 형태: ").append(rainType).append("\n");
						break;
					case "POP": // 강수 확률
						sb.append("강수 확률: ").append(fcstValue).append("%\n");
						break;
					case "SKY": // 하늘 상태
						String skyStatus = getSkyStatus(fcstValue);
						sb.append("하늘 상태: ").append(skyStatus).append("\n");
						break;
					}
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
			sb.append("Error occurred while fetching weather data.");
		}

		return sb.toString();
	}

	// 단기 예보 데이터를 가져오는 함수
	private static JSONArray fetchWeatherData(String serviceKey, String baseDate, String baseTime, String nx, String ny,
			int pageNo, int numOfRows) {
		try {
			// API URL 구성
			String apiURL = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst";
			StringBuilder urlBuilder = new StringBuilder(apiURL);
			urlBuilder.append("?" + URLEncoder.encode("serviceKey", "UTF-8") + "=" + serviceKey);
			urlBuilder.append("&" + URLEncoder.encode("pageNo", "UTF-8") + "=" + pageNo); // 페이지 번호 설정
			urlBuilder.append("&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + numOfRows); // 한 페이지당 데이터 수 설정
			urlBuilder.append("&" + URLEncoder.encode("dataType", "UTF-8") + "=JSON");
			urlBuilder.append("&" + URLEncoder.encode("base_date", "UTF-8") + "=" + baseDate);
			urlBuilder.append("&" + URLEncoder.encode("base_time", "UTF-8") + "=" + baseTime);
			urlBuilder.append("&" + URLEncoder.encode("nx", "UTF-8") + "=" + nx);
			urlBuilder.append("&" + URLEncoder.encode("ny", "UTF-8") + "=" + ny);

			// URL 객체 생성 및 연결
			URL url = new URL(urlBuilder.toString());
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");

			// 응답 데이터 읽기
			BufferedReader rd;
			if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
				rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			} else {
				rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
			}
			StringBuilder response = new StringBuilder();
			String line;
			while ((line = rd.readLine()) != null) {
				response.append(line);
			}
			rd.close();
			conn.disconnect();

			// JSON 응답 데이터 파싱 및 필요한 정보 추출
			JSONObject jsonResponse = new JSONObject(response.toString());
			JSONObject responseObject = jsonResponse.getJSONObject("response");
			JSONObject header = responseObject.getJSONObject("header");
			String resultCode = header.getString("resultCode");

			// 데이터가 존재하지 않을 때는 빈 배열 반환
			if (!"00".equals(resultCode)) {
				return new JSONArray();
			}

			JSONObject body = responseObject.getJSONObject("body");
			JSONObject items = body.getJSONObject("items");
			return items.getJSONArray("item");

		} catch (Exception e) {
			e.printStackTrace();
			return new JSONArray(); // 에러 발생 시 빈 배열 반환
		}
	}

	// 3시간 간격인지 확인하는 함수
	private static boolean isThreeHourInterval(String fcstTime) {
		// 3시간 간격 (0900, 1200, 1500, 1800, 2100, 2400, 0300, 0600)
		return fcstTime.equals("0900") || fcstTime.equals("1200") || fcstTime.equals("1500") || fcstTime.equals("1800")
				|| fcstTime.equals("2100") || fcstTime.equals("0000") || fcstTime.equals("0300")
				|| fcstTime.equals("0600");
	}

	// 시간 형식 변환 함수 (HHmm -> HH:mm)
	private static String formatTime(String time) {
		return time.substring(0, 2) + ":" + time.substring(2);
	}

	// 날짜 증가 함수 (yyyyMMdd 형식)
	private static String incrementDate(String baseDate, int dayIncrement) {
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(sdf.parse(baseDate));
			calendar.add(Calendar.DATE, dayIncrement);
			return sdf.format(calendar.getTime());
		} catch (Exception e) {
			e.printStackTrace();
			return baseDate; // 에러 발생 시 기본 날짜 반환
		}
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
					output.append(token).append(" | "); // 각 CSV 값을 공백으로 구분하여 추가
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

				// nextLine[0]에 이상한 단어 들어감.
				String id = nextLine[1]; // 번호
				String name = nextLine[2];// 해수욕장명
				String nx = nextLine[3];// nx
				String ny = nextLine[4]; // ny
				String latitude = nextLine[5]; // 위도
				String longitude = nextLine[6]; // 경도

				System.err.println(id);
				int temp = Integer.parseInt(id);
				int temp_nx = Integer.parseInt(nx);
				int temp_ny = Integer.parseInt(ny);

				beachService.doInsertBeachInfo(temp, name, temp_nx, temp_ny, latitude, longitude);

				output.append("Inserted: ").append(id).append(", ").append(name).append(", ").append(temp_nx)
						.append(", ").append(temp_ny).append(", ").append(latitude).append(", ").append(longitude)
						.append("<hr>");

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