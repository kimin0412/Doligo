package com.dolligo.service;

import java.util.List;

import com.dolligo.dto.Gifticon;
import com.dolligo.dto.GifticonPurchase;
import com.dolligo.dto.PointLog;

public interface IUserGifticonService {
	
	//아직 구매 안된 기프티콘 목록 조회
	public List<Gifticon> getAllGifticons(int cid);
	
	//기프티콘 상세 조회
	public Gifticon getGifticon(int gid);
	
	//기프티콘 구매목록에서 상세 조회
	GifticonPurchase getGifticonDetail(int uid, int id);
	
	//기프티콘 구매
	public PointLog purchaseGifticon(String uid, int gid);
	
	//기프티콘 구매 목록 조회
	public List<GifticonPurchase> getPurchaseList(int uid);

}
