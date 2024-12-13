package com.gs24.website.domain;

import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import lombok.extern.log4j.Log4j;

@NoArgsConstructor
@Getter
@Setter
@ToString
@Log4j
public class ImgFoodVO {
	private int ImgFoodId;
	private int foodId;
	private String ImgFoodPath;
	private String ImgFoodRealName;
	private String ImgFoodChgName;
	private String ImgFoodExtention;
	private Date ImgFoodDateCreated;
	private MultipartFile file;
}
