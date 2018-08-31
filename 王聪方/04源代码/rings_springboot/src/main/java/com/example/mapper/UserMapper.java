package com.example.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.example.model.User;

public interface  UserMapper {
	int Register(User user);
	int RegUserName(String userName);
	int Login(@Param("userName")String userName, @Param("userPwd")String userPwd);
	int admLogin(@Param("userName")String userName, @Param("userPwd")String userPwd);

	User searchUser(String uName);
	List<User> findAllUser();
	int userUpdate(User user);
}
