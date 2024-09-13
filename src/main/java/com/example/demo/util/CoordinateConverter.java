package com.example.demo.util;

import org.locationtech.proj4j.CRSFactory;
import org.locationtech.proj4j.CoordinateReferenceSystem;
import org.locationtech.proj4j.CoordinateTransform;
import org.locationtech.proj4j.CoordinateTransformFactory;
import org.locationtech.proj4j.ProjCoordinate;

public class CoordinateConverter {

	

	public static double[] convertProj4j(double x, double y) {
		// CRSFactory 생성
		CRSFactory crsFactory = new CRSFactory();

		// 원본 및 목적지 좌표계 설정
		// src에
		// 옛날 : EPSG:2097 보정안된 중부원점(bessel) // 홈페이지에 써있음. EPSG:2097라고.
		CoordinateReferenceSystem srcCrs = crsFactory.createFromName("EPSG:2097");
		CoordinateReferenceSystem destCrs = crsFactory.createFromName("EPSG:4326");
		// EPSG:5174 / EPSG:5186 (이상한데?) // 남쪽으로 차이나는 EPSG:4166

		// 좌표 변환을 위한 변환기 생성
		CoordinateTransformFactory ctFactory = new CoordinateTransformFactory();
		CoordinateTransform transform = ctFactory.createTransform(srcCrs, destCrs);

		// 변환할 좌표 설정
		ProjCoordinate srcCoord = new ProjCoordinate(x, y);
		ProjCoordinate destCoord = new ProjCoordinate();

		// 좌표 변환 수행
		transform.transform(srcCoord, destCoord);

		System.err.println("===========================================================");
		System.err.println("변환된 (Helmert 전) Latitude: " + destCoord.y);
        System.err.println("변환된 (Helmert 전) Longitude: " + destCoord.x);
		
        return HelmertTransformation.transform(destCoord.y, destCoord.x);
        
		// 변환된 좌표 반환 (위도, 경도)
//		return new double[] { destCoord.y, destCoord.x };
	}

	public static double[] reverseConvertProj4j(double latitude, double longitude) {
		// CRSFactory 생성
		CRSFactory crsFactory = new CRSFactory();

		// 원본 및 목적지 좌표계 설정 (WGS84 -> 중부원점)
		CoordinateReferenceSystem srcCrs = crsFactory.createFromName("EPSG:4326");
		CoordinateReferenceSystem destCrs = crsFactory.createFromName("EPSG:2097");

		// 좌표 변환을 위한 변환기 생성
		CoordinateTransformFactory ctFactory = new CoordinateTransformFactory();
		CoordinateTransform transform = ctFactory.createTransform(srcCrs, destCrs);

		// 변환할 좌표 설정
		ProjCoordinate srcCoord = new ProjCoordinate(longitude, latitude);
		ProjCoordinate destCoord = new ProjCoordinate();

		// 좌표 변환 수행
		transform.transform(srcCoord, destCoord);

		// 변환된 좌표 반환
		return new double[] { destCoord.x, destCoord.y };
	}

//	public static double[] convert(double x, double y) {
//		// CRSFactory 생성
//		CRSFactory crsFactory = new CRSFactory();
//
//		// EPSG:2097 (Bessel TM 중부원점)에서 EPSG:4326 (WGS84)로 변환할 CRS 정의
//		CoordinateReferenceSystem srcCrs = crsFactory.createFromName("EPSG:2097");
//		CoordinateReferenceSystem destCrs = crsFactory.createFromName("EPSG:4326");
//
//		// CoordinateTransformFactory를 사용해 변환기 생성
//		CoordinateTransformFactory ctFactory = new CoordinateTransformFactory();
//		CoordinateTransform transform = ctFactory.createTransform(srcCrs, destCrs);
//
//		// 변환할 좌표를 ProjCoordinate 객체로 생성
//		ProjCoordinate srcCoord = new ProjCoordinate(x, y);
//		ProjCoordinate destCoord = new ProjCoordinate();
//
//		// 변환 수행
//		transform.transform(srcCoord, destCoord);
//
//		// 변환된 좌표 반환 (위도, 경도)
//		return new double[] { destCoord.y, destCoord.x };
//	}
//	
//	// WGS84 (EPSG:4326) -> Bessel TM 중부원점 (EPSG:2097)으로 변환하는 함수
//    public static double[] reverseConvert(double lat, double lon) {
//        // CRSFactory 생성
//        CRSFactory crsFactory = new CRSFactory();
//
//        // EPSG:4326 (WGS84)에서 EPSG:2097 (Bessel TM 중부원점)으로 변환할 CRS 정의
//        CoordinateReferenceSystem srcCrs = crsFactory.createFromName("EPSG:4326");
//        CoordinateReferenceSystem destCrs = crsFactory.createFromName("EPSG:2097");
//
//        // CoordinateTransformFactory를 사용해 변환기 생성
//        CoordinateTransformFactory ctFactory = new CoordinateTransformFactory();
//        CoordinateTransform transform = ctFactory.createTransform(srcCrs, destCrs);
//
//        // 변환할 좌표를 ProjCoordinate 객체로 생성 (위도, 경도)
//        ProjCoordinate srcCoord = new ProjCoordinate(lon, lat); // 위도/경도는 일반적으로 (y, x)의 순서이므로 좌표계에 맞추어야 함
//        ProjCoordinate destCoord = new ProjCoordinate();
//
//        // 변환 수행
//        transform.transform(srcCoord, destCoord);
//
//        // 변환된 좌표 반환 (x, y)
//        return new double[] { destCoord.x, destCoord.y };
//    }
}