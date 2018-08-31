package com.example.controller;

import io.lettuce.core.RedisFuture;
import io.lettuce.core.api.async.RedisAsyncCommands;
import io.lettuce.core.api.sync.RedisCommands;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import com.example.lettuce.RedisCli;
import com.example.model.User;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.mapper.UserMapper;

@Controller
public class UserController {
	
	@Autowired
	UserMapper register, login, userMapper;
	
	Logger logger = LoggerFactory.getLogger(ShopController.class);
	
	private List<User> readFromRedis() throws Exception {
		RedisAsyncCommands<String, String> asyncCommands = RedisCli.connection.async();
	
		final List<User> users = new ArrayList<User>();
		RedisFuture<List<String>> futureKeys = asyncCommands.keys("user*");
		
		List<String> keys = futureKeys.get(); //它阻塞和等待直到承诺的结果是可用状态
		
		if(keys.size()==0) return users;
		
		for(String key: keys){
			RedisFuture<Map<String, String>> futureMap = asyncCommands.hgetall(key);
			Map<String, String> map = futureMap.get(); //它阻塞和等待直到承诺的结果是可用状态
			User user = new User(); 
			user.setUserID( Integer.valueOf(map.get("userID")) );
			user.setUserPwd( map.get("userPwd"));
			user.setUserName( map.get("userName"));
			user.setUserSex( map.get("userSex"));
			user.setUserPhone( map.get("userPhone"));
			user.setUserPower( Integer.valueOf(map.get("userPower")) );
			user.setUserEmail( map.get("userEmail"));
			users.add(user);
		}
		logger.debug("----------readuser from redis-------------------");
		return users;
	}
	
	private void writeToRedis(List<User> users) {
		//RedisCommands<String, String> syncCommands = RedisCli.connection.sync();
		RedisCommands<String, String> syncCommands = RedisCli.connection.sync();
		
		for(User user: users){
			Map<String, String> map = new HashMap<String, String>();
			map.put("userID", String.valueOf(user.getUserID()));
			map.put("userPwd", user.getUserPwd());
			map.put("userName", user.getUserName());
			map.put("userSex", user.getUserSex());
			map.put("userPhone", String.valueOf(user.getUserPhone()));
			map.put("userPower", String.valueOf(user.getUserPower()));
			map.put("userEmail", user.getUserEmail());
			syncCommands.hmset("user:"+user.getUserID(), map);
		}
	}
	
	private void delFromRedis(List<User> users) {
		//RedisCommands<String, String> syncCommands = RedisCli.connection.sync();
		RedisCommands<String, String> asyncCommands = RedisCli.connection.sync();
		
		for(User user: users){
			String key = "user:"+user.getUserID();
			asyncCommands.hdel(key, "userID", "userPwd", "userName", "userSex", "userPhone", "userPower", "userEmail");

		}
	}
	
	private void updateToRedis(User user) {
		//RedisCommands<String, String> syncCommands = RedisCli.connection.sync();
		RedisCommands<String, String> syncCommands = RedisCli.connection.sync();
		
		//for(User user: users){
		String key = "user:"+user.getUserID();
		syncCommands.hdel(key, "userID", "userPwd", "userName", "userSex", "userPhone", "userPower", "userEmail");

		logger.debug("----------update from redis-------------------");
		
		Map<String, String> map = new HashMap<String, String>();
		map.put("userID", String.valueOf(user.getUserID()));
		map.put("userPwd", user.getUserPwd());
		map.put("userName", user.getUserName());
		map.put("userSex", user.getUserSex());
		map.put("userPhone", String.valueOf(user.getUserPhone()));
		map.put("userPower", String.valueOf(user.getUserPower()));
		map.put("userEmail", user.getUserEmail());
		syncCommands.hmset("user:"+user.getUserID(), map);
		//}
	}
	
	//注册
	@GetMapping("/shop/register")
	public String register(){
		return "client/register";
	}
	
