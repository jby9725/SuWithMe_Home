package com.example.demo.vo;

import java.util.Map;

import com.example.demo.util.Ut;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ResultData<DT> {
	// 성공S/실패F
	private String ResultCode;
	// 자세한 메세지
	private String msg;
	// 함께 처리할 데이터, 여기서는 Article, Member, List 여러 형태가 있음.
	private DT data1;
	private String data1Name;

	private Object data2;
	private String data2Name;

	private Map<String, Object> body;

	public ResultData(String ResultCode, String msg, Object... args) {
		this.ResultCode = ResultCode;
		this.msg = msg;
		this.body = Ut.mapOf(args);
	}

	// data가 없는 경우
	public static <DT> ResultData<DT> from(String ResultCode, String msg) {
		return from(ResultCode, msg, null, null);
	}

	// data가 있는 경우
	// rd 객체를 생성하여 가져온 정보를 담고 리턴
	public static <DT> ResultData<DT> from(String ResultCode, String msg, String data1Name, Object data1) {
		ResultData rd = new ResultData();
		rd.ResultCode = ResultCode;
		rd.msg = msg;
		rd.data1Name = data1Name;
		rd.data1 = data1;

		return rd;
	}

	public static <DT> ResultData<DT> from(String resultCode, String msg, String data1Name, DT data1, String data2Name,
			DT data2) {
		ResultData<DT> rd = new ResultData<DT>();
		rd.ResultCode = resultCode;
		rd.msg = msg;
		rd.data1Name = data1Name;
		rd.data1 = data1;
		rd.data2Name = data2Name;
		rd.data2 = data2;

		return rd;
	}

	public boolean isSuccess() {
		return ResultCode.startsWith("S-");
	}

	public boolean isFail() {
		return isSuccess() == false;
	}

	// 뒤의 data를 newData로 갱신.
	public static <DT> ResultData<DT> newData(ResultData rd, String data1Name, DT newData) {
		return from(rd.getResultCode(), rd.getMsg(), data1Name, newData);
	}

	public void setData2(String data2Name, Object data2) {
		this.data2 = data2;
		this.data2Name = data2Name;
	}

}