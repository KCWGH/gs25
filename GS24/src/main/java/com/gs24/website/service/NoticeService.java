package com.gs24.website.service;

import java.util.List;


import com.gs24.website.domain.NoticeVO;
import com.gs24.website.util.Pagination;

public interface NoticeService {
<<<<<<< HEAD
	int createNotice(NoticeVO noticeVO); // 게시글 등록
	
	List<NoticeVO> getAllNotice(); // 전체 게시글 조회
	
	NoticeVO getNoticeById(int noticeId); // 특정 게시글 조회
	
	int updateNotice(NoticeVO noticeVO); // 특정 게시글 수정
	
	int deleteNotice(int noticeId); // 특정 게시글 삭제
	
	List<NoticeVO>  getPagingNotices(Pagination pagination); // 전체 게시글 페이징 처리
	
	int getTotalCount();
=======
	int createNotice(NoticeVO noticeVO); // 寃뚯떆湲� �벑濡�
	//createNotice	
	List<NoticeVO> getAllNotice(); // �쟾泥� 寃뚯떆湲� 議고쉶
	//getAllNotice
	NoticeVO getNoticeById(int noticeId); // �듅�젙 寃뚯떆湲� 議고쉶
	// getNoticeById
	int updateNotice(NoticeVO noticeVO); // �듅�젙 寃뚯떆湲� �닔�젙
	// updateNotice
	int deleteNotice(int noticeId); // �듅�젙 寃뚯떆湲� �궘�젣
	// deleteNotice
	List<NoticeVO>  getPagingNotices(Pagination pagination); // �쟾泥� 寃뚯떆湲� �럹�씠吏� 泥섎━
	
	int getTotalCount();
	
	

>>>>>>> 5f0e7c57d0a4abf29e5d76e4b4e2974567c8a0d7
}
