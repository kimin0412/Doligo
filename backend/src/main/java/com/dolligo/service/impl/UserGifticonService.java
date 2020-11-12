package com.dolligo.service.impl;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dolligo.dto.Gifticon;
import com.dolligo.dto.GifticonPurchase;
import com.dolligo.dto.PointLog;
import com.dolligo.dto.User;
import com.dolligo.exception.ApplicationException;
import com.dolligo.repository.IGifticonPurchaseRepository;
import com.dolligo.repository.IGifticonRepository;
import com.dolligo.repository.IPointLogRepository;
import com.dolligo.repository.IUserRepository;
import com.dolligo.service.IUserGifticonService;

@Service
public class UserGifticonService implements IUserGifticonService {

	@Autowired
	private IUserRepository uRepo;
	@Autowired
	private IGifticonRepository giftRepo;
	@Autowired
	private IPointLogRepository plRepo;
	@Autowired
	private IGifticonPurchaseRepository giftPurchaseRepo;

	// 기프티콘 목록 가져오기
	@Override
	public List<Gifticon> getAllGifticons(int cid) {
		return giftRepo.findAllValidGift(cid);
	}

	// 기프티콘 상세 조회
	@Override
	public Gifticon getGifticon(int gid) {
		Optional<Gifticon> tmp = giftRepo.findById(gid);
		if (!tmp.isPresent()) {
			throw new ApplicationException("기프티콘 정보 찾을 수 없음");
		}
		Gifticon gift = tmp.get();

		if (gift.getValidDate().isBefore(LocalDate.now())) {
			throw new ApplicationException("유효기한이 지난 기프티콘");
		}

		return gift;
	}

	// 기프티콘 구매
	@Override
	public PointLog purchaseGifticon(String uid, int gid) {
		// 내가 가진 포인트보다 비싼 기프티콘 구매 시도 => 오류
		User user = uRepo.findById(Integer.parseInt(uid)).get();

		Optional<Gifticon> tmp = giftRepo.findById(gid);
		if (!tmp.isPresent()) {
			throw new ApplicationException("기프티콘 정보 찾을 수 없음");
		}
		Gifticon gift = tmp.get();

//		if(gift.isPurchase()) {
//			throw new ApplicationException("이미 구매된 기프티콘입니다.");
//		}
		if (gift.getStock() == 0) {
			throw new ApplicationException("기프티콘 재고가 없습니다.");
		}

		if (user.getPoint() < gift.getPrice()) {
			throw new ApplicationException("보유한 포인트 초과해서 기프티콘 구매 시도");
		}

//		gift.setPurchase(true);//구매 체크
		gift.setStock(gift.getStock() - 1); //재고수량 -1
		giftRepo.save(gift);

		GifticonPurchase gp = new GifticonPurchase();
		gp.setGid(gift.getId());
		gp.setUid(Integer.parseInt(uid));
		giftPurchaseRepo.save(gp);

		user.setPoint(user.getPoint() - gift.getPrice());

		// 포인트 내역 추가
		PointLog pl = new PointLog();
		pl.setDescription("기프티콘 구매");
		pl.setPoint(gift.getPrice());
		pl.setTotalPoint(user.getPoint());
		pl.setSid(2);// 기프티콘 구매로 포인트 차감
		pl.setSource(gift.getId());
		pl.setUid(Integer.parseInt(uid));
		plRepo.save(pl);

		return pl;
	}

	@Override
	public List<GifticonPurchase> getPurchaseList(int uid) {
		List<GifticonPurchase> list = giftPurchaseRepo.selectPurchaseList(uid);
		return list;
	}

}
