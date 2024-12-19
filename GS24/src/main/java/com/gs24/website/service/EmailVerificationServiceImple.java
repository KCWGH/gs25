package com.gs24.website.service;

import java.util.Properties;
import java.util.Random;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gs24.website.domain.EmailVerificationVO;
import com.gs24.website.persistence.EmailVerificationMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class EmailVerificationServiceImple implements EmailVerificationService {

	@Autowired
	private EmailVerificationMapper emailVerificationMapper;

	@Override
	@Transactional
	public void sendVerificationCode(String email) throws Exception {
		// 인증번호 생성
		String verificationCode = generateVerificationCode();
		// 이메일 인증 정보를 저장
		EmailVerificationVO verification = new EmailVerificationVO();
		verification.setEmail(email);
		verification.setVerificationCode(verificationCode);
		emailVerificationMapper.insertVerificationCode(verification);
		log.info("요귀임");
		sendEmail(email, verificationCode);
	}

	// 인증번호 생성 (6자리 랜덤 숫자)
	private String generateVerificationCode() {
		Random random = new Random();
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < 6; i++) {
			sb.append(random.nextInt(10));
		}
		return sb.toString();
	}

	// 이메일 전송
	private void sendEmail(String email, String verificationCode) throws MessagingException {
		// 메일 서버 설정
		String host = "smtp.naver.com";
		String port = "587";
		String from = "nmbgsp95@naver.com";
		String username = "nmbgsp95@naver.com";
		String password = "1aledma2!A";

		Properties properties = new Properties();
		properties.put("mail.smtp.host", host);
		properties.put("mail.smtp.port", port);
		properties.put("mail.smtp.auth", "true");
		properties.put("mail.smtp.starttls.enable", "true");

		Session session = Session.getInstance(properties, new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		});

		MimeMessage message = new MimeMessage(session);
		message.setFrom(new InternetAddress(from));
		message.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
		message.setSubject("<GS24> 이메일 인증번호");
		message.setText("요청하신 인증번호는 " + verificationCode + " 입니다.");

		Transport.send(message);
	}

	@Override
	public String verifyCodeAndFindMemberId(String email, String verificationCode) {
		// 인증번호가 맞는지 확인 후 회원 ID 찾기
		String memberId = emailVerificationMapper.selectMemberIdByVerificationCode(email, verificationCode);
		return memberId;
	}

	@Override
	public int verifyCodeAndFindPw(String memberId, String email, String verificationCode) {
		int result = emailVerificationMapper.selectIsExistByMemberIdAndEmailAndCode(memberId, email, verificationCode);
		return result;
	}
}