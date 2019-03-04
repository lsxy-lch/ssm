package com.entor.dao.impl;

import org.springframework.stereotype.Repository;

import com.entor.dao.ClassesDao;
import com.entor.entity.Classes;

@Repository("classesDao")
public class ClassesDaoImpl extends BaseDaoImpl<Classes> implements ClassesDao{

}
