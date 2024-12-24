package com.gs24.website.persistence;

import java.util.Date;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.gs24.website.config.RootConfig;
import com.gs24.website.domain.PreorderVO;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {RootConfig.class})
@Log4j
public class PreorderMapperTest {
	@Autowired
	private PreorderMapper preorderMapper;
	
	@Test
	public void test() {
		delete();
	}
	
	public void insert() {
		PreorderVO preorderVO = new PreorderVO();
		preorderVO.setFoodId(1);
		preorderVO.setMemberId("test");
		preorderVO.setPreorderAmount(1);
		preorderVO.setIsPickUp(0);
		preorderVO.setIsExpiredOrder(0);
		Date date = new Date();
		preorderVO.setPickupDate(date);
		
		preorderMapper.insertPreorder(preorderVO);
	}
	
	public void update() {
		//preorderMapper.updatePreorderInIsPickUp(1, 1);
		preorderMapper.updatePreorderInIsExpiredOrder(1, 1);
	}
	
	public void select() {
		List<PreorderVO> list =  preorderMapper.selectPreoderByMemberId("test");
		log.info(list);
	}
	
	public void delete() {
		preorderMapper.deletePreorderByPreorderId(2);
	}
}
