package com.gs24.website.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.gs24.website.domain.MemberVO;
import com.gs24.website.domain.NoticeVO;
import com.gs24.website.service.NoticeService;
import com.gs24.website.util.PageMaker;
import com.gs24.website.util.Pagination;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping(value = "/notice")
@Log4j
public class NoticeController {
	
	@Autowired
	private NoticeService noticeService;
	
<<<<<<< HEAD
	// 전체 게시글 데이터를 list.jsp 페이지로 전송
		@GetMapping("/list")
		public void list(Model model, Pagination pagination, HttpSession session) {
		    log.info("list()");
		    log.info("pagination = " + pagination);
		    
		    // 세션에서 memberVO 가져오기
		    MemberVO memberVO = (MemberVO) session.getAttribute("memberVO");

		    // memberVO가 null이면 경고 로그 출력
		    if (memberVO == null) {
		    	log.warn("세션에 memberVO가 존재하지 않습니다. 로그인 필요.");
		    }
		 // 공지사항 목록 가져오기
		    List<NoticeVO> noticeList = noticeService.getPagingNotices(pagination);	
		    
		    // 페이지 메이커 생성
		    PageMaker pageMaker = new PageMaker();
		    pageMaker.setPagination(pagination);
		    pageMaker.setTotalCount(noticeService.getTotalCount());
		    
		    // 모델에 값 추가
		    model.addAttribute("pageMaker", pageMaker);
		    model.addAttribute("noticeList", noticeList);
		    // 세션에서 가져온 memberVO를 모델에 추가
		    model.addAttribute("memberVO", memberVO); // memberVO를 JSP로 전달
		}
		
		// register.jsp 호출
		@GetMapping("/register")
		public void registerGET() {
			log.info("registerGET()");
		}
		
		// register.jsp에서 전송받은 게시글 데이터를 저장
		@PostMapping("/register")
		public String registerPOST(NoticeVO noticeVO) {
			log.info("registerPOST()");
			log.info("noticeVO = " + noticeVO.toString());
			int result = noticeService.createNotice(noticeVO);
			return "redirect:/notice/list";
		}
		
		// list.jsp에서 선택된 게시글 번호를 바탕으로 게시글 상세 조회
		// 조회된 게시글 데이터를 detail.jsp로 전송
		@GetMapping("/detail")
		public void detail(Model model, Integer noticeId) {
			log.info("detail()");
			NoticeVO noticeVO = noticeService.getNoticeById(noticeId);
			model.addAttribute("noticeVO", noticeVO); 
		}
		
		// 게시글 번호를 전송받아 상세 게시글 조회
		// 조회된 게시글 데이터를 modify.jsp로 전송
		@GetMapping("/modify")
		public void modifyGET(Model model, Integer noticeId) {
			log.info("modifyGET()");
			NoticeVO noticeVO = noticeService.getNoticeById(noticeId);
			model.addAttribute("noticeVO", noticeVO);
		}
		
		// modify.jsp에서 데이터를 전송받아 게시글 수정
		@PostMapping("/modify")
		public String modifyPOST(NoticeVO noticeVO) {
			log.info("modifyPOST()");
			int result = noticeService.updateNotice(noticeVO);
			log.info(result + "행 수정");
			return "redirect:/notice/list";
		}
		
		// detail.jsp에서 boardId를 전송받아 게시글 데이터 삭제
		@PostMapping("/delete")
		public String delete(Integer noticeId) {
		    log.info("delete()");
		    int result = noticeService.deleteNotice(noticeId);
		    log.info(result + "행 삭제");
		    return "redirect:/notice/list";
		}
}

