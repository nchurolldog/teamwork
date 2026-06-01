# se 数据库建表语句

说明：以下 SQL 只用于说明和初始化数据库结构。我没有直接执行这些 SQL，也没有修改你的 MySQL 数据库。

## 角色约定

- `users.user_type = 0`：管理员
- `users.user_type = 1`：老师
- `users.user_type = 2`：辅导员
- `users.user_type = 3`：学生

## 性别约定

- `gender = 0`：未知
- `gender = 1`：男
- `gender = 2`：女

## 建库

```sql
CREATE DATABASE IF NOT EXISTS se
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE se;
```

## 用户与人员

```sql
CREATE TABLE IF NOT EXISTS users (
  account VARCHAR(50) PRIMARY KEY,
  password VARCHAR(100) NOT NULL,
  user_type TINYINT NOT NULL COMMENT '0 admin, 1 teacher, 2 counselor, 3 student'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS student (
  student_id VARCHAR(30) PRIMARY KEY,
  account VARCHAR(50) NOT NULL UNIQUE,
  name VARCHAR(50) NOT NULL,
  gender TINYINT DEFAULT 0,
  position VARCHAR(50),
  CONSTRAINT fk_student_user FOREIGN KEY (account) REFERENCES users(account)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS teacher (
  employee_id VARCHAR(30) PRIMARY KEY,
  account VARCHAR(50) NOT NULL UNIQUE,
  name VARCHAR(50) NOT NULL,
  gender TINYINT DEFAULT 0,
  CONSTRAINT fk_teacher_user FOREIGN KEY (account) REFERENCES users(account)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS counselor (
  employee_id VARCHAR(30) PRIMARY KEY,
  account VARCHAR(50) NOT NULL UNIQUE,
  name VARCHAR(50) NOT NULL,
  gender TINYINT DEFAULT 0,
  CONSTRAINT fk_counselor_user FOREIGN KEY (account) REFERENCES users(account)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

## 班级与课程

```sql
CREATE TABLE IF NOT EXISTS class_entity (
  class_id INT PRIMARY KEY,
  class_name VARCHAR(50) NOT NULL,
  teacher_id VARCHAR(30),
  counselor_id VARCHAR(30),
  CONSTRAINT fk_class_teacher FOREIGN KEY (teacher_id) REFERENCES teacher(employee_id),
  CONSTRAINT fk_class_counselor FOREIGN KEY (counselor_id) REFERENCES counselor(employee_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS student_class (
  student_id VARCHAR(30) NOT NULL,
  class_id INT NOT NULL,
  PRIMARY KEY (student_id, class_id),
  CONSTRAINT fk_student_class_student FOREIGN KEY (student_id) REFERENCES student(student_id),
  CONSTRAINT fk_student_class_class FOREIGN KEY (class_id) REFERENCES class_entity(class_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS course (
  course_id VARCHAR(30) PRIMARY KEY,
  course_name VARCHAR(100) NOT NULL,
  credits DECIMAL(4,1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS enrollment (
  student_id VARCHAR(30) NOT NULL,
  course_id VARCHAR(30) NOT NULL,
  PRIMARY KEY (student_id, course_id),
  CONSTRAINT fk_enrollment_student FOREIGN KEY (student_id) REFERENCES student(student_id),
  CONSTRAINT fk_enrollment_course FOREIGN KEY (course_id) REFERENCES course(course_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS grade (
  student_id VARCHAR(30) NOT NULL,
  course_id VARCHAR(30) NOT NULL,
  regular_grade DECIMAL(5,2),
  final_grade DECIMAL(5,2),
  total_grade DECIMAL(5,2),
  PRIMARY KEY (student_id, course_id),
  CONSTRAINT fk_grade_student FOREIGN KEY (student_id) REFERENCES student(student_id),
  CONSTRAINT fk_grade_course FOREIGN KEY (course_id) REFERENCES course(course_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

## 学生扩展信息

```sql
CREATE TABLE IF NOT EXISTS personal_info (
  student_id VARCHAR(30) PRIMARY KEY,
  origin_place VARCHAR(100),
  political_status VARCHAR(50),
  CONSTRAINT fk_personal_info_student FOREIGN KEY (student_id) REFERENCES student(student_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS family_info (
  student_id VARCHAR(30) PRIMARY KEY,
  home_address VARCHAR(200),
  family_size INT,
  phone VARCHAR(30),
  CONSTRAINT fk_family_info_student FOREIGN KEY (student_id) REFERENCES student(student_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS profile_image (
  image_id INT PRIMARY KEY AUTO_INCREMENT,
  owner_type TINYINT NOT NULL COMMENT '1 teacher, 2 counselor, 3 student',
  owner_account VARCHAR(50) NOT NULL,
  image_path VARCHAR(255) NOT NULL,
  original_name VARCHAR(255),
  content_type VARCHAR(100),
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_profile_image_owner (owner_type, owner_account),
  CONSTRAINT fk_profile_image_user FOREIGN KEY (owner_account) REFERENCES users(account)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

## 奖学金

```sql
CREATE TABLE IF NOT EXISTS scholarship_type (
  type_code VARCHAR(30) PRIMARY KEY,
  description VARCHAR(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS scholarship_application (
  app_id VARCHAR(30) PRIMARY KEY,
  student_id VARCHAR(30) NOT NULL,
  type_code VARCHAR(30) NOT NULL,
  amount DECIMAL(10,2),
  reason TEXT,
  status VARCHAR(30) DEFAULT 'pending',
  CONSTRAINT fk_scholarship_student FOREIGN KEY (student_id) REFERENCES student(student_id),
  CONSTRAINT fk_scholarship_type FOREIGN KEY (type_code) REFERENCES scholarship_type(type_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS counselor_approval (
  app_id VARCHAR(30) PRIMARY KEY,
  employee_id VARCHAR(30) NOT NULL,
  result BOOLEAN,
  CONSTRAINT fk_counselor_approval_application FOREIGN KEY (app_id) REFERENCES scholarship_application(app_id),
  CONSTRAINT fk_counselor_approval_counselor FOREIGN KEY (employee_id) REFERENCES counselor(employee_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

## 入党申请

```sql
CREATE TABLE IF NOT EXISTS party_application (
  application_id VARCHAR(30) PRIMARY KEY,
  applicant_student_id VARCHAR(30) NOT NULL,
  reason TEXT,
  status VARCHAR(30) DEFAULT 'pending',
  CONSTRAINT fk_party_application_student FOREIGN KEY (applicant_student_id) REFERENCES student(student_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS party_approval (
  approval_id VARCHAR(30) PRIMARY KEY,
  application_id VARCHAR(30) NOT NULL,
  approver_employee_id VARCHAR(30) NOT NULL,
  status VARCHAR(30) DEFAULT 'pending',
  CONSTRAINT fk_party_approval_application FOREIGN KEY (application_id) REFERENCES party_application(application_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS democratic_review (
  review_id VARCHAR(30) PRIMARY KEY,
  application_id VARCHAR(30) NOT NULL,
  organizer_employee_id VARCHAR(30) NOT NULL,
  status VARCHAR(30) DEFAULT 'pending',
  CONSTRAINT fk_democratic_review_application FOREIGN KEY (application_id) REFERENCES party_application(application_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS democratic_review_participant (
  review_id VARCHAR(30) NOT NULL,
  participant_student_id VARCHAR(30) NOT NULL,
  access BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (review_id, participant_student_id),
  CONSTRAINT fk_review_participant_review FOREIGN KEY (review_id) REFERENCES democratic_review(review_id),
  CONSTRAINT fk_review_participant_student FOREIGN KEY (participant_student_id) REFERENCES student(student_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS development_inspection (
  inspection_id VARCHAR(30) PRIMARY KEY,
  application_id VARCHAR(30) NOT NULL,
  inspector_employee_id VARCHAR(30) NOT NULL,
  status VARCHAR(30) DEFAULT 'pending',
  CONSTRAINT fk_development_inspection_application FOREIGN KEY (application_id) REFERENCES party_application(application_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

## 班会与考勤

```sql
CREATE TABLE IF NOT EXISTS class_meeting (
  meeting_id VARCHAR(30) PRIMARY KEY,
  class_id INT NOT NULL,
  meeting_theme VARCHAR(100) NOT NULL,
  classroom VARCHAR(50),
  CONSTRAINT fk_class_meeting_class FOREIGN KEY (class_id) REFERENCES class_entity(class_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS class_meeting_association (
  meeting_id VARCHAR(30) NOT NULL,
  student_id VARCHAR(30) NOT NULL,
  PRIMARY KEY (meeting_id, student_id),
  CONSTRAINT fk_meeting_association_meeting FOREIGN KEY (meeting_id) REFERENCES class_meeting(meeting_id),
  CONSTRAINT fk_meeting_association_student FOREIGN KEY (student_id) REFERENCES student(student_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS attendance_record (
  record_id INT PRIMARY KEY,
  student_id VARCHAR(30) NOT NULL,
  attendance_date DATE NOT NULL,
  is_absent BOOLEAN DEFAULT FALSE,
  CONSTRAINT fk_attendance_record_student FOREIGN KEY (student_id) REFERENCES student(student_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS attendance_publish (
  record_id INT PRIMARY KEY,
  meeting_id VARCHAR(30) NOT NULL,
  student_id VARCHAR(30) NOT NULL,
  CONSTRAINT fk_attendance_publish_record FOREIGN KEY (record_id) REFERENCES attendance_record(record_id),
  CONSTRAINT fk_attendance_publish_meeting FOREIGN KEY (meeting_id) REFERENCES class_meeting(meeting_id),
  CONSTRAINT fk_attendance_publish_student FOREIGN KEY (student_id) REFERENCES student(student_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

## Java 类型映射调整

- `student.student_id`、`teacher.employee_id`、`course.course_id` 等业务编号仍使用 `String`，避免前导零丢失。
- `gender` 使用 `Integer`，对应 `TINYINT`。
- `class_id`、`record_id`、`family_size` 使用 `Integer`。
- `attendance_date` 在 Java 中使用 `LocalDate`，数据库中使用 `DATE`。
- `is_absent`、`result`、`access` 使用 `Boolean`，数据库中使用 `BOOLEAN`。
- 成绩、学分、金额使用 `BigDecimal`，数据库中使用 `DECIMAL`。
