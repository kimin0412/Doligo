package com.dolligo.data.service;

import java.io.FileInputStream;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dolligo.dto.Advertiser;
import com.dolligo.dto.AdvertiserAnalysis;
import com.dolligo.dto.Markettype;
import com.dolligo.dto.Paper;
import com.dolligo.dto.Paperanalysis;
import com.dolligo.dto.Paperstate;
import com.dolligo.dto.Preference;
import com.dolligo.dto.State;
import com.dolligo.dto.User;
import com.dolligo.repository.IDataInsertRepository;
import com.dolligo.repository.IPaperAnalysisRepository;
import com.dolligo.repository.IPaperRepository;
import com.dolligo.repository.IPaperStateRepository;
import com.dolligo.service.IAdvertiserPaperService;
import com.dolligo.service.IUserPaperService;
import com.dolligo.service.IUserService;

@Service
public class DataInsertService implements IDataInsertService{
	
	@Autowired
	private IDataInsertRepository repository;
	@Autowired
	private IPaperRepository pRepo;
	@Autowired
	private IPaperStateRepository psRepo;
	@Autowired
	private IPaperAnalysisRepository paRepo;
	
	@Autowired
	private IUserService userService;
	
	@Autowired
	private IAdvertiserPaperService atpaperService;
	
	@Autowired
	private IUserPaperService upaperService;
	
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
            	user.setAge(2021 - Integer.parseInt(row.getCell(0).toString().split("\\.")[0]));
            	user.setGender(row.getCell(1).toString().equals("남자입니다") ? false : true);
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
	
