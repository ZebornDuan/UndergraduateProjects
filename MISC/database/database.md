# 数据库

## 数据库的概念与分类

### 数据库的概念

顾名思义，数据库就是“存放数据的仓库”。数据库是按照一定的数据结构（数据结构是指数据的组织形式或数据之间的联系）来组织、存储的，可以通过数据库提供的多种方式来管理数据库里的数据。目前提到的数据库通常是指具备上述特征的软件，这些软件将数据将数据保存到文件或内存，并接收特定的命令，然后对文件进行相应的操作。有了这些软件，无须自己再去创建文件和文件夹，而是直接传递*命令*给上述软件，让其来进行文件操作，他们统称为数据库管理系统（DBMS，Database Management System）

### 数据库的分类

按照数据库的数据集合的关系可以将数据库分为**关系型数据库**和**非关系型数据库**。常用的关系型数据库有MySQL、SQL Server、Oracle等，常用的非关系型数据库有MongoDB、Redis、CouchDB等。通常关系型数据库对数据的管理在磁盘等持久化存储设备上进行，而非关系型数据库对数据的管理可以在内存上进行，因此也可以按照操作数据的存储介质对数据库进行分类，持久化存储的数据库可以和缓存数据库结合使用。

关系型数据库把复杂的数据结构归结为简单的二元关系（即二维表格形式）。在关系数据库中，对数据的操作几乎全部建立在一个或多个关系表格上，通过对这些关联表的表格分类、合并、连接或选取等运算来实现数据的管理。

非关系型数据库也被称为NoSQL数据库，NoSQL的是“NOT only SQL”的简写，指的是非关系型数据库。NoSQL作为传统关系型数据库的一个有效补充，NoSQL数据库在特定的场景下可以发挥出难以想象的高效率和高性能。

非关系型数据库的种类：
- 键值（key-value）存储数据库

```
键值数据库就类似传统语言中使用的哈希表。可以通过key来添加、查询或者删除数据，因为使用key主键访问，所以会获得很高的性能及扩展性。

键值（Key-Value）数据库主要是使用一个哈希表，这个表中有一个特定的键和一个指针指向特定的数据。Key/value模型对于IT系统来说的优势在于简单、易部署、高并发。

典型产品：Memcached、Redis、MemcacheDB、Berkeley DB。
```

- 列存储（column-oriented）数据库

```
列存储数据库将数据存在列族（column family）中，一个列族存储经常被一起查询的相关数据。举个例子，如果我们有一个Person类，我们通常会一起查询他们的姓名和年龄，而不是薪资。这种情况下，姓名和年龄就会被放入一个列族中，而薪资则在另外一个列族中。

这部分数据库通常是用来应对分布式存储的海量数据。键仍然存在，但是他们的特点是指向了多个列。这些列是由列家族来安排的。

典型产品：Hbase、Cassandra
```

- 面向文档数据库

```
文档型数据库的灵感是来自于Lotus Notes办公软件的，而且它同第一种键值存储相类似。该类型的数据模型是版本化的文档，半结构化的文档以特定的格式存储，比如JSON。文档型数据库可以看作是键值数据库的升级版，允许之间嵌套键值。而且文档型数据库比键值数据库的查询效率更高。

面向文档数据库会将数据以文档的形式存储。每个文档都是自包含的数据单元，是一系列数据项的集合。每个数据项都有一个名称与对应的值，值既可以是简单的数据类型，如字符串、数字和日期等；也可以是复杂的类型，如有序列表和关联对象。数据存储的最小单位是文档，同一个表中存储的文档属性可以是不同的，数据可以使用XML、JSON或者JSONB等多种形式存储。

典型产品：MongoDB、CouchDB
```

- 图形数据库

```
图形数据库允许我们将数据已图的方式存储。实体会被作为定点，而实体之间的关系则会被作为边。比如我们有三个实体，Steve Jobs，Apple和Next，则会有两个”Founded By”的边将Apple和Next连接到Steve Jobs。

图形结构的数据库同其他行列以及刚性结构的SQL数据库不同，它是使用灵活的图形模型，并且能扩展到多个服务器上。NoSQL数据库没有标准的查询语言(SQL)，因此进行数据库查询需要制定数据模型。许多NoSQL数据库都有REST式的数据接口或者查询API。

典型的产品有：Neo4J、InfoGrid。
```

