/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50617
Source Host           : localhost:3306
Source Database       : diamonddb

Target Server Type    : MYSQL
Target Server Version : 50617
File Encoding         : 65001

Date: 2018-08-06 17:40:50
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `address`
-- ----------------------------
DROP TABLE IF EXISTS `address`;
CREATE TABLE `address` (
  `addID` int(11) NOT NULL AUTO_INCREMENT,
  `addPhone` int(11) NOT NULL,
  `addUser` varchar(16) NOT NULL,
  `addInfo` varchar(100) NOT NULL,
  `cityID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  PRIMARY KEY (`addID`),
  KEY `fk_addr_city` (`cityID`),
  KEY `fk_addr_user` (`userID`),
  CONSTRAINT `fk_addr_city` FOREIGN KEY (`cityID`) REFERENCES `city` (`cityID`),
  CONSTRAINT `fk_addr_user` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of address
-- ----------------------------
INSERT INTO `address` VALUES ('1', '1234567890', '222', '厦门市软件园观日路2号楼', '1', '2');

-- ----------------------------
-- Table structure for `buygoods`
-- ----------------------------
DROP TABLE IF EXISTS `buygoods`;
CREATE TABLE `buygoods` (
  `orderID` int(11) NOT NULL,
  `gsID` int(11) NOT NULL,
  `buyNum` int(11) NOT NULL,
  `buyPrice` float(10,2) NOT NULL,
  `buyRebate` int(11) DEFAULT NULL,
  PRIMARY KEY (`orderID`,`gsID`),
  KEY `fk_buy_gs` (`gsID`),
  CONSTRAINT `fk_buy_gs` FOREIGN KEY (`gsID`) REFERENCES `goods` (`gsID`),
  CONSTRAINT `fk_buy_ord` FOREIGN KEY (`orderID`) REFERENCES `order` (`orderID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of buygoods
-- ----------------------------
INSERT INTO `buygoods` VALUES ('1', '1', '1', '5111.00', '9');

-- ----------------------------
-- Table structure for `city`
-- ----------------------------
DROP TABLE IF EXISTS `city`;
CREATE TABLE `city` (
  `cityID` int(11) NOT NULL AUTO_INCREMENT,
  `cityName` varchar(20) NOT NULL,
  `proID` int(11) NOT NULL,
  PRIMARY KEY (`cityID`),
  KEY `cityID` (`cityID`),
  KEY `fk_city_pro` (`proID`),
  CONSTRAINT `fk_city_pro` FOREIGN KEY (`proID`) REFERENCES `province` (`proID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of city
-- ----------------------------
INSERT INTO `city` VALUES ('1', '厦门', '1');

-- ----------------------------
-- Table structure for `comment`
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `cmID` int(11) NOT NULL AUTO_INCREMENT,
  `userID` int(11) NOT NULL,
  `gsID` int(11) NOT NULL,
  `cmContent` varchar(100) DEFAULT NULL,
  `cmStar` int(11) NOT NULL,
  PRIMARY KEY (`cmID`),
  KEY `fk_com_user` (`userID`),
  KEY `fk_com_gs` (`gsID`),
  CONSTRAINT `fk_com_gs` FOREIGN KEY (`gsID`) REFERENCES `goods` (`gsID`),
  CONSTRAINT `fk_com_user` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of comment
-- ----------------------------

-- ----------------------------
-- Table structure for `feedback`
-- ----------------------------
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback` (
  `fbID` int(11) NOT NULL AUTO_INCREMENT,
  `fbName` varchar(16) NOT NULL,
  `fbEmail` varchar(50) NOT NULL,
  `fbPhone` int(11) NOT NULL,
  `fbContent` varchar(100) NOT NULL,
  PRIMARY KEY (`fbID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of feedback
-- ----------------------------

-- ----------------------------
-- Table structure for `goods`
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods` (
  `gsID` int(11) NOT NULL AUTO_INCREMENT,
  `gsName` varchar(30) NOT NULL,
  `gsImage` varchar(50) NOT NULL,
  `gsPrice` float(10,2) NOT NULL,
  `gsModel` varchar(50) DEFAULT NULL,
  `gsNum` int(11) NOT NULL,
  `typeID` int(11) NOT NULL,
  `gsColor` varchar(20) DEFAULT NULL,
  `gsSize` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`gsID`),
  KEY `fk_goods_type` (`typeID`),
  CONSTRAINT `fk_goods_type` FOREIGN KEY (`typeID`) REFERENCES `type` (`typeID`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of goods
-- ----------------------------
INSERT INTO `goods` VALUES ('1', '扭身圆钻形白色18K金镶钻石戒指', '1', '5111.00', '迫镶', '100', '1', 'F-G', '11');
INSERT INTO `goods` VALUES ('2', '扭身圆钻形白色18K金镶钻石戒指', '1', '5111.00', '迫镶', '100', '1', 'F-G', '13');
INSERT INTO `goods` VALUES ('3', '扭身圆钻形白色18K金镶钻石戒指', '1', '5111.00', '迫镶', '100', '1', 'F-G', '15');
INSERT INTO `goods` VALUES ('4', '扭身圆钻形白色18K金镶钻石戒指', '1', '5111.00', '迫镶', '100', '1', 'K-L', '11');
INSERT INTO `goods` VALUES ('5', '扭身圆钻形白色18K金镶钻石戒指', '1', '5111.00', '迫镶', '100', '1', 'K-L', '13');
INSERT INTO `goods` VALUES ('6', '扭身圆钻形白色18K金镶钻石戒指', '1', '5111.00', '迫镶', '100', '1', 'K-L', '15');
INSERT INTO `goods` VALUES ('7', '爱的阶梯PT950镶钻石戒指', '2', '2470.00', '无', '100', '1', 'F-G', '13');
INSERT INTO `goods` VALUES ('8', '白色18K金钻石戒指', '3', '4655.00', '爪镶', '100', '1', 'H', '13');
INSERT INTO `goods` VALUES ('9', '华贵时尚白18K金镶钻石戒指', '4', '3781.00', '爪镶', '100', '1', 'D-E', '13');
INSERT INTO `goods` VALUES ('10', '时尚简约18K金钻石戒指', '5', '1330.00', '爪镶', '100', '1', 'D-E', '13');
INSERT INTO `goods` VALUES ('11', '璀璨白色18K金镶钻石戒指', '6', '3990.00', '微镶', '100', '1', 'D-E', '11');
INSERT INTO `goods` VALUES ('12', '白色18K金钻石戒指', '7', '3135.00', '微镶', '100', '1', 'D-E', '11');
INSERT INTO `goods` VALUES ('13', '华丽PT900铂金镶钻石戒指', '8', '113000.00', '无', '5', '1', 'I-J', '13');
INSERT INTO `goods` VALUES ('14', '豪雅18K金镶坦桑石钻石戒指', '9', '9800.00', '爪镶', '5', '1', 'I-J', '13');
INSERT INTO `goods` VALUES ('15', '华丽白色18K金镶钻石戒指', '10', '91700.00', '无', '3', '1', 'I-J', '13');
INSERT INTO `goods` VALUES ('16', '迪士尼公主天鹅18K金镶钻石吊坠', '11', '1710.00', '圆钻形', '100', '2', null, '40cm');
INSERT INTO `goods` VALUES ('17', '爱情羽毛系列玫瑰色18K金镶钻石吊坠', '12', '703.00', '微镶', '100', '2', null, '40cm');
INSERT INTO `goods` VALUES ('18', '真心之翼PT950铂金镶钻石吊坠', '13', '2090.00', '爪镶', '100', '2', null, '40cm');
INSERT INTO `goods` VALUES ('19', 'G&W系列简约时尚钻石吊坠', '14', '1380.00', '无', '100', '2', null, '40cm');
INSERT INTO `goods` VALUES ('20', '星愿系列黄色18K金星星钻石项链', '15', '1805.00', '无', '100', '2', null, '40cm');
INSERT INTO `goods` VALUES ('21', '骄人系列圆形18K金钻石项链', '16', '3781.00', '包边镶', '100', '2', null, '40cm');
INSERT INTO `goods` VALUES ('22', '怦然系列巴黎铁塔18K金镶钻石吊坠', '17', '5035.00', '微镶', '100', '2', null, '40cm');
INSERT INTO `goods` VALUES ('23', '怦然系列海豚爱心18K金镶钻石吊坠', '18', '3135.00', '爪镶', '100', '2', null, '40cm');
INSERT INTO `goods` VALUES ('24', 'G&W 系列PT950铂金镶钻石项链', '19', '3325.00', '无', '100', '2', null, '40cm');
INSERT INTO `goods` VALUES ('25', '小心意十字架18K玫瑰金镶钻石项链', '20', '3325.00', '微镶', '100', '2', null, '40cm');
INSERT INTO `goods` VALUES ('26', '水中花系列PT950铂金镶钻石耳钉', '21', '2945.00', '无', '100', '3', null, '0.9cm*1.4cm');
INSERT INTO `goods` VALUES ('27', '星愿系列18K金镶钻石耳环耳线', '22', '1900.00', '无', '100', '3', null, '3.5cm*0.9cm');
INSERT INTO `goods` VALUES ('28', '迪士尼公主系列雪花白色18K金镶钻石耳环', '23', '3895.00', '爪镶', '100', '3', null, '1.03cm*2.6cm');
INSERT INTO `goods` VALUES ('29', '时尚花形白色18K金镶钻石耳钉', '24', '3895.00', '爪镶', '100', '3', null, '0.6cm*1.75cm');
INSERT INTO `goods` VALUES ('30', '闪耀之花18K金镶钻石耳钉', '25', '3515.00', '迫镶', '100', '3', null, '0.72cm*0.72cm');
INSERT INTO `goods` VALUES ('31', '爱情羽毛系列玫瑰色18K金钻石耳钉', '26', '1800.00', '微镶', '100', '3', null, '1.2cm*0.5cm');
INSERT INTO `goods` VALUES ('32', 'T MARK TOUCH系列18K金钻石耳饰', '27', '15600.00', '爪镶', '100', '3', null, '1.5cm*0.9cm');
INSERT INTO `goods` VALUES ('33', '清新花朵 925银钻石耳钉', '28', '931.00', '无', '100', '3', null, '1.4cm*0.7cm');
INSERT INTO `goods` VALUES ('34', '心心相印18K金钻石耳钉', '29', '2090.00', '爪镶', '100', '3', null, '1.5cm*0.8cm');
INSERT INTO `goods` VALUES ('35', 'Ringism系列时尚18K金钻石耳饰', '30', '2565.00', '爪镶', '10', '3', null, '1.5cm*0.6cm');
INSERT INTO `goods` VALUES ('36', '星愿系列精美18K金钻石手链', '31', '1520.00', '无', '100', '4', null, '16.5cm');
INSERT INTO `goods` VALUES ('37', 'TRI-Light系列精致玫瑰色18K金钻石手链', '32', '2755.00', '爪镶', '100', '4', null, '17.5cm');
INSERT INTO `goods` VALUES ('38', '简约心相印18K金钻石手链', '33', '2280.00', '爪镶', '100', '4', null, '18.5cm');
INSERT INTO `goods` VALUES ('39', '钥匙情人节18K玫瑰金钻石粉红手绳', '34', '1710.00', '微镶', '100', '4', null, '19.5cm');
INSERT INTO `goods` VALUES ('40', 'SOINLOVE爱蜜系列 几何图形18K金钻石手链', '35', '4600.00', '爪镶', '100', '4', null, '21.5cm');
INSERT INTO `goods` VALUES ('41', '四叶草粉红情人节款18K玫瑰金手绳', '36', '1330.00', '微镶', '100', '4', null, '20.5cm');
INSERT INTO `goods` VALUES ('42', '小心意红绳款-盼你18K金钻石手链', '37', '2470.00', '微镶', '100', '4', null, '22.5cm');
INSERT INTO `goods` VALUES ('43', '小心意系列Y时代玫瑰色18K金钻石手链', '38', '2565.00', '微镶', '100', '4', null, '23.5cm');
INSERT INTO `goods` VALUES ('44', 'PT G&W系列简约时尚钻石PT950手链', '39', '1580.00', '无', '100', '4', null, '24.5cm');
INSERT INTO `goods` VALUES ('45', 'MONOLOGUE系列十字架9K金钻石手链', '40', '2498.00', '无', '100', '4', null, '25.5cm');

-- ----------------------------
-- Table structure for `order`
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order` (
  `orderID` int(11) NOT NULL AUTO_INCREMENT,
  `addID` int(11) NOT NULL,
  `shipID` int(11) NOT NULL,
  `payID` int(11) NOT NULL,
  PRIMARY KEY (`orderID`),
  KEY `fk_order_addr` (`addID`),
  KEY `fk_order_ship` (`shipID`),
  KEY `fk_order_pay` (`payID`),
  CONSTRAINT `fk_order_addr` FOREIGN KEY (`addID`) REFERENCES `address` (`addID`),
  CONSTRAINT `fk_order_pay` FOREIGN KEY (`payID`) REFERENCES `paymothod` (`payID`),
  CONSTRAINT `fk_order_ship` FOREIGN KEY (`shipID`) REFERENCES `shipmothod` (`shipID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of order
-- ----------------------------
INSERT INTO `order` VALUES ('1', '1', '1', '2');

-- ----------------------------
-- Table structure for `paymothod`
-- ----------------------------
DROP TABLE IF EXISTS `paymothod`;
CREATE TABLE `paymothod` (
  `payID` int(11) NOT NULL AUTO_INCREMENT,
  `payName` varchar(20) NOT NULL,
  PRIMARY KEY (`payID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of paymothod
-- ----------------------------
INSERT INTO `paymothod` VALUES ('1', '在线支付');
INSERT INTO `paymothod` VALUES ('2', '货到付款');

-- ----------------------------
-- Table structure for `province`
-- ----------------------------
DROP TABLE IF EXISTS `province`;
CREATE TABLE `province` (
  `proID` int(11) NOT NULL AUTO_INCREMENT,
  `proName` varchar(20) NOT NULL,
  PRIMARY KEY (`proID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of province
-- ----------------------------
INSERT INTO `province` VALUES ('1', '福建');

-- ----------------------------
-- Table structure for `shipmothod`
-- ----------------------------
DROP TABLE IF EXISTS `shipmothod`;
CREATE TABLE `shipmothod` (
  `shipID` int(11) NOT NULL AUTO_INCREMENT,
  `shipName` varchar(20) NOT NULL,
  PRIMARY KEY (`shipID`),
  KEY `shipID` (`shipID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of shipmothod
-- ----------------------------
INSERT INTO `shipmothod` VALUES ('1', '顺丰快递');
INSERT INTO `shipmothod` VALUES ('2', '中通快递');

-- ----------------------------
-- Table structure for `shopcart`
-- ----------------------------
DROP TABLE IF EXISTS `shopcart`;
CREATE TABLE `shopcart` (
  `gsID` int(11) NOT NULL,
  `cartNum` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  PRIMARY KEY (`gsID`),
  KEY `fk_car_user` (`userID`),
  CONSTRAINT `fk_car_gs` FOREIGN KEY (`gsID`) REFERENCES `goods` (`gsID`),
  CONSTRAINT `fk_car_user` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of shopcart
-- ----------------------------
INSERT INTO `shopcart` VALUES ('1', '1', '2');

-- ----------------------------
-- Table structure for `type`
-- ----------------------------
DROP TABLE IF EXISTS `type`;
CREATE TABLE `type` (
  `typeID` int(11) NOT NULL AUTO_INCREMENT,
  `typeName` varchar(16) NOT NULL,
  PRIMARY KEY (`typeID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of type
-- ----------------------------
INSERT INTO `type` VALUES ('1', '戒指');
INSERT INTO `type` VALUES ('2', '项链');
INSERT INTO `type` VALUES ('3', '耳环');
INSERT INTO `type` VALUES ('4', '手链');

-- ----------------------------
-- Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `userID` int(11) NOT NULL AUTO_INCREMENT,
  `userPwd` varchar(20) DEFAULT NULL,
  `userName` varchar(16) DEFAULT NULL,
  `userSex` varchar(2) DEFAULT NULL,
  `userPhone` varchar(11) NOT NULL,
  `userPower` int(11) NOT NULL,
  `userEmail` varchar(50) NOT NULL,
  PRIMARY KEY (`userID`),
  UNIQUE KEY `uname` (`userName`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', '111', '111', '男', '1234567891', '1', '111@admin.com');
INSERT INTO `user` VALUES ('2', '222', '222', '女', '1234567890', '0', '222@user.com');
INSERT INTO `user` VALUES ('21', '333', '333', '女', '123123123', '0', '12@qq.cn');