	//20대 이외 연령대 유저 데이터 생성
	@Override
	public void insertOtherUser() throws Exception {
		//D F L N O P Q R
		User user;
		List<String> prefers = new ArrayList<String>();
//		boolean[] prefer = new boolean[8];
//		//10대 여자 100
//		prefers.add("D");
//		prefers.add("N");
//		prefers.add("Q");
//		prefers.add("R");
//		for(int i = 0; i < 100; i++) {
//			user = new User();
//			user.setGender(true);
//			user.setAge(2005);//16살..
//			user.setPrefercode(prefers);
//			userService.add(user);
//		}
//		
//		
//		//10대 남자 100
//		prefers = new ArrayList<String>();
//		prefers.add("D");
//		prefers.add("N");
//		prefers.add("P");
//		prefers.add("R");
//		for(int i = 0; i < 100; i++) {
//			user = new User();
//			user.setGender(false);
//			user.setAge(2005);//16살..
//			user.setPrefercode(prefers);
//			userService.add(user);
//		}
//		
//		//30대 여자 100
//		prefers = new ArrayList<String>();
//		prefers.add("D");
//		prefers.add("F");
//		prefers.add("N");
//		prefers.add("O");
//		prefers.add("Q");
//		for(int i = 0; i < 100; i++) {
//			user = new User();
//			user.setGender(true);
//			user.setAge(1985);//36살..
//			user.setPrefercode(prefers);
//			userService.add(user);
//		}
//		//30대 남자 100
//		prefers = new ArrayList<String>();
//		prefers.add("L");
//		prefers.add("N");
//		prefers.add("O");
//		prefers.add("P");
//		prefers.add("Q");
//		for(int i = 0; i < 100; i++) {
//			user = new User();
//			user.setGender(false);
//			user.setAge(1985);//36살..
//			user.setPrefercode(prefers);
//			userService.add(user);
//		}
//
//		
//		//40대 여자 200
//		prefers = new ArrayList<String>();
//		prefers.add("D");
//		prefers.add("F");
//		prefers.add("L");
//		prefers.add("N");
//		prefers.add("Q");
//		prefers.add("R");
//		for(int i = 0; i < 200; i++) {
//			user = new User();
//			user.setGender(true);
//			user.setAge(1975);//46살..
//			user.setPrefercode(prefers);
//			userService.add(user);
//		}
//		//40대 남자 100
//		prefers = new ArrayList<String>();
//		prefers.add("L");
//		prefers.add("N");
//		prefers.add("P");
//		prefers.add("Q");
//		prefers.add("R");
//		for(int i = 0; i < 100; i++) {
//			user = new User();
//			user.setGender(false);
//			user.setAge(1975);//46살..
//			user.setPrefercode(prefers);
//			userService.add(user);
//		}
		
		//50대 여자 50
		prefers = new ArrayList<String>();
		prefers.add("D");
		prefers.add("F");
		prefers.add("L");
		prefers.add("P");
		prefers.add("Q");
		prefers.add("R");
		for(int i = 0; i < 100; i++) {
			user = new User();
			user.setGender(true);
			user.setAge(1965);//56살..
			user.setPrefercode(prefers);
			userService.add(user);
		}
		//50대 남자 50
		prefers = new ArrayList<String>();
		prefers.add("L");
		prefers.add("N");
		prefers.add("P");
		for(int i = 0; i < 100; i++) {
			user = new User();
			user.setGender(false);
			user.setAge(1965);//56살..
			user.setPrefercode(prefers);
			userService.add(user);
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
	
	public void insertPaper() throws IOException {
		//엑셀 읽기
		FileInputStream file = new FileInputStream("C:\\SSAFY\\freepjt\\data\\paper.xlsx");
        XSSFWorkbook workbook = new XSSFWorkbook(file);
		//데이터 insert
        //시트 수 (첫번째에만 존재하므로 0을 준다)
        XSSFSheet sheet=workbook.getSheetAt(0);
        
        for(int i = 1; i < 95; i++) {
        	List<Advertiser> ads = repository.getAds(i);//i번째 mtid에 해당하는 광고주 목록
        	XSSFRow row=sheet.getRow(i);
        	Paper p = new Paper();
        	Paperanalysis pa = new Paperanalysis();
        	
        	p.setP_mtid(i);
        	p.setP_point(15);
        	p.setP_image(row.getCell(2).toString());
        	if(row.getCell(5) != null) p.setP_coupon(row.getCell(5).toString());
        	System.out.println(p);
        	for(Advertiser ad : ads) {
        		//aid, lat, lon, sheets(1000)
        		p.setP_aid(ad.getId());
        		p.setLat(ad.getLat());
        		p.setLon(ad.getLon());
        		p.setSheets(1000);
        		
        		repository.insertPaper(p);
        		repository.insertPaperAnalysis(p.getP_id());
        	}
        }
	}
	
	//전단지별 유저 액션 데이터 입력
	@Override
	public void insertUserAction() throws Exception {
		//유흥주점 등록
		//10대 삭제 및 차단, 제외
		//전 연령대 고루고루2,3,4 많이 5 적게
		//user 데이터를 연령대 별로 쭉 가져와서 상태값 저장
		/*
		 * 10개 paper
		 * 시간대 : 12,16,17,18,19,20,21,22,23,0,1
		 */
		
//		2011~2002 (10~19)
		List<User> ones = repository.selectUsers(2002,2011);
//		2001~1992 (20~29)
		List<User> twos = repository.selectUsers(1992,2001);
//		1991~1982 (30~39)
		List<User> threes = repository.selectUsers(1982,1991);
//		1981~1972 (40~49)
		List<User> fours = repository.selectUsers(1972,1981);
//		1971~1962 (50~59)
		List<User> fives = repository.selectUsers(1962,1971);
		
		
		//paper
		List<Paper> paper = pRepo.findAllByP_aid("30");
		
		Paper p = paper.get(0);
		Paperanalysis pa = paRepo.findByPid(p.getP_id());
		
		//12시
		//20대
//		for(User u : twos) {
//			Paperstate ps = new Paperstate();
//			ps.setPid(p.getP_id());
//			ps.setUid(u.getId());
//			psRepo.save(ps);//paper당 user paperstate 저장
//			
//			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
//			paRepo.save(pa);
//			
//
//			State s = new State();
//			s.setAge(u.getAge());
//			s.setGender(u.isGender());
//			s.setPid(p.getP_id());
//			
//			int n = (int)(Math.random()*10000 + 1);
//			if(n < 5000) s.setState(1);
//			else s.setState(2);
//			
//			upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
////			atpaperService.authQrcode("30", s);//qr인증
//		}
		
		//30대
//		for(User u : threes) {
//			Paperstate ps = new Paperstate();
//			ps.setPid(p.getP_id());
//			ps.setUid(u.getId());
//			psRepo.save(ps);//paper당 user paperstate 저장
//			
//			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
//			paRepo.save(pa);
//			
//
//			State s = new State();
//			s.setAge(u.getAge());
//			s.setGender(u.isGender());
//			s.setPid(p.getP_id());
//			
//			int n = (int)(Math.random()*10000 + 1);
//			if(n < 7000) s.setState(1);
//			else s.setState(2);
//			
//			upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
////			atpaperService.authQrcode("30", s);//qr인증
//		}
		
	
//		p = paper.get(3);
//		pa = paRepo.findByPid(p.getP_id());
//		//16시~18시
//		//10대
//		for(User u : ones) {
//			if(u.getId() % 10 != 0) continue;
//			Paperstate ps = new Paperstate();
//			ps.setPid(p.getP_id());
//			ps.setUid(u.getId());
//			psRepo.save(ps);//paper당 user paperstate 저장
//			
//			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
//			paRepo.save(pa);
//			
//			
//			State s = new State();
//			s.setAge(u.getAge());
//			s.setGender(u.isGender());
//			s.setPid(p.getP_id());
//			
//			int n = (int)(Math.random()*10000 + 1);
//			if(n < 6000) s.setState(1);
//			else s.setState(4);
//			
//			upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
////			atpaperService.authQrcode("30", s);//qr인증
//		}
//		//20대
//		for(User u : twos) {
//			Paperstate ps = new Paperstate();
//			ps.setPid(p.getP_id());
//			ps.setUid(u.getId());
//			psRepo.save(ps);//paper당 user paperstate 저장
//			
//			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
//			paRepo.save(pa);
//			
//			
//			State s = new State();
//			s.setAge(u.getAge());
//			s.setGender(u.isGender());
//			s.setPid(p.getP_id());
//			s.setUid(u.getId());
//			
//			int n = (int)(Math.random()*10000 + 1);
//			if(n < 2000) s.setState(1);
//			else if(n < 8500) s.setState(2);
//			else if(n < 9000) s.setState(4);
//			else s.setState(3);
//			
//			if(s.getState() == 3) atpaperService.authQrcode("30", s);//qr인증
//			else upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
//		}
//		//30대
//		for(User u : threes) {
////			if(psRepo.findByUidAndPid(p.getP_id(), Integer.toString(u.getId())) != null) {
////				System.out.println(u.getId());
////				continue;
////			}
////			else {
////				System.out.println(u.getId());
////				return;
////			}
//			Paperstate ps = new Paperstate();
//			ps.setPid(p.getP_id());
//			ps.setUid(u.getId());
//			psRepo.save(ps);//paper당 user paperstate 저장
//			
//			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
//			paRepo.save(pa);
//			
//			
//			State s = new State();
//			s.setAge(u.getAge());
//			s.setGender(u.isGender());
//			s.setPid(p.getP_id());
//			s.setUid(u.getId());
//			
//			int n = (int)(Math.random()*10000 + 1);
//			if(n < 3000) s.setState(1);
//			else if(n < 8000) s.setState(2);
//			else if(n < 9000) s.setState(4);
//			else s.setState(3);
//			
//			if(s.getState() == 3) atpaperService.authQrcode("30", s);//qr인증
//			else upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
//		}
//		//40대
//		for(User u : fours) {
//			if(u.getId() % 2 == 0) continue;
//			Paperstate ps = new Paperstate();
//			ps.setPid(p.getP_id());
//			ps.setUid(u.getId());
//			psRepo.save(ps);//paper당 user paperstate 저장
//			
//			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
//			paRepo.save(pa);
//			
//			
//			State s = new State();
//			s.setAge(u.getAge());
//			s.setGender(u.isGender());
//			s.setPid(p.getP_id());
//			s.setUid(u.getId());
//			
//			int n = (int)(Math.random()*10000 + 1);
//			if(n < 4000) s.setState(1);
//			else if(n < 8000) s.setState(2);
//			else if(n > 8500) s.setState(4);
//			else s.setState(3);
//			
//			if(s.getState() == 3) atpaperService.authQrcode("30", s);//qr인증
//			else upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
//		}
//		//50대
//		for(User u : fives) {
//			Paperstate ps = new Paperstate();
//			ps.setPid(p.getP_id());
//			ps.setUid(u.getId());
//			psRepo.save(ps);//paper당 user paperstate 저장
//			
//			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
//			paRepo.save(pa);
//			
//			
//			State s = new State();
//			s.setAge(u.getAge());
//			s.setGender(u.isGender());
//			s.setPid(p.getP_id());
//			s.setUid(u.getId());
//			
//			int n = (int)(Math.random()*10000 + 1);
//			if(n < 4000) s.setState(1);
//			else if(n < 7000) s.setState(2);
//			else if(n > 8500) s.setState(4);
//			else s.setState(3);
//			
//			if(s.getState() == 3) atpaperService.authQrcode("30", s);//qr인증
//			else upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
//		}
		
		
		
//		p = paper.get(7);
//		pa = paRepo.findByPid(p.getP_id());
//		//19~22시
//		//10대
//		for(User u : ones) {
//			if(u.getId() % 20 != 0) continue;
//			Paperstate ps = new Paperstate();
//			ps.setPid(p.getP_id());
//			ps.setUid(u.getId());
//			psRepo.save(ps);//paper당 user paperstate 저장
//			
//			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
//			paRepo.save(pa);
//			
//			
//			State s = new State();
//			s.setAge(u.getAge());
//			s.setGender(u.isGender());
//			s.setPid(p.getP_id());
//			
//			int n = (int)(Math.random()*10000 + 1);
//			if(n < 7000) s.setState(1);
//			else s.setState(4);
//			
//			upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
////			atpaperService.authQrcode("30", s);//qr인증
//		}
//		//20대
//		for(User u : twos) {
//			Paperstate ps = new Paperstate();
//			ps.setPid(p.getP_id());
//			ps.setUid(u.getId());
//			psRepo.save(ps);//paper당 user paperstate 저장
//			
//			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
//			paRepo.save(pa);
//			
//			
//			State s = new State();
//			s.setAge(u.getAge());
//			s.setGender(u.isGender());
//			s.setPid(p.getP_id());
//			s.setUid(u.getId());
//			
//			int n = (int)(Math.random()*10000 + 1);
//			if(n < 1000) s.setState(1);
//			else if(n < 6500) s.setState(2);
//			else if(n > 9500) s.setState(4);
//			else s.setState(3);
//			
//			if(s.getState() == 3) atpaperService.authQrcode("30", s);//qr인증
//			else upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
//		}
//		//30대
//		for(User u : threes) {
//			Paperstate ps = new Paperstate();
//			ps.setPid(p.getP_id());
//			ps.setUid(u.getId());
//			psRepo.save(ps);//paper당 user paperstate 저장
//			
//			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
//			paRepo.save(pa);
//			
//			
//			State s = new State();
//			s.setAge(u.getAge());
//			s.setGender(u.isGender());
//			s.setPid(p.getP_id());
//			s.setUid(u.getId());
//			
//			int n = (int)(Math.random()*10000 + 1);
//			if(n < 2000) s.setState(1);
//			else if(n < 7000) s.setState(2);
//			else if(n > 9000) s.setState(4);
//			else s.setState(3);
//			
//			if(s.getState() == 3) atpaperService.authQrcode("30", s);//qr인증
//			else upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
//		}
//		//40대
//		for(User u : fours) {
//			Paperstate ps = new Paperstate();
//			ps.setPid(p.getP_id());
//			ps.setUid(u.getId());
//			psRepo.save(ps);//paper당 user paperstate 저장
//			
//			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
//			paRepo.save(pa);
//			
//			
//			State s = new State();
//			s.setAge(u.getAge());
//			s.setGender(u.isGender());
//			s.setPid(p.getP_id());
//			s.setUid(u.getId());
//			
//			int n = (int)(Math.random()*10000 + 1);
//			if(u.isGender()) {
//				if(n < 4000) s.setState(1);
//				else if(n < 8000) s.setState(2);
//				else if(n > 9000) s.setState(4);
//				else s.setState(3);
//			}else {
//				if(n < 2000) s.setState(1);
//				else if(n < 6000) s.setState(2);
//				else if(n > 9500) s.setState(4);
//				else s.setState(3);
//			}
//			if(s.getState() == 3) atpaperService.authQrcode("30", s);//qr인증
//		else upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
//		}
//		//50대
//		for(User u : fives) {
//			Paperstate ps = new Paperstate();
//			ps.setPid(p.getP_id());
//			ps.setUid(u.getId());
//			psRepo.save(ps);//paper당 user paperstate 저장
//			
//			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
//			paRepo.save(pa);
//			
//			
//			State s = new State();
//			s.setAge(u.getAge());
//			s.setGender(u.isGender());
//			s.setPid(p.getP_id());
//			s.setUid(u.getId());
//			
//			int n = (int)(Math.random()*10000 + 1);
//			if(n < 3000) s.setState(1);
//			else if(n < 6000) s.setState(2);
//			else if(n > 9000) s.setState(4);
//			else s.setState(3);
//			
//			if(s.getState() == 3) atpaperService.authQrcode("30", s);//qr인증
//			else upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
//		}
		
		
//		p = paper.get(9);
//		pa = paRepo.findByPid(p.getP_id());
//		//23~0시
//		//10대
//		for(User u : ones) {
//			if(u.getId() % 20 != 0) continue;
//			Paperstate ps = new Paperstate();
//			ps.setPid(p.getP_id());
//			ps.setUid(u.getId());
//			psRepo.save(ps);//paper당 user paperstate 저장
//			
//			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
//			paRepo.save(pa);
//			
//			
//			State s = new State();
//			s.setAge(u.getAge());
//			s.setGender(u.isGender());
//			s.setPid(p.getP_id());
//			
//			int n = (int)(Math.random()*10000 + 1);
//			if(n < 7000) s.setState(1);
//			else s.setState(4);
//			
//			upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
////			atpaperService.authQrcode("30", s);//qr인증
//		}
//		//20대
//		for(User u : twos) {
//			Paperstate ps = new Paperstate();
//			ps.setPid(p.getP_id());
//			ps.setUid(u.getId());
//			psRepo.save(ps);//paper당 user paperstate 저장
//			
//			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
//			paRepo.save(pa);
//			
//			
//			State s = new State();
//			s.setAge(u.getAge());
//			s.setGender(u.isGender());
//			s.setPid(p.getP_id());
//			s.setUid(u.getId());
//			
//			int n = (int)(Math.random()*10000 + 1);
//			if(n < 1000) s.setState(1);
//			else if(n < 7000) s.setState(2);
//			else if(n > 9500) s.setState(4);
//			else s.setState(3);
//			
//			if(s.getState() == 3) atpaperService.authQrcode("30", s);//qr인증
//			else upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
//		}
//		//30대
//		for(User u : threes) {
//			Paperstate ps = new Paperstate();
//			ps.setPid(p.getP_id());
//			ps.setUid(u.getId());
//			psRepo.save(ps);//paper당 user paperstate 저장
//			
//			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
//			paRepo.save(pa);
//			
//			
//			State s = new State();
//			s.setAge(u.getAge());
//			s.setGender(u.isGender());
//			s.setPid(p.getP_id());
//			s.setUid(u.getId());
//			
//			int n = (int)(Math.random()*10000 + 1);
//			if(n < 2000) s.setState(1);
//			else if(n < 7500) s.setState(2);
//			else if(n > 9500) s.setState(4);
//			else s.setState(3);
//			
//			if(s.getState() == 3) atpaperService.authQrcode("30", s);//qr인증
//			else upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
//		}
//		//40대
//		for(User u : fours) {
//			Paperstate ps = new Paperstate();
//			ps.setPid(p.getP_id());
//			ps.setUid(u.getId());
//			psRepo.save(ps);//paper당 user paperstate 저장
//			
//			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
//			paRepo.save(pa);
//			
//			
//			State s = new State();
//			s.setAge(u.getAge());
//			s.setGender(u.isGender());
//			s.setPid(p.getP_id());
//			s.setUid(u.getId());
//			
//			int n = (int)(Math.random()*10000 + 1);
//			if(u.isGender()) {
//				if(n < 4000) s.setState(1);
//				else if(n < 8000) s.setState(2);
//				else if(n > 9000) s.setState(4);
//				else s.setState(3);
//			}else {
//				if(n < 2000) s.setState(1);
//				else if(n < 7500) s.setState(2);
//				else if(n > 9500) s.setState(4);
//				else s.setState(3);
//			}
//			if(s.getState() == 3) atpaperService.authQrcode("30", s);//qr인증
//		else upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
//		}
//		//50대
//		for(User u : fives) {
//			Paperstate ps = new Paperstate();
//			ps.setPid(p.getP_id());
//			ps.setUid(u.getId());
//			psRepo.save(ps);//paper당 user paperstate 저장
//			
//			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
//			paRepo.save(pa);
//			
//			
//			State s = new State();
//			s.setAge(u.getAge());
//			s.setGender(u.isGender());
//			s.setPid(p.getP_id());
//			s.setUid(u.getId());
//			
//			int n = (int)(Math.random()*10000 + 1);
//			if(n < 3000) s.setState(1);
//			else if(n < 8000) s.setState(2);
//			else if(n > 9000) s.setState(4);
//			else s.setState(3);
//			
//			if(s.getState() == 3) atpaperService.authQrcode("30", s);//qr인증
//			else upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
//		}
		
		
		////////////////////////////////////////////////////////////////////////////////////
		
		
		//연극,영화,극장 등록
		//10,20,30 대 많이
		//40 여자 많이
		//40~50 적게
		/*
		 * 10개 paper
		 * 시간대 : 10,11,12,13,14,15,16,17,18,19,20
		 */
		
		
		//성인오락, 경마
		//40,50 남자 많이
		//10 차단
		//20,30 & 40대 여자 삭제 및 차단 가끔 조회해서 포인트
		/*
		 * 10개 paper
		 * 시간대 : 17,18,19,20,20,21,21,22,22,23
		 */
		
		paper = pRepo.findAllByP_aid("776");
		
//		p = paper.get(4);
//		pa = paRepo.findByPid(p.getP_id());
//		
//		//17~20시
//		//20대
//		for(User u : twos) {
//			Paperstate ps = new Paperstate();
//			ps.setPid(p.getP_id());
//			ps.setUid(u.getId());
//			psRepo.save(ps);//paper당 user paperstate 저장
//			
//			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
//			paRepo.save(pa);
//			
//			
//			State s = new State();
//			s.setAge(u.getAge());
//			s.setGender(u.isGender());
//			s.setPid(p.getP_id());
//			s.setUid(u.getId());
//			
//			int n = (int)(Math.random()*10000 + 1);
//			if(u.isGender()) {
//				if(n < 5500) s.setState(1);
//				else if(n < 6000) s.setState(2);
//				else if(n > 6300) s.setState(4);
//				else s.setState(3);
//			}else {
//				if(n < 3000) s.setState(1);
//				else if(n < 6000) s.setState(2);
//				else if(n > 7000) s.setState(4);
//				else s.setState(3);
//			}
//			
//			if(s.getState() == 3) atpaperService.authQrcode("776", s);//qr인증
//			else upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
//		}
//		//30대
//		for(User u : threes) {
//			Paperstate ps = new Paperstate();
//			ps.setPid(p.getP_id());
//			ps.setUid(u.getId());
//			psRepo.save(ps);//paper당 user paperstate 저장
//			
//			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
//			paRepo.save(pa);
//			
//			
//			State s = new State();
//			s.setAge(u.getAge());
//			s.setGender(u.isGender());
//			s.setPid(p.getP_id());
//			s.setUid(u.getId());
//			
//			int n = (int)(Math.random()*10000 + 1);
//			if(u.isGender()) {
//				if(n < 5500) s.setState(1);
//				else if(n < 6000) s.setState(2);
//				else if(n > 6300) s.setState(4);
//				else s.setState(3);
//			}else {
//				if(n < 3000) s.setState(1);
//				else if(n < 6500) s.setState(2);
//				else if(n > 7500) s.setState(4);
//				else s.setState(3);
//			}
//			
//			if(s.getState() == 3) atpaperService.authQrcode("776", s);//qr인증
//			else upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
//		}
//		//40대
//		for(User u : fours) {
//			Paperstate ps = new Paperstate();
//			ps.setPid(p.getP_id());
//			ps.setUid(u.getId());
//			psRepo.save(ps);//paper당 user paperstate 저장
//			
//			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
//			paRepo.save(pa);
//			
//			
//			State s = new State();
//			s.setAge(u.getAge());
//			s.setGender(u.isGender());
//			s.setPid(p.getP_id());
//			s.setUid(u.getId());
//			
//			int n = (int)(Math.random()*10000 + 1);
//			if(u.isGender()) {
//				if(n < 5000) s.setState(1);
//				else if(n < 6000) s.setState(2);
//				else if(n > 6500) s.setState(4);
//				else s.setState(3);
//			}else {
//				if(n < 4000) s.setState(1);
//				else if(n < 8000) s.setState(2);
//				else if(n > 8500) s.setState(4);
//				else s.setState(3);
//			}
//			if(s.getState() == 3) atpaperService.authQrcode("776", s);//qr인증
//			else upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
//		}
//		//50대
//		for(User u : fives) {
//			Paperstate ps = new Paperstate();
//			ps.setPid(p.getP_id());
//			ps.setUid(u.getId());
//			psRepo.save(ps);//paper당 user paperstate 저장
//			
//			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
//			paRepo.save(pa);
//			
//			
//			State s = new State();
//			s.setAge(u.getAge());
//			s.setGender(u.isGender());
//			s.setPid(p.getP_id());
//			s.setUid(u.getId());
//			
//			int n = (int)(Math.random()*10000 + 1);
//			if(u.isGender()) {
//				if(n < 5500) s.setState(1);
//				else if(n < 6500) s.setState(2);
//				else if(n > 7000) s.setState(4);
//				else s.setState(3);
//			}else {
//				if(n < 3000) s.setState(1);
//				else if(n < 7000) s.setState(2);
//				else if(n > 9000) s.setState(4);
//				else s.setState(3);
//			}
//			
//			if(s.getState() == 3) atpaperService.authQrcode("776", s);//qr인증
//			else upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
//		}
		
		
		
		p = paper.get(9);
		pa = paRepo.findByPid(p.getP_id());
		
		//21~23시
		//20대
		for(User u : twos) {
			Paperstate ps = new Paperstate();
			ps.setPid(p.getP_id());
			ps.setUid(u.getId());
			psRepo.save(ps);//paper당 user paperstate 저장
			
			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
			paRepo.save(pa);
			
			
			State s = new State();
			s.setAge(u.getAge());
			s.setGender(u.isGender());
			s.setPid(p.getP_id());
			s.setUid(u.getId());
			
			int n = (int)(Math.random()*10000 + 1);
			if(u.isGender()) {
				if(n < 5500) s.setState(1);
				else if(n < 6000) s.setState(2);
				else if(n > 6300) s.setState(4);
				else s.setState(3);
			}else {
				if(n < 3000) s.setState(1);
				else if(n < 6000) s.setState(2);
				else if(n > 7000) s.setState(4);
				else s.setState(3);
			}
			
			if(s.getState() == 3) atpaperService.authQrcode("776", s);//qr인증
			else upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
		}
		//30대
		for(User u : threes) {
			Paperstate ps = new Paperstate();
			ps.setPid(p.getP_id());
			ps.setUid(u.getId());
			psRepo.save(ps);//paper당 user paperstate 저장
			
			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
			paRepo.save(pa);
			
			
			State s = new State();
			s.setAge(u.getAge());
			s.setGender(u.isGender());
			s.setPid(p.getP_id());
			s.setUid(u.getId());
			
			int n = (int)(Math.random()*10000 + 1);
			if(u.isGender()) {
				if(n < 5000) s.setState(1);
				else if(n < 6000) s.setState(2);
				else if(n > 6500) s.setState(4);
				else s.setState(3);
			}else {
				if(n < 3000) s.setState(1);
				else if(n < 6500) s.setState(2);
				else if(n > 7500) s.setState(4);
				else s.setState(3);
			}
			
			if(s.getState() == 3) atpaperService.authQrcode("776", s);//qr인증
			else upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
		}
		//40대
		for(User u : fours) {
			Paperstate ps = new Paperstate();
			ps.setPid(p.getP_id());
			ps.setUid(u.getId());
			psRepo.save(ps);//paper당 user paperstate 저장
			
			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
			paRepo.save(pa);
			
			
			State s = new State();
			s.setAge(u.getAge());
			s.setGender(u.isGender());
			s.setPid(p.getP_id());
			s.setUid(u.getId());
			
			int n = (int)(Math.random()*10000 + 1);
			if(u.isGender()) {
				if(n < 5000) s.setState(1);
				else if(n < 6000) s.setState(2);
				else if(n > 6500) s.setState(4);
				else s.setState(3);
			}else {
				if(n < 2000) s.setState(1);
				else if(n < 6500) s.setState(2);
				else if(n > 9500) s.setState(4);
				else s.setState(3);
			}
			if(s.getState() == 3) atpaperService.authQrcode("776", s);//qr인증
			else upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
		}
		//50대
		for(User u : fives) {
			Paperstate ps = new Paperstate();
			ps.setPid(p.getP_id());
			ps.setUid(u.getId());
			psRepo.save(ps);//paper당 user paperstate 저장
			
			pa.setDistributed(pa.getDistributed() + 1);//pa distributed ++
			paRepo.save(pa);
			
			
			State s = new State();
			s.setAge(u.getAge());
			s.setGender(u.isGender());
			s.setPid(p.getP_id());
			s.setUid(u.getId());
			
			int n = (int)(Math.random()*10000 + 1);
			if(u.isGender()) {
				if(n < 5500) s.setState(1);
				else if(n < 6500) s.setState(2);
				else if(n > 7000) s.setState(4);
				else s.setState(3);
			}else {
				if(n < 2000) s.setState(1);
				else if(n < 6000) s.setState(2);
				else if(n > 9500) s.setState(4);
				else s.setState(3);
			}
			
			if(s.getState() == 3) atpaperService.authQrcode("776", s);//qr인증
			else upaperService.saveState(Integer.toString(u.getId()), s);//삭제 or 차단 or 상세조회
		}
		
		
	}
	
}