该部分参考资料：
[数据库介绍及分类](http://blog.51cto.com/13178102/2064041)
[SQL 和 NoSQL 的区别](https://www.cnblogs.com/jeakeven/p/5402095.html)

## SQL

数据库软件可以接受命令，并做出相应的操作，由于命令中可以包含删除文件、获取文件内容等众多操作，对于编写的命令就是是SQL语句。SQL语句是结构化语言（Structured Query Language）的缩写，SQL是一种专门用来与数据库通信的语言。

SQL的关键字通常不区分字母的大小写，而表名和字段名这些语句参数是否区分大小写不同的数据库有不同的配置，但是通常使用SQL语句时对关键字采用大写字母，对语句参数采用小写字母。一条完整的语句之后需要以';'作为结尾。

### SQL命令清单
以下命令适用于关系型数据库，可以在MySQL数据库上进行验证。

#### 数据库操作

```
显示数据库 SHOW DATABASES;
使用数据库 USE db_name;
显示所有表 SHOW TABLES;

用户管理
    创建用户
        CREATE USER '用户名'@'IP地址' IDENTIFIED BY '密码';
    删除用户
        DROP USER '用户名'@'IP地址';
    修改用户
        RENAME USER '用户名'@'IP地址'; TO '新用户名'@'IP地址';;
    修改密码
        SET PASSWORD FOR '用户名'@'IP地址' = PASSWORD('新密码');
权限管理
    查看权限
        SHOW GRANTS FOR '用户'@'IP地址';
    授权并创建密码
        GRANT 权限 ON 数据库.表 TO '用户'@'IP地址' IDENTIFIED BY '密码';
    取消权限
        REVOKE 权限 ON 数据库.表 FROM '用户'@'IP地址';
数据库范围表示
    数据库名.*           数据库中的所有
    数据库名.表          指定数据库中的某张表
    数据库名.存储过程     指定数据库中的存储过程
    *.*                 所有数据库
用户范围表示
    用户名@IP地址         用户只能在该IP下才能访问
    用户名@192.168.1.%   用户只能在该IP段下才能访问(通配符%表示任意)
    用户名@%             用户可以在任意IP下访问(默认IP地址为%)
```
数据库中的权限可以参考[MySQL的 Grant命令权限分配](http://www.cnblogs.com/rmbteam/archive/2011/10/20/2219368.html)。

#### 表操作

创建表
```
CREATE TABLE 表名(
    列名  类型  约束，
    列名  类型  约束
    ...
);

约束：
    1. 是否可空
         NOT NULL    - 不可空
         NULL        - 可空（也用NULL表示空值）
    2. 默认值DEFAULT
        默认值，创建列时可以指定默认值，当插入数据时如果未主动设置，则自动添加默认值
        实例：
        CREATE TABLE tb1(
            nid INT NOT NULL DEFAULT 2,
            num INT NOT NULL
        ) 
    3. 自增AUTO_INCREMENT
        自增，如果为某列设置自增列，插入数据时无需设置此列，默认将自增（表中只能有一个自增列）。对于自增列，必须是索引（含主键）。自增可以设置步长和起始值。设置语句为
            SHOW SESSION VARIABLES LIKE 'auto_inc%';
            SET SESSION AUTO_INCREMENT_INCREMENT=2;
            SET SESSION AUTO_INCREMENT_OFFSET=10;

            SHOW global VARIABLES LIKE 'auto_inc%';
            SET global AUTO_INCREMENT_INCREMENT=2;
            SET global AUTO_INCREMENT_OFFSET=10;
        实例：
        CREATE TABLE tb1(
            nid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
            num INT NULL
        )
        或
        CREATE TABLE tb1(
            nid INT NOT NULL AUTO_INCREMENT,
            num INT NULL,
            INDEX(nid)
        )
    4. 主键PRIMARY KEY
        主键，一种特殊的唯一索引，不允许有空值，如果主键使用单个列，则它的值必须唯一，如果是多列，则其组合必须唯一。
        实例：
        CREATE TABLE tb1(
            nid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
            num INT NULL
        )
    
        CREATE TABLE tb1(
            nid INT NOT NULL,
            num INT NOT NULL,
            PRIMARY KEY(nid,num)
        )
    5. 唯一键UNIQUE KEY
        实例：
        CREATE TABLE tb1(
            nid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
            num INT NULL UNIQUE KEY,
        )
    6. 外键FOREIGN KEY
        外键的定义为：如果公共关键字在一个关系中是主关键字，那么这个公共关键字被称为另一个关系的外键，一个关系的外键作主关键字的表被称为主表，具有此外键的表被称为主表的从表。
        设置外键的作用是保证数据的完整性和一致性。
        实例：
        CREATE TABLE color(
            nid INT NOT NULL PRIMARY KEY,
            name CHAR(16) NOT NULL
        )
        CREATE TABLE fruit(
            nid INT NOT NULL PRIMARY KEY,
            smt CHAR(32) NULL ,
            color_id INT NOT NULL,
            CONSTRAINT fk_cc FOREIGN KEY (color_id) REFERENCES color(nid)
        )
```
数据库的数据类型可以参考：[MySQL 数据类型](http://www.runoob.com/mysql/mysql-data-types.html)

关于数据库表的约束与关键字可以参考：

[数据库的主键和外键](https://www.cnblogs.com/buptlyn/p/4555206.html)--介绍了主键外键的作用以及主键的设计原则

[外键及其约束理解](https://www.cnblogs.com/chenxiaohei/p/6909318.html)--介绍了三种外键的on delete约束

[主键（PRIMARY KEY）和唯一索引（unique index）区别](https://blog.csdn.net/qq_26222859/article/details/52469504)

删除表

`DROP TABLE 表名`

清空表
```
DELETE FROM 表名
TRUNCATE TABLE 表名  #和上面的区别在于，这条语句能够使自增id恢复到0
```

修改表
```
    添加列：ALTER TABLE 表名 ADD 列名 类型
    删除列：ALTER TABLE 表名 DROP COLUMN 列名
    修改列：
        ALTER TABLE 表名 MODIFY COLUMN 列名 类型;  -- 类型
        ALTER TABLE 表名 CHANGE 原列名 新列名 类型; -- 列名，类型
  
    添加主键：
        ALTER TABLE 表名 ADD PRIMARY KEY(列名);
    删除主键：
        ALTER TABLE 表名 DROP PRIMARY KEY;
        ALTER TABLE 表名  MODIFY  列名 INT, DROP PRIMARY KEY;
  
    添加外键：ALTER TABLE 从表 ADD constraINT 外键名称（形如：FK_从表_主表） FOREIGN KEY 从表(外键字段) REFERENCES 主表(主键字段);
    删除外键：ALTER TABLE 表名 DROP FOREIGN KEY 外键名称
  
    修改默认值：ALTER TABLE testALTER_tbl ALTER i SET DEFAULT 1000;
    删除默认值：ALTER TABLE testALTER_tbl ALTER i DROP DEFAULT;
```

#### 数据操作

增加数据
```
INSERT INTO 表 (列名,列名...) VALUES (值,值,值...)
INSERT INTO 表 (列名,列名...) VALUES (值,值,值...),(值,值,值...)
INSERT INTO 表 (列名,列名...) SELECT (列名,列名...) FROM 表
```

删除数据
```
DELETE FROM 表
DELETE FROM 表 WHERE id＝1 AND name＝'alex'
```

修改数据

```
UPDATE 表 SET name ＝ 'alex' WHERE id>1
```

查询数据

```
SELECT * FROM 表
SELECT * FROM 表 WHERE id > 1
SELECT nid,name,gender AS people FROM 表 WHERE id > 1
```

其他
```
1、条件
    SELECT * FROM 表 WHERE id > 1 AND name != 'alex' AND num = 12;

    SELECT * FROM 表 WHERE id between 5 AND 16;

    SELECT * FROM 表 WHERE id IN (11,22,33)
    SELECT * FROM 表 WHERE id NOT IN (11,22,33)
    SELECT * FROM 表 WHERE id IN (SELECT nid FROM 表)

2、通配符
    SELECT * FROM 表 WHERE name LIKE 'ale%'  - ale开头的所有（多个字符串）
    SELECT * FROM 表 WHERE name LIKE 'ale_'  - ale开头的所有（一个字符）

3、限制
    SELECT * FROM 表 LIMIT 5;            - 前5行
    SELECT * FROM 表 LIMIT 4,5;          - 从第4行开始的5行
    SELECT * FROM 表 LIMIT 5 OFFSET 4    - 从第4行开始的5行

4、排序
    SELECT * FROM 表 ORDER BY 列 ASC              - 根据 “列” 从小到大排列
    SELECT * FROM 表 ORDER BY 列 DESC             - 根据 “列” 从大到小排列
    SELECT * FROM 表 ORDER BY 列1 DESC,列2 ASC    - 根据 “列1” 从大到小排列，如果相同则按列2从小到大排序

5、分组
    SELECT num FROM 表 GROUP BY num
    SELECT num,nid FROM 表 GROUP BY num,nid
    SELECT num,nid FROM 表  WHERE nid > 10 GROUP BY num,nid ORDER nid DESC
    SELECT num,nid,count(*),sum(score),max(score),min(score) FROM 表 GROUP BY num,nid

    SELECT num FROM 表 GROUP BY num HAVING max(id) > 10

    特别的：GROUP BY 必须在WHERE之后，ORDER BY之前

6、连表
    无对应关系则不显示
    SELECT A.num, A.name, B.name
    FROM A,B
    WHERE A.nid = B.nid

    无对应关系则不显示
    SELECT A.num, A.name, B.name
    FROM A INNER JOIN B
    ON A.nid = B.nid

    A表所有显示，如果B中无对应关系，则值为NULL
    SELECT A.num, A.name, B.name
    FROM A LEFT JOIN B
    ON A.nid = B.nid

    B表所有显示，如果B中无对应关系，则值为NULL
    SELECT A.num, A.name, B.name
    FROM A RIGHT JOIN B
    ON A.nid = B.nid

7、组合
    组合，自动处理重合
    SELECT nickname
    FROM A
    UNION
    SELECT name
    FROM B

    组合，不处理重合
    SELECT nickname
    FROM A
    UNION ALL
    SELECT name
    FROM B
```

关于数据库的数据查询语句，可以参考
* [数据库之GROUP BY的使用](https://blog.csdn.net/omelon1/article/details/78813541)
* [数据库学习 - SELECT（多表联查）](https://blog.csdn.net/linan_pin/article/details/70158259)
* [ SQL--联合查询【Union】](https://www.cnblogs.com/caofangsheng/p/5118173.html)

#### 视图

视图是一个虚拟表（非真实存在），其本质是[根据SQL语句获取动态的数据集，并为其命名]，用户使用时只需使用[名称]即可获取结果集，并可以将其当作表来使用。

```
SELECT * FROM
    (SELECT nid,NAME FROM tb1 WHERE nid > 2) AS A
WHERE A.NAME > 'redhat';

创建视图
--格式：CREATE VIEW 视图名称 AS  SQL语句

CREATE VIEW v1 AS 
SELECT nid,name FROM A WHERE nid > 4;

删除视图
--格式：DROP VIEW 视图名称

DROP VIEW v1

修改视图
-- 格式：ALTER VIEW 视图名称 AS SQL语句

ALTER VIEW v1 AS
SELECT A.nid,B.NAME
FROM A LEFT JOIN B ON A.id = B.nid LEFT JOIN C ON A.id = C.nid
WHERE A.id > 2 AND C.nid < 5;

使用视图
使用视图时，将其当作表进行操作即可，由于视图是虚拟表，所以无法使用其对真实表进行创建、更新和删除操作，仅能做查询用。

SELECT * FROM v1
```
#### 触发器

为了理解接下来的SQL语句，可以先阅读[MySql中 DELIMITER 详解](https://blog.csdn.net/yuxin6866/article/details/52722913)

对某个表进行[增/删/改]操作的前后如果希望触发某个特定的行为时，可以使用触发器，触发器用于定制用户对表的行进行[增/删/改]前后的行为


```
创建基本语法

# 插入前
CREATE TRIGGER tri_before_insert_tb1 BEFORE INSERT ON tb1 FOR EACH ROW
BEGIN
    ...
END

# 插入后
CREATE TRIGGER tri_after_insert_tb1 AFTER INSERT ON tb1 FOR EACH ROW
BEGIN
    ...
END

# 删除前
CREATE TRIGGER tri_before_delete_tb1 BEFORE DELETE ON tb1 FOR EACH ROW
BEGIN
    ...
END

# 删除后
CREATE TRIGGER tri_after_delete_tb1 AFTER DELETE ON tb1 FOR EACH ROW
BEGIN
    ...
END

# 更新前
CREATE TRIGGER tri_before_update_tb1 BEFORE UPDATE ON tb1 FOR EACH ROW
BEGIN
    ...
END

# 更新后
CREATE TRIGGER tri_after_update_tb1 AFTER UPDATE ON tb1 FOR EACH ROW
BEGIN
    ...
END

实例：
DELIMITER //
CREATE TRIGGER tri_before_insert_tb1 BEFORE INSERT ON tb1 FOR EACH ROW
BEGIN
    IF NEW. NAME == 'redhat' THEN
        INSERT INTO tb2 (NAME)
        VALUES
            ('aa')
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER tri_after_insert_tb1 AFTER INSERT ON tb1 FOR EACH ROW
BEGIN
    IF NEW.num = 666 THEN
        INSERT INTO tb2 (NAME)
        VALUES
            ('666'),
            ('666') ;
    ELSEIF NEW.num = 555 THEN
        INSERT INTO tb2 (NAME)
        VALUES
            ('555'),
            ('555') ;
    END IF;
END//
DELIMITER ;

特别的：NEW表示即将插入的数据行，OLD表示即将删除的数据行。

删除触发器

DROP TRIGGER tri_after_insert_tb1;

使用触发器
触发器无法由用户直接调用，而知由于对表的[增/删/改]操作被动引发的。
INSERT INTO tb1(num) VALUES(666)

```
#### 存储过程

存储过程是一个SQL语句集合，当主动去调用存储过程时，其中内部的SQL语句会按照逻辑执行。阅读以下部分前最好对SQL编程有一定的了解，参考[SQL编程](https://www.cnblogs.com/WJ-163/p/WangJing.html)，对SQL变量的定义和使用，控制语句等有基本的认知。

对于存储过程，可以接收参数，其参数有三类：

    IN         仅用于传入参数用
    OUT        仅用于返回值用
    INOUT      既可以传入又可以当作返回值

实例：
```
-- 创建存储过程
DELIMITER //
CREATE PROCEDURE p1()
BEGIN
    SELECT * FROM t1;
END//
DELIMITER ;

-- 执行存储过程
CALL p1();

-- 创建存储过程
DELIMITER \\
CREATE PROCEDURE p1(
    IN i1 INT,
    IN i2 INT,
    INOUT i3 INT,
    OUT r1 INT
)
BEGIN
    DECLARE temp1 INT;
    DECLARE temp2 INT DEFAULT 0;
    
    SET temp1 = 1;
    SET r1 = i1 + i2 + temp1 + temp2;
    SET i3 = i3 + 100;

end\\
DELIMITER ;

-- 执行存储过程
DECLARE @t1 INT DEFAULT 3;
DECLARE @t2 INT;
CALL p1 (1, 2 ,@t1, @t2);
SELECT @t1,@t2;

-- 删除存储过程
DROP PROCEDURE proc_name;

-- 执行存储过程
    -- 无参数
    CALL proc_name();
    
    -- 有参数，全in
    CALL proc_name(1,2);
    
    -- 有参数，有in，out，inout
    DECLARE @t1 INT;
    DECLARE @t2 INT DEFAULT 3;
    CALL proc_name(1,2,@t1,@t2);
```


#### 函数

SQL Server提供了很多经常被用到的内置函数，比如：
```
CHAR_LENGTH(str)
    返回值为字符串str 的长度，长度的单位为字符。一个多字节字符算作一个单字符。
    对于一个包含五个二字节字符集, LENGTH()返回值为 10, 而CHAR_LENGTH()的返回值为5。

CONCAT(str1,str2,...)
    字符串拼接
    如有任何一个参数为NULL ，则返回值为 NULL。
CONCAT_WS(separator,str1,str2,...)
    字符串拼接（自定义连接符）
    CONCAT_WS()不会忽略任何空字符串。 (然而会忽略所有的 NULL）。

CONV(N,FROM_bASe,to_bASe)
    进制转换
    例如：
        SELECT CONV('a',16,2); 表示将 a 由16进制转换为2进制字符串表示

FORMAT(X,D)
    将数字X 的格式写为'#,###,###.##',以四舍五入的方式保留小数点后 D 位， 并将结果以字符串的形式返回。若  D 为 0, 则返回结果不带有小数点，或不含小数部分。
    例如：
        SELECT FORMAT(12332.1,4); 结果为： '12,332.1000'
INSERT(str,pos,len,newstr)
    在str的指定位置插入字符串
        pos：要替换位置其实位置
        len：替换的长度
        newstr：新字符串
    特别的：
        如果pos超过原字符串长度，则返回原字符串
        如果len超过原字符串长度，则由新字符串完全替换
INSTR(str,substr)
    返回字符串 str 中子字符串的第一个出现位置。

LEFT(str,len)
    返回字符串str 从开始的len位置的子序列字符。

LOWER(str)
    变小写

UPPER(str)
    变大写

LTRIM(str)
    返回字符串 str ，其引导空格字符被删除。
RTRIM(str)
    返回字符串 str ，结尾空格字符被删去。
SUBSTRING(str,pos,len)
    获取字符串子序列

LOCATE(substr,str,pos)
    获取子序列索引位置

REPEAT(str,count)
    返回一个由重复的字符串str 组成的字符串，字符串str的数目等于count 。
    若 count <= 0,则返回一个空字符串。
    若str 或 count 为 NULL，则返回 NULL 。
REPLACE(str,FROM_str,to_str)
    返回字符串str 以及所有被字符串to_str替代的字符串FROM_str 。
REVERSE(str)
    返回字符串 str ，顺序和字符顺序相反。
RIGHT(str,len)
    从字符串str 开始，返回从后边开始len个字符组成的子序列

SPACE(N)
    返回一个由N空格组成的字符串。

SUBSTRING(str,pos) , SUBSTRING(str FROM pos) SUBSTRING(str,pos,len) , SUBSTRING(str FROM pos FOR len)
    不带有len 参数的格式从字符串str返回一个子字符串，起始于位置 pos。带有len参数的格式从字符串str返回一个长度同len字符相同的子字符串，起始于位置 pos。 使用 FROM的格式为标准 SQL 语法。也可能对pos使用一个负值。假若这样，则子字符串的位置起始于字符串结尾的pos 字符，而不是字符串的开头位置。在以下格式的函数中可以对pos 使用一个负值。

    mysql> SELECT SUBSTRING('QuadratiCALLy',5);
        -> 'ratiCALLy'

    mysql> SELECT SUBSTRING('foobarbar' FROM 4);
        -> 'barbar'

    mysql> SELECT SUBSTRING('QuadratiCALLy',5,6);
        -> 'ratica'

    mysql> SELECT SUBSTRING('Sakila', -3);
        -> 'ila'

    mysql> SELECT SUBSTRING('Sakila', -5, 3);
        -> 'aki'

    mysql> SELECT SUBSTRING('Sakila' FROM -4 FOR 2);
        -> 'ki'

TRIM([{BOTH | LEADING | TRAILING} [remstr] FROM] str) TRIM(remstr FROM] str)
    返回字符串 str ， 其中所有remstr 前缀和/或后缀都已被删除。若分类符BOTH、LEADIN或TRAILING中没有一个是给定的,则假设为BOTH 。 remstr 为可选项，在未指定情况下，可删除空格。

    mysql> SELECT TRIM('  bar   ');
            -> 'bar'

    mysql> SELECT TRIM(LEADING 'x' FROM 'xxxbarxxx');
            -> 'barxxx'

    mysql> SELECT TRIM(BOTH 'x' FROM 'xxxbarxxx');
            -> 'bar'

    mysql> SELECT TRIM(TRAILING 'xyz' FROM 'barxxyz');
            -> 'barx'
```

更多内置函数可以参考对应SQL Server的官方文档或从互联网上获取，参考[SQL内置函数](https://blog.csdn.net/y550918116j/article/details/49837961)。

```
自定义函数
DELIMITER \\
CREATE FUNCTION f1(
    i1 INT,
    i2 INT)
RETURNS INT
BEGIN
    DECLARE num INT;
    SET num = i1 + i2;
    RETURN(num);
END \\
DELIMITER ;

删除函数
DROP FUNCTION func_name;

执行函数

# 获取返回值
DECLARE @i VARCHAR(32);
SELECT UPPER('alex') INTO @i;
SELECT @i;


# 在查询中使用
SELECT f1(11,nid) ,name FROM tb2;
```

#### 事务

事务用于将某些操作的多个SQL作为原子性操作，一旦有某一个出现错误，即可回滚到原来的状态，从而保证数据库数据完整性。

支持事务的存储过程实例：
```
DELIMITER \\
CREATE PROCEDURE p1(
    OUT p_return_code TINYINT
)
BEGIN 
  DECLARE exit handler FOR sqlexception 
  BEGIN 
    -- ERROR 
    SET p_return_code = 1; 
    ROLLBACK; 
  END; 
 
  DECLARE exit handler FOR sqlwarning 
  BEGIN 
    -- WARNING 
    SET p_return_code = 2; 
    ROLLBACK; 
  END; 
 
  START TRANSACTION; 
    DELETE FROM tb1;
    INSERT INTO tb2(name) VALUES('seven');
  COMMIT; 
 
  -- SUCCESS 
  SET p_return_code = 0; 
 
  END\\
DELIMITER ;

DECLARE @i TINYINT;
CALL p1(@i);
SELECT @i;
```