	@PostMapping(value="/shop/doreg")
	public String doReg(@Valid @ModelAttribute("user") User user, BindingResult result, Model model) throws Exception{
		
		logger.debug("----------runing.........-------------------");
		List<User> users = null;
		users = readFromRedis();
		if(users.size()==0){
			logger.debug("----------readusers from database-------------------");
			users =  userMapper.findAllUser();
			writeToRedis(users);
		}
		
		int i = register.Register(user);

		if(result.hasErrors() || i<=0){
			model.addAttribute("registerMsg", "<h6 style='color:red'>错误！</h6>");
			return "client/register";
		}
		delFromRedis(users);
		users =  userMapper.findAllUser();
		writeToRedis(users);
		
		model.addAttribute("loginMsg", "<h6 style='color:red'>注册成功,请登录！</h6>");
		model.addAttribute("userName", user.getUserName());
		return "client/login";
	}
	
	//user登陆
	@GetMapping("/shop/login")
	public String login(HttpServletRequest request, Model model){
		if(request.getCookies()!=null){
			for(Cookie c:  request.getCookies()){
				if(c.getName().equals("userName")){
					String userName = c.getValue();
					model.addAttribute("userName", userName);
				}if(c.getName().equals("userPwd")){
					String userPwd = c.getValue();
					model.addAttribute("userPwd", userPwd);
				}
			}
		}
		return "client/login";
	}
	
	@SuppressWarnings("unused")
	@PostMapping("/shop/dologin")
	public String dologin(@RequestParam String userName, @RequestParam String userPwd,
			@RequestParam String Remember_password, HttpSession session, HttpServletRequest request,
			HttpServletResponse response, Model model) throws Exception{
		//System.out.println("-"+Remember_password+"-");
		logger.debug("----------runing.........-------------------");
		List<User> users = null;
		users = readFromRedis();
		if(users.size()==0){
			logger.debug("----------readusers from database-------------------");
			users =  userMapper.findAllUser();
			writeToRedis(users);
		}
		//int flag = login.Login(userName, userPwd);
		int flag = 0;
		for(User u:users){
			if(u.getUserName().equals(userName) && u.getUserPwd().equals(userPwd) && u.getUserPower() == 0){
				logger.debug("----------find user-------------------");
				flag = 1;
			}
		}
		Cookie ckUserName = null;
		Cookie ckUserPwd = null;
		if(flag==1){
			session.setAttribute("uName", userName);
			if(!"".equals(Remember_password)){
				ckUserName = new Cookie("userName", userName);
				ckUserPwd = new Cookie("userPwd", userPwd);
				ckUserName.setMaxAge(3600);
				response.addCookie(ckUserName);
				ckUserPwd.setMaxAge(3600);
				response.addCookie(ckUserPwd);
			}else if(ckUserPwd!=null){
					ckUserPwd.setMaxAge(0);
			}
			return "redirect:/shop/index";
		}else{
			model.addAttribute("loginMsg", "<h6 style='color:red'>用户名或密码错误！</h6>");
			return "client/login";
		}
	}
	
	//user注销
	@GetMapping("/shop/loginout")
	public String logout(HttpSession session){
		session.removeAttribute("uName");
		return "redirect:/shop/login";
	}
	
	//adm登陆
	@GetMapping("/shop/loginadm")
	public String admlogin(HttpServletRequest request, Model model){
		if(request.getCookies()!=null){
			for(Cookie c:  request.getCookies()){
				if(c.getName().equals("admName")){
					String admName = c.getValue();
					model.addAttribute("admName", admName);
				}if(c.getName().equals("admPwd")){
					String admPwd = c.getValue();
					model.addAttribute("admPwd", admPwd);
				}
			}
		}
		return "admin/login";
	}
	
