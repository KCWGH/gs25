package com.gs24.website.controller;

import java.util.Calendar;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.gs24.website.domain.GiftCardVO;
import com.gs24.website.domain.MemberVO;
import com.gs24.website.service.GiftCardService;
import com.gs24.website.service.MemberService;
import com.gs24.website.service.RecaptchaService;

import lombok.extern.log4j.Log4j;

@Controller // @Component
@RequestMapping(value = "/auth")
@Log4j
public class AuthController {

	@Autowired
	private MemberService memberService;

	@Autowired
	private GiftCardService giftCardService;

	@Autowired
	private RecaptchaService recaptchaService;

	@GetMapping("/register")
	public String registerGET(HttpSession session) {
		log.info("registerGET()");
		if (session.getAttribute("memberId") != null) {
			log.info("이미 로그인 상태");
			return "redirect:/food/list";
		}
		log.info("로그인 페이지로 이동");
		return "/auth/register";
	}

	@PostMapping("/register")
	public String registerPOST(@ModelAttribute MemberVO memberVO, String recaptchaToken,
			RedirectAttributes redirectAttributes) {
		log.info("registerPOST()");

		boolean isRecaptchaValid = recaptchaService.verifyRecaptcha(recaptchaToken);
		if (!isRecaptchaValid) {
			log.info("reCAPTCHA 검증 실패");
			redirectAttributes.addFlashAttribute("message", "reCAPTCHA 검증에 실패했습니다. 다시 시도해주세요.");
			return "redirect:/auth/register";
		}

		int result = memberService.register(memberVO);
		log.info(result + "개 행 등록 완료");
		if (result == 1) {
			redirectAttributes.addFlashAttribute("message", "회원등록 완료.\\n\\n가입한 아이디와 비밀번호로 로그인하세요.");
			return "redirect:/auth/login";
		}
		redirectAttributes.addFlashAttribute("message", "회원등록을 실패했습니다.\\n\\n유효하지 않은 회원정보(중복된 아이디, 패스워드, 전화번호)입니다.");
		return "redirect:/auth/register";
	}

	@GetMapping("/login")
	public String loginGET(HttpSession session) {
		if (session.getAttribute("memberId") != null) {
			log.info("loginGET() - 세션이 이미 존재합니다");
			return "redirect:/food/list";
		}
		log.info("loginGET()");
		return "/auth/login";
	}

	@PostMapping("/login")
	public String loginPOST(String memberId, String password, String recaptchaToken, HttpServletRequest request,
			RedirectAttributes redirectAttributes) {
		log.info("loginPOST()");

		boolean isRecaptchaValid = recaptchaService.verifyRecaptcha(recaptchaToken);
		if (!isRecaptchaValid) {
			log.info("reCAPTCHA 검증 실패");
			redirectAttributes.addFlashAttribute("message", "reCAPTCHA 검증에 실패했습니다. 다시 시도해주세요.");
			return "redirect:/auth/login";
		}

		int result = memberService.login(memberId, password);

		if (result == 1) {
			log.info("로그인 성공");
			int isIssued = birthdayCoupon(memberId);
			if (isIssued == 1) {
				log.info("생일축하 쿠폰 발급 완료");
				redirectAttributes.addFlashAttribute("message", "생일을 축하합니다! 생일 축하 쿠폰이 발급되었습니다.");
			}
			// 세션 설정
			HttpSession session = request.getSession();
			session.setAttribute("memberId", memberId);

			MemberVO memberVO = memberService.getMember(memberId);
			session.setAttribute("memberVO", memberVO);

			session.setMaxInactiveInterval(600);

			return "redirect:/food/list";
		} else {
			log.info("로그인 실패");
			redirectAttributes.addFlashAttribute("message", "아이디와 비밀번호를 다시 확인해주세요");
			return "redirect:/auth/login";
		}
	}

	private int birthdayCoupon(String memberId) {
		Calendar currentCalendar = Calendar.getInstance();
		Calendar birthdayCalendar = Calendar.getInstance();

		Date currentDate = new Date();
		Date birthday = memberService.getMember(memberId).getBirthday();

		currentCalendar.setTime(currentDate);
		birthdayCalendar.setTime(birthday);

		int currentMonth = currentCalendar.get(Calendar.MONTH);
		int currentDay = currentCalendar.get(Calendar.DAY_OF_MONTH);
		int birthdayMonth = birthdayCalendar.get(Calendar.MONTH);
		int birthdayDay = birthdayCalendar.get(Calendar.DAY_OF_MONTH);

		int isExisting = giftCardService.birthdayGiftCardDupCheck(memberId);

		// 월과 일만 비교
		if (currentMonth == birthdayMonth && currentDay == birthdayDay && isExisting != 1) {
			GiftCardVO giftCardVO = new GiftCardVO();
			giftCardVO.setGiftCardName("생일 축하 쿠폰");
			giftCardVO.setDiscountValue(10000);
			giftCardVO.setFoodType("전체");
			giftCardVO.setMemberId(memberId);

			log.info(giftCardVO.toString());

			// 쿠폰 유효기간 설정 (현재 날짜로부터 한 달 후)
			Calendar expirationCalendar = Calendar.getInstance();
			expirationCalendar.setTime(currentDate);
			expirationCalendar.add(Calendar.MONTH, 1);
			Date oneMonthLater = expirationCalendar.getTime();
			giftCardVO.setGiftCardExpiredDate(oneMonthLater);

			return giftCardService.grantGiftCard(giftCardVO);
		}
		return 0;
	}

	@GetMapping("/login-success")
	public void loginSuccessGET() {
		log.info("loginSuccessGET");
	}

	@GetMapping("/login-fail")
	public void loginfailGET() {
		log.info("loginFailGET()");
	}

	@GetMapping("/find-id")
	public String findIdGET(HttpSession session) {
		if (session.getAttribute("memberId") != null) {
			log.info("findIdGET() - 세션이 이미 존재합니다");
			return "redirect:/food/list";
		}
		log.info("findIdGET()");
		return "/auth/find-id";
	}

	@GetMapping("/find-pw")
	public String findPwGET(HttpSession session) {
		if (session.getAttribute("memberId") != null) {
			log.info("findPwGET - 세션이 이미 존재합니다");
			return "redirect:/food/list";
		}
		log.info("findPwGET");
		return "/auth/find-pw";
	}

	@GetMapping("/logout")
	public void logout(HttpSession session) {
		session.invalidate();
		log.info("session.invalidate()");
	}
}
