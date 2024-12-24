package com.gs24.website.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.gs24.website.domain.NoticeVO;
import com.gs24.website.util.Pagination;

@Mapper
public interface NoticeMapper {
<<<<<<< HEAD
	int insert(NoticeVO vo); // 게시글 등록
	
	List<NoticeVO> selectList(); // 전체 게시글 조회
	
	NoticeVO selectOne(int noticeId); // 특정 게시글 조회
	
	int update(NoticeVO vo); // 특정 게시글 수정
	
	int delete(int noticeId); // 특정 게시글 삭제
	
	List<NoticeVO> selectListByPagination(Pagination pagination); // 전체 게시글 페이징 처리
	
	int selectTotalCount();
}
=======
	   
		int insert(NoticeVO vo); // 寃뚯떆湲� �벑濡�
		
		List<NoticeVO> selectList(); // �쟾泥� 寃뚯떆湲� 議고쉶
		
		NoticeVO selectOne(int noticeId); // �듅�젙 寃뚯떆湲� 議고쉶
		
		int update(NoticeVO vo); // �듅�젙 寃뚯떆湲� �닔�젙
		
		int delete(int noticeId); // �듅�젙 寃뚯떆湲� �궘�젣
		
		List<NoticeVO> selectListByPagination(Pagination pagination); // �쟾泥� 寃뚯떆湲� �럹�씠吏� 泥섎━
		
		int selectTotalCount();
}
>>>>>>> 5f0e7c57d0a4abf29e5d76e4b4e2974567c8a0d7
