
create database  testforse;
use testforse;
create table  test(
                      id  int primary key auto_increment,
                      name varchar(20) not null
);
-- 插入数据（不指定 id，让它自动生成）
INSERT INTO test (name) VALUES ('张三');
INSERT INTO test (name) VALUES ('李四');
INSERT INTO test (name) VALUES ('王五');

-- 批量插入
INSERT INTO test (name) VALUES
                            ('赵六'),
                            ('孙七'),
                            ('周八');