	@SuppressWarnings("unused")
	@PostMapping("/shop/dologinadm")
	public String doadmlogin(@RequestParam String userName, @RequestParam String userPwd,
			@RequestParam String Remember_password, HttpSession session, HttpServletRequest request,
			HttpServletResponse response, Model model) throws Exception{
		//System.out.println("-"+Remember_password+"-");
		//int i = login.admLogin(userName, userPwd);
		logger.debug("----------runing.........-------------------");
		List<User> users = null;
		users = readFromRedis();
		if(users.size()==0){
			logger.debug("----------readusers from database-------------------");
			users =  userMapper.findAllUser();
			writeToRedis(users);
		}
		//int flag = login.Login(userName, userPwd);
		int flag = 0;
		for(User u:users){
			if(u.getUserName().equals(userName) && u.getUserPwd().equals(userPwd) && u.getUserPower() == 1){
				logger.debug("----------find user-------------------");
				flag = 1;
			}
		}
		Cookie ckAdmName = null;
		Cookie ckAdmPwd = null;
		if(flag==1){
			session.setAttribute("aName", userName);
			if(!"".equals(Remember_password)){
				ckAdmName = new Cookie("admName", userName);
				ckAdmPwd = new Cookie("admPwd", userPwd);
				ckAdmName.setMaxAge(3600);
				response.addCookie(ckAdmName);
				ckAdmPwd.setMaxAge(3600);
				response.addCookie(ckAdmPwd);
			}else if(ckAdmPwd!=null){
				ckAdmPwd.setMaxAge(0);
			}
			return "redirect:/shop/admgoods";
		}else{
			model.addAttribute("loginMsg", "<h6 style='color:red'>用户名或密码错误！</h6>");
			return "admin/login";
		}
	}
	
	//adm注销
	@GetMapping("/shop/loginoutadm")
	public String admloginout(HttpSession session){
		session.removeAttribute("aName");
		return "redirect:/shop/loginadm";
	}
	
	@GetMapping("/shop/info")
	public String info(HttpSession session, Model model) throws Exception{
		String uName =(String) session.getAttribute("uName");
		logger.debug("----------runing.........-------------------");
		List<User> users = null;
		users = readFromRedis();
		if(users.size()==0){
			logger.debug("----------readusers from database-------------------");
			users =  userMapper.findAllUser();
			writeToRedis(users);
		}
		for(User u:users){
			if(u.getUserName().equals(uName)){
				logger.debug("----------find user-------------------");
				model.addAttribute("user", u);
			}
		}
		return "client/info";
	}

	@PostMapping("/shop/doupdate")
	public String doupdate(@Valid @ModelAttribute("stu1") User user, BindingResult result, RedirectAttributes model) throws Exception{
		//System.out.println("-"+Remember_password+"-");
		logger.debug("----------runing.........-------------------");
		List<User> users = null;
		users = readFromRedis();
		if(users.size()==0){
			logger.debug("----------readusers from database-------------------");
			users =  userMapper.findAllUser();
			writeToRedis(users);
		}
		int i = userMapper.userUpdate(user);
		model.addFlashAttribute("userName", user.getUserName());
		if(i==1){
			updateToRedis(user);
			model.addFlashAttribute("updateMsg", "<h6 style='color:red'>成功！</h6>");
		}else{
			model.addFlashAttribute("updateMsg", "<h6 style='color:red'>失败！</h6>");
		}
		return "redirect:/shop/upinfo";
	}
	
	@RequestMapping("/shop/upinfo")
	public String home(@ModelAttribute("updateMsg") String updateMsg, @ModelAttribute("userName") String userName, Model model) throws Exception {
		logger.debug("----------runing.........-------------------");
		List<User> users = null;
		users = readFromRedis();
		if(users.size()==0){
			logger.debug("----------readusers from database-------------------");
			users =  userMapper.findAllUser();
			writeToRedis(users);
		}
		for(User u:users){
			if(u.getUserName().equals(userName)){
				logger.debug("----------find user-------------------");
				model.addAttribute("user", u);
			}
		}
		//model.addAttribute("user", userMapper.searchUser(userName));
		model.addAttribute("updateMsg", updateMsg);
		return "client/info";
	}

}
