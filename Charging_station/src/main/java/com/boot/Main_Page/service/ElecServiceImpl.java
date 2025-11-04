package com.boot.Main_Page.service;

import java.util.ArrayList;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.Main_Page.dao.ElecDAO;
import com.boot.Main_Page.dto.ElecDTO;


@Service
public class ElecServiceImpl implements ElecService {

	@Autowired
	SqlSession sqlSession;
	
	@Override
	public ArrayList<ElecDTO> list() {
		ElecDAO dao = sqlSession.getMapper(ElecDAO.class);
		ArrayList<ElecDTO> list = dao.list();
		
		return list;
	}

}
