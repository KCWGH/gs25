package com.gs24.website.persistence;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ImgMapper {
	long selectNextReviewId();
	
	long selectNextFoodId();
}