=======
	// �쟾泥� 寃뚯떆湲� �뜲�씠�꽣瑜� list.jsp �럹�씠吏�濡� �쟾�넚
	@GetMapping("/list")
	public void list(Model model, Pagination pagination, HttpSession session) {
	    log.info("list()");
	    log.info("pagination = " + pagination);
	    
	    // �꽭�뀡�뿉�꽌 memberVO 媛��졇�삤湲�
	    MemberVO memberVO = (MemberVO) session.getAttribute("memberVO");
	    
	    // memberVO媛� null�씠硫� 寃쎄퀬 濡쒓렇 異쒕젰
	    if (memberVO == null) {
	        log.warn("�꽭�뀡�뿉 memberVO媛� 議댁옱�븯吏� �븡�뒿�땲�떎. 濡쒓렇�씤 �븘�슂.");
	    }
	    
	    // 怨듭���궗�빆 紐⑸줉 媛��졇�삤湲�
	    List<NoticeVO> noticeList = noticeService.getPagingNotices(pagination);

	    // �럹�씠吏� 硫붿씠而� �깮�꽦
	    PageMaker pageMaker = new PageMaker();
	    pageMaker.setPagination(pagination);
	    pageMaker.setTotalCount(noticeService.getTotalCount());

	    // 紐⑤뜽�뿉 媛� 異붽��
	    model.addAttribute("pageMaker", pageMaker);
	    model.addAttribute("noticeList", noticeList);
	    
	    // �꽭�뀡�뿉�꽌 媛��졇�삩 memberVO瑜� 紐⑤뜽�뿉 異붽��
	    model.addAttribute("memberVO", memberVO); // memberVO瑜� JSP濡� �쟾�떖
	}
	
	// register.jsp �샇異�
	@GetMapping("/register")
	public void registerGET() {
		log.info("registerGET()");
	}
	
	// register.jsp�뿉�꽌 �쟾�넚諛쏆�� 寃뚯떆湲� �뜲�씠�꽣瑜� ����옣
	@PostMapping("/register")
	public String registerPOST(NoticeVO noticeVO) {
		log.info("registerPOST()");
		log.info("noticeVO = " + noticeVO.toString());
		int result = noticeService.createNotice(noticeVO);
		log.info(result + "�뻾 �벑濡� ");
		return "redirect:/notice/list";
	}
	
	// list.jsp�뿉�꽌 �꽑�깮�맂 寃뚯떆湲� 踰덊샇瑜� 諛뷀깢�쑝濡� 寃뚯떆湲� �긽�꽭 議고쉶
	// 議고쉶�맂 寃뚯떆湲� �뜲�씠�꽣瑜� detail.jsp濡� �쟾�넚
	@GetMapping("/detail")
	public void detail(Model model, Integer noticeId) {
		log.info("detail()");
		NoticeVO noticeVO = noticeService.getNoticeById(noticeId);
		model.addAttribute("noticeVO", noticeVO); 
	}
	
	// 寃뚯떆湲� 踰덊샇瑜� �쟾�넚諛쏆븘 �긽�꽭 寃뚯떆湲� 議고쉶
	// 議고쉶�맂 寃뚯떆湲� �뜲�씠�꽣瑜� modify.jsp濡� �쟾�넚
	@GetMapping("/modify")
	public void modifyGET(Model model, Integer noticeId) {
		log.info("modifyGET()");
		NoticeVO noticeVO = noticeService.getNoticeById(noticeId);
		model.addAttribute("noticeVO", noticeVO);
	}
	
	// modify.jsp�뿉�꽌 �뜲�씠�꽣瑜� �쟾�넚諛쏆븘 寃뚯떆湲� �닔�젙
	@PostMapping("/modify")
	public String modifyPOST(NoticeVO noticeVO) {
		log.info("modifyPOST()");
		int result = noticeService.updateNotice(noticeVO);
		log.info(result + "�뻾 �닔�젙");
		return "redirect:/notice/list";
	}
	
	// detail.jsp�뿉�꽌 boardId瑜� �쟾�넚諛쏆븘 寃뚯떆湲� �뜲�씠�꽣 �궘�젣
	@PostMapping("/delete")
	public String delete(Integer noticeId) {
	    log.info("delete()");
	    int result = noticeService.deleteNotice(noticeId);
	    log.info(result + "�뻾 �궘�젣");
	    return "redirect:/notice/list";
	}
}
>>>>>>> 5f0e7c57d0a4abf29e5d76e4b4e2974567c8a0d7
