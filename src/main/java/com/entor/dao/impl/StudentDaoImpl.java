package com.entor.dao.impl;

import org.springframework.stereotype.Repository;

import com.entor.dao.StudentDao;
import com.entor.entity.Student;

@Repository("studentDao")
public class StudentDaoImpl extends BaseDaoImpl<Student> implements StudentDao{

}
