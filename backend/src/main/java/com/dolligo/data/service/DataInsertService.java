package com.dolligo.data.service;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Arrays;

import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dolligo.dto.Advertiser;
import com.dolligo.dto.Markettype;
import com.dolligo.dto.Preference;
import com.dolligo.dto.User;
import com.dolligo.repository.IDataInsertRepository;

@Service
public class DataInsertService implements IDataInsertService{
	
	@Autowired
	private IDataInsertRepository repository;
	
	public void insertMarket() throws IOException {
		//엑셀 읽기
		FileInputStream file = new FileInputStream("C:\\SSAFY\\freepjt\\data\\market.xlsx");
        XSSFWorkbook workbook = new XSSFWorkbook(file);
		//데이터 insert
        
        //시트 수 (첫번째에만 존재하므로 0을 준다)
        XSSFSheet sheet=workbook.getSheetAt(0);
        //행의 수
        int rows=sheet.getPhysicalNumberOfRows();
        for(int rowindex=0;rowindex<rows;rowindex++){
            //행을읽는다
            XSSFRow row=sheet.getRow(rowindex);
            if(row !=null){
                //셀의 수
            	Markettype mt = new Markettype();
            	mt.setLargecode(row.getCell(0).toString());
            	mt.setLargename(row.getCell(1).toString());
            	mt.setMediumcode(row.getCell(2).toString());
            	mt.setMediumname(row.getCell(3).toString());
            	
            	System.out.println(mt);
            	System.out.println(repository);
            	repository.insertMarket(mt);

            }
        }
		
	}
	public void insertUser() throws IOException {
		//엑셀 읽기
		FileInputStream file = new FileInputStream("C:\\SSAFY\\freepjt\\data\\survey.xlsx");
        XSSFWorkbook workbook = new XSSFWorkbook(file);
		//데이터 insert
        
        //시트 수 (첫번째에만 존재하므로 0을 준다)
        XSSFSheet sheet=workbook.getSheetAt(0);
        //행의 수
        int rows=sheet.getPhysicalNumberOfRows();
        for(int rowindex=0;rowindex<rows;rowindex++){
            //행을읽는다
            XSSFRow row=sheet.getRow(rowindex);
            if(row !=null){
            	User user = new User();
            	//년도로 저장
//            	System.out.println(Arrays.toString(row.getCell(0).toString().split("\\.")));
            	user.setAge(2019 - Integer.parseInt(row.getCell(0).toString().split("\\.")[0]));
            	user.setGender(row.getCell(1).toString().equals("남자입니다") ? true : false);
            	user.setPoint(0);
            	repository.insertUser(user);
//            	System.out.println(user);
            	
            	for(int c = 3; c < 8; c++) {
            		if(row.getCell(c) == null) continue;
            		
            		String[] market = row.getCell(c).toString().split(", ");
            		for(int i = 0; i < market.length; i++) {
            			Preference p = new Preference();
            			p.setUid(user.getId());
//            			p.setMname(market[i].trim());//메인디비에 넣을때 주석 풀기..
            			p.setIsprefer(10);
//            			System.out.println(p);
            			repository.insertPreference(p);
            		}
            	}

            }
        }
	}
	public void insertAdvertiser() throws IOException {
		//엑셀 읽기
		FileInputStream file = new FileInputStream("C:\\SSAFY\\freepjt\\data\\advertiseraa.xlsx");
        XSSFWorkbook workbook = new XSSFWorkbook(file);
		//데이터 insert
        
        //시트 수 (첫번째에만 존재하므로 0을 준다)
        XSSFSheet sheet=workbook.getSheetAt(0);
        //행의 수
        int rows=sheet.getPhysicalNumberOfRows();
        for(int rowindex=0;rowindex<rows;rowindex++){
            //행을읽는다
            XSSFRow row=sheet.getRow(rowindex);
            if(row !=null){
            	Advertiser ad = new Advertiser();
            	ad.setMarketname(row.getCell(0).toString());
            	if(row.getCell(1) != null) ad.setMarketbranch(row.getCell(1).toString());
            	ad.setMediumcode(row.getCell(2).toString().trim());
            	ad.setMarketaddress(row.getCell(3).toString());
            	ad.setLat(row.getCell(4).toString());
            	ad.setLon(row.getCell(5).toString());
            	ad.setPoint(0);
//            	System.out.println(ad);
            	repository.insertAdvertiser(ad);
            	
            }
        }
	}
	
	public static void main(String[] args) throws IOException {
		DataInsertService dis = new DataInsertService();
		dis.insertMarket();
	}
}
