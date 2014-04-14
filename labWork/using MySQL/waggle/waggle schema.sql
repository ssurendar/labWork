CREATE SCHEMA `Waggle` DEFAULT CHARACTER SET utf8 ;


use Waggle;

delimiter $$

CREATE TABLE `academicyear` (
  `SchoolId` char(36) NOT NULL,
  `Year` int(11) NOT NULL,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `Active` char(3) DEFAULT NULL,
  PRIMARY KEY (`SchoolId`,`Year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$



delimiter $$

CREATE TABLE `subjects` (
  `SubjectId` char(36) NOT NULL,
  `SubjectName` longtext,
  PRIMARY KEY (`SubjectId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$

delimiter $$

CREATE TABLE `themes` (
  `ThemeId` char(36) NOT NULL,
  `ThemeName` varchar(100) NOT NULL,
  PRIMARY KEY (`ThemeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$



delimiter $$

CREATE TABLE `roles` (
  `RoleId` char(36) NOT NULL,
  `RoleName` varchar(45) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `CreatedBy` varchar(45) DEFAULT NULL,
  `LastModifiedDate` datetime DEFAULT NULL,
  `LastModifiedBy` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`RoleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$



delimiter $$

CREATE TABLE `grades` (
  `GradeId` char(36) NOT NULL,
  `GradeName` varchar(45) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `CreatedBy` varchar(45) DEFAULT NULL,
  `LastModifiedDate` datetime DEFAULT NULL,
  `LastModifiedBy` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`GradeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `group` (
  `GroupId` char(36) NOT NULL,
  `GroupName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`GroupId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `game_themes` (
  `GameThemeId` char(32) NOT NULL,
  `GameThemeName` varchar(50) DEFAULT NULL,
  `Icon` varchar(50) DEFAULT NULL,
  `ThemePath` varchar(50) DEFAULT NULL,
  `AssetRoot` varchar(250) DEFAULT NULL,
  `ConfigRoot` varchar(45) DEFAULT NULL,
  `CreatedBy` varchar(50) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  PRIMARY KEY (`GameThemeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `school_districts` (
  `DistrictId` char(36) NOT NULL,
  `Name` varchar(45) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `CreatedBy` varchar(45) DEFAULT NULL,
  `LastModifiedDate` datetime DEFAULT NULL,
  `LastModifiedBy` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`DistrictId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$



delimiter $$

CREATE TABLE `kg_goals` (
  `GoalId` char(36) NOT NULL,
  `Goal_Number` varchar(4) DEFAULT NULL,
  `Goal` varchar(250) DEFAULT NULL,
  `GradeId` char(36) NOT NULL COMMENT 'Contains foreign key reference to the Grades table',
  `SubjectId` char(36) NOT NULL COMMENT 'Contains foreign key reference to Subject table',
  `PassagesPerGoal` int(11) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `CreatedBy` varchar(50) DEFAULT NULL,
  `LastModifiedDate` datetime DEFAULT NULL,
  `LastModifiedBy` varchar(50) DEFAULT NULL,
  `GoalType` varchar(50) DEFAULT NULL,
  `GameThemeId` char(36) DEFAULT NULL,
  PRIMARY KEY (`GoalId`),
  KEY `FK_KGGoals_GradeId_idx` (`GradeId`),
  KEY `FK_KGGoals_SubjectId_idx` (`SubjectId`),
  KEY `FK_KGGoals_GameThemeId_idx` (`GameThemeId`),
  CONSTRAINT `FK_KGGoals_GameThemeId` FOREIGN KEY (`GameThemeId`) REFERENCES `game_themes` (`GameThemeId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_KGGoals_GradeId` FOREIGN KEY (`GradeId`) REFERENCES `grades` (`GradeId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_KGGoals_SubjectId` FOREIGN KEY (`SubjectId`) REFERENCES `subjects` (`SubjectId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='This table will contain goal details from knowledge map and its heirarchy relation'$$

delimiter $$

CREATE TABLE `KG_Goal_Hierarchy` (
  `PreReqId` char(36) NOT NULL,
  `GoalId` char(36) DEFAULT NULL,
  `PreReq_GoalId` char(36) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `CreatedBy` varchar(50) DEFAULT NULL,
  `LastModifiedDate` datetime DEFAULT NULL,
  `LastModifiedBy` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`PreReqId`),
  KEY `FK_KG_Goal_Hierarchy_GoalId_idx` (`GoalId`),
  KEY `FK_KG_Goal_Hierarchy_GoalPrereqId_idx` (`PreReq_GoalId`),
  CONSTRAINT `FK_GoalHierarchy_GoalId` FOREIGN KEY (`GoalId`) REFERENCES `kg_goals` (`GoalId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='This table contains the definition for the goals relationship'$$

delimiter $$

CREATE TABLE `kg_skills` (
  `SkillId` char(36) NOT NULL,
  `Skill_Number` float DEFAULT NULL,
  `Skill` varchar(250) DEFAULT NULL,
  `CCSS` varchar(25) DEFAULT NULL,
  `MaxItemPerPassagePerSkill` int(11) DEFAULT NULL,
  `Annotations` varchar(250) DEFAULT NULL,
  `GoalId` char(36) NOT NULL,
  `KnewtonModuleId` char(36) DEFAULT '00000000-0000-0000-0000-000000000000',
  `CreatedDate` datetime DEFAULT NULL,
  `CreatedBy` varchar(50) DEFAULT NULL,
  `LastModifiedDate` datetime DEFAULT NULL,
  `LastModifiedBy` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`SkillId`),
  KEY `FK_KGSkills_GoalId_idx` (`GoalId`),
  CONSTRAINT `FK_KGSkills_GoalId` FOREIGN KEY (`GoalId`) REFERENCES `kg_goals` (`GoalId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='This table will contain data about skills and its association with Goals and Standards, As of this definition A Skill can be associated with only one goal.'$$


delimiter $$

CREATE TABLE `kg_goalskills` (
  `GoalSkillId` char(36) NOT NULL COMMENT 'changed coalation',
  `GoalId` char(36) DEFAULT NULL COMMENT 'Coalation changed',
  `SkillId` char(36) DEFAULT NULL,
  `GameLevelId` char(32) NOT NULL,
  `Createddate` datetime DEFAULT NULL,
  `CreatedBy` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`GoalSkillId`),
  KEY `GoalSkill_GameLevels_idx` (`GameLevelId`),
  KEY `GoalSkill_GoalId_idx` (`GoalId`),
  CONSTRAINT `FK_KGGoalSkills_GoalId` FOREIGN KEY (`GoalId`) REFERENCES `kg_goals` (`GoalId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$




delimiter $$

CREATE TABLE `knewton_configuration` (
  `Key` varchar(255) NOT NULL,
  `Value` varchar(2000) DEFAULT NULL,
  `Type` varchar(512) NOT NULL,
  PRIMARY KEY (`Key`),
  UNIQUE KEY `key_UNIQUE` (`Key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$








delimiter $$

CREATE TABLE `schools` (
  `SchoolId` char(36) NOT NULL,
  `SchoolName` varchar(250) DEFAULT NULL,
  `Address1` varchar(200) DEFAULT NULL,
  `Address2` varchar(200) DEFAULT NULL,
  `City` varchar(100) DEFAULT NULL,
  `State` varchar(50) DEFAULT NULL,
  `Zip` varchar(25) DEFAULT NULL,
  `TimeZone` smallint(6) DEFAULT NULL,
  `Country` varchar(50) DEFAULT NULL,
  `DistrictId` char(36) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `CreatedBy` varchar(50) CHARACTER SET latin1 DEFAULT NULL,
  `LastModifiedDate` datetime DEFAULT NULL,
  `LastModifiedBY` varchar(50) CHARACTER SET latin1 DEFAULT NULL,
  PRIMARY KEY (`SchoolId`),
  KEY `FK_Schools_DistrictId_idx` (`DistrictId`),
  CONSTRAINT `FK_Schools_DistrictId` FOREIGN KEY (`DistrictId`) REFERENCES `school_districts` (`DistrictId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$




delimiter $$

CREATE TABLE `school_grades` (
  `SchoolGradeId` char(36) NOT NULL,
  `SchoolId` char(36) NOT NULL,
  `GradeId` char(36) NOT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `CreatedBy` varchar(50) DEFAULT NULL,
  `LastModifiedDate` datetime DEFAULT NULL,
  `LastModifiedBy` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`SchoolGradeId`),
  KEY `FK_SchoolGrades_SchoolId_idx` (`SchoolId`),
  KEY `FK_SchoolGrades_GradeId_idx` (`GradeId`),
  CONSTRAINT `FK_SchoolGrades_GradeId` FOREIGN KEY (`GradeId`) REFERENCES `grades` (`GradeId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SchoolGrades_SchoolId` FOREIGN KEY (`SchoolId`) REFERENCES `schools` (`SchoolId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$




delimiter $$

CREATE TABLE `user_profiles` (
  `ProfileId` char(36) NOT NULL,
  `FirstName` longtext,
  `LastName` longtext,
  `UserName` longtext,
  `Password` longtext,
  `IsHashed` bit(1) NOT NULL DEFAULT b'0',
  `PasswordSalt` binary(10) DEFAULT NULL,
  `DisplayName` longtext,
  `DOB` datetime NOT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `CreatedBy` longtext,
  `LastModifiedDate` datetime DEFAULT NULL,
  `LastModifiedBy` longtext,
  PRIMARY KEY (`ProfileId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `teacher_profiles` (
  `ProfileId` char(36) NOT NULL,
  `KnewtonAccountId` char(36) DEFAULT NULL,
  `Email` char(255) DEFAULT NULL,
  `IsGetCoachRegistered` varchar(3) DEFAULT NULL,
  `active` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`ProfileId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$

delimiter $$

CREATE TABLE `student_profiles` (
  `ProfileId` char(36) NOT NULL,
  `KnewtonAccountId` char(36) DEFAULT NULL,
  `StudentSchoolId` varchar(10) DEFAULT NULL COMMENT 'Students enrollment id in school',
  `Avatar` varchar(30) DEFAULT NULL,
  `GlobalAudio` tinyint(1) DEFAULT NULL,
  `IsGetCoachRegistered` tinyint(1) DEFAULT NULL,
  `DeferDeadlines` int(11) DEFAULT NULL,
  `Active` varchar(3) DEFAULT 'on',
  `KnewtonAccessToken` char(32) DEFAULT NULL,
  `KnewtonRefreshToken` char(32) DEFAULT NULL,
  `HasOnboarded` bit(1) DEFAULT NULL,
  `MusicMuted` bit(1) DEFAULT NULL,
  `SfxMuted` bit(1) DEFAULT NULL,
  PRIMARY KEY (`ProfileId`),
  KEY `student_profile_id_idx` (`ProfileId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$






delimiter $$

CREATE TABLE `user_profiles_school` (
  `ProfileSchoolId` char(36) NOT NULL,
  `ProfileId` char(36) DEFAULT NULL,
  `SchoolId` char(36) DEFAULT NULL,
  `CreateDate` datetime DEFAULT NULL,
  `CreatedBy` char(36) DEFAULT NULL,
  `LastModifiedDate` datetime DEFAULT NULL,
  `LastModifiedBy` char(36) DEFAULT NULL,
  PRIMARY KEY (`ProfileSchoolId`),
  KEY `FK_UserProfilesSchool_ProfileId_idx` (`ProfileId`),
  KEY `FK_UserProfilesSchool_SchoolId_idx` (`SchoolId`),
  CONSTRAINT `FK_UserProfilesSchool_SchoolId` FOREIGN KEY (`SchoolId`) REFERENCES `schools` (`SchoolId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_UserProfilesSchool_ProfileId` FOREIGN KEY (`ProfileId`) REFERENCES `user_profiles` (`ProfileId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `user_roles` (
  `UserRoleId` char(36) NOT NULL,
  `RoleId` char(36) NOT NULL,
  `UserId` char(36) NOT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `CreatedBy` varchar(45) DEFAULT NULL,
  `LastModifiedBy` varchar(45) DEFAULT NULL,
  `LastModifiedDate` datetime DEFAULT NULL,
  PRIMARY KEY (`UserRoleId`),
  KEY `user_role_roleId_idx` (`RoleId`),
  KEY `user_role_profile_id_idx` (`UserId`),
  CONSTRAINT `FK_user_roles_profileId` FOREIGN KEY (`UserId`) REFERENCES `user_profiles` (`ProfileId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_user_roles_roleId` FOREIGN KEY (`RoleId`) REFERENCES `roles` (`RoleId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$



delimiter $$

CREATE TABLE `student_group` (
  `StudentGroupId` char(36) NOT NULL,
  `ProfileId` char(36) NOT NULL,
  `GroupId` char(36) NOT NULL,
  PRIMARY KEY (`StudentGroupId`),
  KEY `FK_StudentGroup_ProfileId_idx` (`ProfileId`),
  KEY `FK_StudentGroup_GroupId_idx` (`GroupId`),
  CONSTRAINT `FK_StudentGroup_ProfileId` FOREIGN KEY (`ProfileId`) REFERENCES `user_profiles` (`ProfileId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_StudentGroup_GroupId` FOREIGN KEY (`GroupId`) REFERENCES `group` (`GroupId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='	'$$


delimiter $$

CREATE TABLE `student_guardian` (
  `GuardianId` char(36) NOT NULL,
  `ProfileId` char(36) NOT NULL,
  `FirstName` varchar(20) DEFAULT NULL,
  `LastName` varchar(20) DEFAULT NULL,
  `Email` varchar(45) DEFAULT NULL,
  `Phone` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`GuardianId`),
  KEY `FK_StudentGaurdian_ProfileId_idx` (`ProfileId`),
  CONSTRAINT `FK_StudentGaurdian_ProfileId` FOREIGN KEY (`ProfileId`) REFERENCES `user_profiles` (`ProfileId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='	'$$



delimiter $$

CREATE TABLE `class` (
  `ClassId` char(36) NOT NULL,
  `ClassName` longtext,
  `GradeId` char(36) NOT NULL,
  `Section` char(25) DEFAULT NULL,
  `Year` int(11) NOT NULL,
  `SchoolId` char(36) NOT NULL,
  `CreateDate` datetime NOT NULL,
  `CreatedBy` longtext,
  `LastModifiedDate` datetime DEFAULT NULL,
  `LastModifiedBy` longtext,
  `Theme` longtext,
  PRIMARY KEY (`ClassId`),
  KEY `FK_Class_GradeId_idx` (`GradeId`),
  KEY `FK_Class_SchoolId_idx` (`SchoolId`),
  CONSTRAINT `FK_Class_SchoolId` FOREIGN KEY (`SchoolId`) REFERENCES `schools` (`SchoolId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Class_GradeId` FOREIGN KEY (`GradeId`) REFERENCES `grades` (`GradeId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `class_subjects` (
  `ClassId` char(36) NOT NULL,
  `SubjectId` char(36) NOT NULL,
  `KnewtonLearningInstanceId` char(36) NOT NULL,
  `CreateDate` datetime NOT NULL,
  `CreatedBy` longtext,
  `LastModifiedDate` datetime NOT NULL,
  `LastModifiedBy` longtext,
  `ClassViewRegId` char(36) NOT NULL,
  PRIMARY KEY (`ClassViewRegId`),
  KEY `FK_ClassSubjects_ClassId_idx` (`ClassId`),
  KEY `FK_ClassSubjects_SubjectId_idx` (`SubjectId`),
  CONSTRAINT `FK_ClassSubjects_SubjectId` FOREIGN KEY (`SubjectId`) REFERENCES `subjects` (`SubjectId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_ClassSubjects_ClassId` FOREIGN KEY (`ClassId`) REFERENCES `class` (`ClassId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$

delimiter $$

CREATE TABLE `pacing_groups` (
  `PacingGroupId` char(36) NOT NULL,
  `PacingGroupName` varchar(20) DEFAULT NULL,
  `DaysDeferred` int(11) DEFAULT NULL,
  `ClassId` char(36) DEFAULT NULL,
  `SubjectId` char(36) DEFAULT NULL,
  `ClassViewRegId` char(36) NOT NULL,
  PRIMARY KEY (`PacingGroupId`),
  KEY `FK_PacinGroups_ClassViewRegId_idx` (`ClassViewRegId`),
  CONSTRAINT `FK_PacinGroups_ClassViewRegId` FOREIGN KEY (`ClassViewRegId`) REFERENCES `class_subjects` (`ClassViewRegId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$



delimiter $$

CREATE TABLE `class_teachers` (
  `ClassTeacherId` char(36) NOT NULL,
  `ClassId` char(36) NOT NULL,
  `TeacherId` char(36) NOT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `LastModifiedDate` datetime DEFAULT NULL,
  `LastModifiedBy` varchar(36) DEFAULT NULL,
  `SubjectId` char(36) DEFAULT NULL,
  `KnewtonRegistrationId` char(36) DEFAULT NULL,
  `IsActive` bit(1) DEFAULT NULL,
  `ClassViewRegId` char(36) DEFAULT NULL,
  PRIMARY KEY (`ClassTeacherId`),
  KEY `ClassTeacher_ClassId_idx` (`ClassId`),
  KEY `Class_TeacherSubjectId_idx` (`SubjectId`),
  KEY `FK_ClassTeachers_ClassViewRegId_idx` (`ClassViewRegId`),
  KEY `FK_ClassTeachers_TeacherId_idx` (`TeacherId`),
  CONSTRAINT `FK_ClassTeachers_TeacherId` FOREIGN KEY (`TeacherId`) REFERENCES `user_profiles` (`ProfileId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_ClassTeachers_ClassViewRegId` FOREIGN KEY (`ClassViewRegId`) REFERENCES `class_subjects` (`ClassViewRegId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$

delimiter $$

CREATE TABLE `student_classes` (
  `StudentClassId` char(36) NOT NULL,
  `ProfileId` char(36) NOT NULL,
  `ClassId` char(36) NOT NULL,
  `SubjectId` char(36) NOT NULL,
  `Active` char(3) DEFAULT 'on',
  `PacingGroupId` char(36) DEFAULT NULL,
  `TeacherNotes` varchar(100) DEFAULT NULL,
  `ClassViewRegId` char(36) NOT NULL,
  `KnewtonRegistrationId` char(36) NOT NULL,
  PRIMARY KEY (`StudentClassId`),
  KEY `student_class_class_id_idx` (`ClassId`),
  KEY `FK_PacingGroupID_idx` (`PacingGroupId`),
  KEY `FK_StudentClasses_ProfileId_idx` (`ProfileId`),
  KEY `FK_StudentClasses_ClassViewRegId_idx` (`ClassViewRegId`),
  CONSTRAINT `FK_StudentClasses_PacingGroupId` FOREIGN KEY (`PacingGroupId`) REFERENCES `pacing_groups` (`PacingGroupId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_StudentClasses_ClassViewRegId` FOREIGN KEY (`ClassViewRegId`) REFERENCES `class_subjects` (`ClassViewRegId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_StudentClasses_ProfileId` FOREIGN KEY (`ProfileId`) REFERENCES `user_profiles` (`ProfileId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$



delimiter $$

CREATE TABLE `class_views` (
  `ClassViewId` char(36) NOT NULL,
  `DisplayName` varchar(45) DEFAULT NULL,
  `Theme` varchar(45) DEFAULT NULL,
  `ClassId` char(36) DEFAULT NULL,
  PRIMARY KEY (`ClassViewId`),
  KEY `FK_ClassViews_ClassId_idx` (`ClassId`),
  CONSTRAINT `FK_ClassViews_ClassId` FOREIGN KEY (`ClassId`) REFERENCES `class` (`ClassId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$

delimiter $$

CREATE TABLE `class_view_details` (
  `ClassViewDetailId` char(36) NOT NULL,
  `ClassViewId` char(36) NOT NULL,
  `ClassId` char(36) DEFAULT NULL,
  `SubjectId` char(36) DEFAULT NULL,
  `ClassViewRegId` char(36) NOT NULL,
  PRIMARY KEY (`ClassViewDetailId`),
  KEY `classview_id_idx` (`ClassViewId`),
  KEY `FK_ClassViewDetails_ClassViewRegId_idx` (`ClassViewRegId`),
  CONSTRAINT `FK_ClassViewDetails_ClassViewRegId` FOREIGN KEY (`ClassViewRegId`) REFERENCES `class_subjects` (`ClassViewRegId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_ClassViewDetails_ClassViewId` FOREIGN KEY (`ClassViewId`) REFERENCES `class_views` (`ClassViewId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `assignments` (
  `AssignmentId` char(36) NOT NULL,
  `Id` int(11) NOT NULL,
  `assignmentName` longtext,
  `packName` longtext,
  `completed` longtext,
  `dueDate` datetime NOT NULL,
  `KnewtonGoalId` char(36) DEFAULT NULL,
  `GoalId` char(36) DEFAULT NULL,
  `Class_classId` char(36) DEFAULT NULL,
  `ClassId` char(36) NOT NULL,
  `SubjectId` char(36) NOT NULL,
  `IsCompleted` bit(1) NOT NULL DEFAULT b'0',
  `IsAssigned` bit(1) NOT NULL DEFAULT b'0',
  `ClassViewRegId` char(36) NOT NULL,
  `GradeId` char(36) NOT NULL,
  `StartDate` datetime NOT NULL,
  `IsDeleted` tinyint(1) DEFAULT NULL,
  `GoalType` varchar(50) DEFAULT NULL,
  `MinimumPlayCount` int(11) DEFAULT NULL,
  PRIMARY KEY (`AssignmentId`),
  KEY `FK_Assignments_ClassViewRegId_idx` (`ClassViewRegId`),
  KEY `FK_Assignments_GoalId_idx` (`GoalId`),
  CONSTRAINT `FK_Assignments_GoalId` FOREIGN KEY (`GoalId`) REFERENCES `kg_goals` (`GoalId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Assignments_ClassViewRegId` FOREIGN KEY (`ClassViewRegId`) REFERENCES `class_subjects` (`ClassViewRegId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$

delimiter $$

CREATE TABLE `assignment_notes` (
  `AssignmentNoteId` char(36) NOT NULL,
  `AssignmentId` char(36) NOT NULL,
  `Message` longtext,
  `CreatedDate` datetime NOT NULL,
  `CreatedBy` longtext,
  `LastModifiedDate` datetime NOT NULL,
  `LastModifiedBy` longtext,
  `Id` int(11) NOT NULL,
  `IsDeleted` bit(1) DEFAULT NULL,
  PRIMARY KEY (`AssignmentNoteId`),
  KEY `FK_AssignmentNotes_AssignmentId_idx` (`AssignmentId`),
  CONSTRAINT `FK_AssignmentNotes_AssignmentId` FOREIGN KEY (`AssignmentId`) REFERENCES `assignments` (`AssignmentId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$

delimiter $$

CREATE TABLE `student_assignments` (
  `StudentAssignmentId` char(36) NOT NULL,
  `ProfileId` char(36) DEFAULT NULL,
  `ClassId` char(36) DEFAULT NULL,
  `SubjectId` char(36) DEFAULT NULL,
  `KnewtonLearningInstanceId` char(36) NOT NULL,
  `AssignmentId` char(36) DEFAULT NULL,
  `GoalId` char(36) DEFAULT NULL,
  `Status` longtext,
  `ActivationDate` datetime NOT NULL,
  `DueDate` datetime NOT NULL,
  `KnewtonGoalId` char(36) DEFAULT NULL,
  `IsLocked` tinyint(1) NOT NULL,
  `PushedToCleared` tinyint(1) NOT NULL,
  `ClassViewRegId` char(36) NOT NULL,
  `IsDeleted` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`StudentAssignmentId`),
  KEY `FK_StudentAssignments_ClassViewRegId_idx` (`ClassViewRegId`),
  KEY `FK_StudentAssignments_ProfileId_idx` (`ProfileId`),
  CONSTRAINT `FK_StudentAssignments_ProfileId` FOREIGN KEY (`ProfileId`) REFERENCES `user_profiles` (`ProfileId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_StudentAssignments_ClassViewRegId` FOREIGN KEY (`ClassViewRegId`) REFERENCES `class_subjects` (`ClassViewRegId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$

delimiter $$

CREATE TABLE `assignment_assigned` (
  `AssignedId` char(36) NOT NULL,
  `GoalId` char(36) DEFAULT NULL,
  `Assigned` varchar(45) DEFAULT NULL,
  `Id` char(36) DEFAULT NULL,
  `IsDeleted` bit(1) DEFAULT NULL,
  `AssignedName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`AssignedId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$




delimiter $$

CREATE TABLE `assignments_temp` (
  `AssignmentId` char(36) NOT NULL,
  `assignmentName` longtext,
  `packName` longtext,
  `completed` longtext,
  `dueDate` datetime NOT NULL,
  `KnewtonGoalId` char(36) DEFAULT NULL,
  `GoalId` char(36) DEFAULT NULL,
  `Class_classId` char(36) DEFAULT NULL,
  PRIMARY KEY (`AssignmentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `Cloudy_Messages` (
  `MessageId` int(11) NOT NULL,
  `CloudyMessages` tinytext,
  `IntervalName` varchar(45) DEFAULT NULL,
  `IntervalConfig` int(11) DEFAULT NULL,
  `CloudyType` varchar(45) DEFAULT NULL,
  `CloudyMood` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`MessageId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `email_subcriptions` (
  `SubscriptionId` char(36) NOT NULL,
  `Description` varchar(300) NOT NULL,
  `IsDefault` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`SubscriptionId`),
  UNIQUE KEY `SubscriptionId_UNIQUE` (`SubscriptionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `feet_calculation` (
  `Action` varchar(20) NOT NULL,
  `FeetEarned` int(11) NOT NULL,
  PRIMARY KEY (`Action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `feet_transaction` (
  `FeetTransactionId` char(36) NOT NULL,
  `ProfileId` char(36) NOT NULL,
  `AssignmentId` char(36) NOT NULL,
  `ClassId` char(36) NOT NULL,
  `TotalFeet` int(11) DEFAULT NULL,
  `FeetEarned` int(11) NOT NULL,
  `Viewed` tinyint(4) DEFAULT NULL,
  `SessionId` varchar(50) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `ModifiedDate` datetime DEFAULT NULL,
  `ClassViewRegId` char(36) NOT NULL,
  PRIMARY KEY (`FeetTransactionId`),
  KEY `FK_FeetTransaction_ClassViewRegId_idx` (`ClassViewRegId`),
  KEY `FK_FeetTransaction_ProfileId_idx` (`ProfileId`),
  CONSTRAINT `FK_FeetTransaction_ProfileId` FOREIGN KEY (`ProfileId`) REFERENCES `user_profiles` (`ProfileId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_FeetTransaction_ClassViewRegId` FOREIGN KEY (`ClassViewRegId`) REFERENCES `class_subjects` (`ClassViewRegId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `flock_calculation` (
  `FlockType` varchar(10) NOT NULL,
  `StreakCounter` int(11) NOT NULL,
  PRIMARY KEY (`FlockType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `flocks_transactions` (
  `FlocksTransactionsId` char(36) NOT NULL,
  `ProfileId` char(36) NOT NULL,
  `AssignmentId` char(36) DEFAULT NULL,
  `ClassId` char(36) NOT NULL,
  `FlockType` varchar(10) DEFAULT NULL,
  `Count` int(11) DEFAULT NULL,
  `Viewed` int(11) DEFAULT NULL,
  `CreatedDate` datetime NOT NULL,
  `ModifiedDate` datetime DEFAULT NULL,
  `ClassViewRegId` char(36) NOT NULL,
  PRIMARY KEY (`FlocksTransactionsId`),
  KEY `FK_FlocksTransaction_ProfileId_idx` (`ProfileId`),
  KEY `FK_FlocksTransactions_ClassViewRegId_idx` (`ClassViewRegId`),
  CONSTRAINT `FK_FlocksTransactions_ClassViewRegId` FOREIGN KEY (`ClassViewRegId`) REFERENCES `class_subjects` (`ClassViewRegId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_FlocksTransaction_ProfileId` FOREIGN KEY (`ProfileId`) REFERENCES `user_profiles` (`ProfileId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `game_levels` (
  `GameLevelId` char(32) NOT NULL,
  `GoalId` char(36) DEFAULT NULL,
  `Level` int(11) DEFAULT NULL,
  `LevelSequence` int(11) DEFAULT NULL,
  `CreatedBy` varchar(50) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  PRIMARY KEY (`GameLevelId`),
  KEY `GameLevel_KGGoal_idx` (`GoalId`),
  CONSTRAINT `FK_GameLevels_GoalId` FOREIGN KEY (`GoalId`) REFERENCES `kg_goals` (`GoalId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$



delimiter $$

CREATE TABLE `group_classviewreg` (
  `GroupRegId` char(36) NOT NULL,
  `GroupId` char(36) DEFAULT NULL,
  `ClassViewRegId` char(36) DEFAULT NULL,
  PRIMARY KEY (`GroupRegId`),
  KEY `FK_GroupClassViewReg_GroupId_idx` (`GroupId`),
  KEY `FK_GroupClassViewReg_ClassViewRegId_idx` (`ClassViewRegId`),
  CONSTRAINT `FK_GroupClassViewReg_GroupId` FOREIGN KEY (`GroupId`) REFERENCES `group` (`GroupId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_GroupClassViewReg_ClassViewRegId` FOREIGN KEY (`ClassViewRegId`) REFERENCES `class_subjects` (`ClassViewRegId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$



delimiter $$

CREATE TABLE `streak_calculation` (
  `StreakCounter` int(11) NOT NULL,
  `WingType` varchar(10) NOT NULL,
  PRIMARY KEY (`StreakCounter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `streak_transaction` (
  `CreatedDate` datetime DEFAULT NULL,
  `ModifiedDate` datetime DEFAULT NULL,
  `StreakCount` int(11) DEFAULT NULL,
  `FlockEarned` varchar(10) DEFAULT NULL,
  `StreakTransactionId` char(36) NOT NULL,
  `ClassId` char(36) NOT NULL,
  `StudentId` char(36) NOT NULL,
  `SessionId` varchar(50) NOT NULL,
  `TotalCorrect` int(11) DEFAULT NULL,
  `QuestionCount` int(11) DEFAULT NULL,
  `SubjectId` char(36) DEFAULT NULL,
  `ClassViewRegId` char(36) NOT NULL,
  PRIMARY KEY (`StreakTransactionId`),
  KEY `FK_StreakTransaction_ClassViewRegId_idx` (`ClassViewRegId`),
  KEY `FK_StreakTransaction_ProfileId_idx` (`StudentId`),
  CONSTRAINT `FK_StreakTransaction_ProfileId` FOREIGN KEY (`StudentId`) REFERENCES `user_profiles` (`ProfileId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_StreakTransaction_ClassViewRegId` FOREIGN KEY (`ClassViewRegId`) REFERENCES `class_subjects` (`ClassViewRegId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `student_assignment_response` (
  `ItemId` varchar(128) NOT NULL,
  `AssignmentId` char(36) NOT NULL,
  `ResponseData` text NOT NULL,
  `FeetEarned` int(11) DEFAULT NULL,
  `ProfileId` char(36) DEFAULT NULL,
  `HintsUsed` int(11) DEFAULT NULL,
  `ResponseStatus` varchar(50) DEFAULT NULL,
  `ClassId` char(36) DEFAULT NULL,
  `StreakCounter` int(11) DEFAULT NULL,
  `IsStreakBreak` bit(1) DEFAULT NULL,
  `TimeSpent` int(11) DEFAULT NULL,
  `SkillId` char(36) DEFAULT NULL,
  `GoalId` char(36) DEFAULT NULL,
  `IsReviewMode` bit(1) DEFAULT NULL,
  `sessionID` varchar(128) NOT NULL,
  `StudentAssignmentResponseId` char(36) NOT NULL,
  `SubjectId` char(36) DEFAULT NULL,
  `ClassViewRegId` char(36) DEFAULT NULL,
  `StudentAssignmentId` char(36) DEFAULT NULL,
  PRIMARY KEY (`StudentAssignmentResponseId`),
  KEY `FK_StudentAssignmentRespose_StudentAssignmentId_idx` (`StudentAssignmentId`),
  CONSTRAINT `FK_StudentAssignmentRespose_StudentAssignmentId` FOREIGN KEY (`StudentAssignmentId`) REFERENCES `student_assignments` (`StudentAssignmentId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$



delimiter $$

CREATE TABLE `student_game_responses` (
  `GameResponseId` char(36) NOT NULL,
  `ProfileId` char(36) DEFAULT NULL COMMENT 'Added Coalation',
  `GoalId` char(36) DEFAULT NULL,
  `StudentAssignmentId` char(36) DEFAULT NULL,
  `AssignmentId` char(36) DEFAULT NULL,
  `LevelId` char(32) DEFAULT NULL,
  `StarRating` int(11) DEFAULT NULL,
  `Score` int(11) DEFAULT NULL,
  `PlayCount` int(11) DEFAULT NULL,
  `SessionId` varchar(50) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `CreatedBy` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`GameResponseId`),
  KEY `StudentGameResponses_Profile_idx` (`ProfileId`),
  KEY `FK_StudentGameResponses_GoalId_idx` (`GoalId`),
  KEY `FK_StudentGameResponses_StudentAssignmentId_idx` (`StudentAssignmentId`),
  CONSTRAINT `FK_StudentGameResponses_StudentAssignmentId` FOREIGN KEY (`StudentAssignmentId`) REFERENCES `student_assignments` (`StudentAssignmentId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_StudentGameResponses_GoalId` FOREIGN KEY (`GoalId`) REFERENCES `kg_goals` (`GoalId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_StudentGameResponses_ProfileId` FOREIGN KEY (`ProfileId`) REFERENCES `user_profiles` (`ProfileId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `student_gameplay` (
  `GamePlayId` char(36) CHARACTER SET latin1 NOT NULL,
  `ProfileId` char(36) NOT NULL COMMENT 'coalation change',
  `ClassId` char(36) DEFAULT NULL,
  `ClassViewRegId` char(36) DEFAULT NULL,
  `SubjectId` char(36) DEFAULT NULL,
  `GoalId` char(36) CHARACTER SET latin1 NOT NULL,
  `CurrentLevel` char(36) CHARACTER SET latin1 NOT NULL,
  `CurrentScore` int(11) DEFAULT NULL,
  `BestScore` int(11) DEFAULT NULL,
  `BestScoreLevel` char(36) DEFAULT NULL,
  `BestStarRating` int(11) DEFAULT NULL,
  `HighestLevelPlayedId` char(32) DEFAULT NULL,
  `HighestLevelPlayedScore` int(11) DEFAULT NULL,
  `StudentAssignmentId` char(36) DEFAULT NULL COMMENT 'testing foreign key 1',
  `AllowedPlays` int(11) DEFAULT NULL,
  `PlayedCount` int(11) DEFAULT NULL,
  `LastPlayedCount` int(11) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `createdby` varchar(50) DEFAULT NULL,
  `LastModifiedDate` datetime DEFAULT NULL,
  `LastModifiedBy` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`GamePlayId`),
  KEY `StudentGamePlay_StudentAssignmentId` (`StudentAssignmentId`),
  KEY `StudentGamePlay_KGGoals_idx` (`GoalId`),
  KEY `StudentGamePlay_ProfileId_idx` (`ProfileId`),
  KEY `StudentGamePlay_class_idx` (`ClassId`),
  KEY `StudentGamePlay_Subject_idx` (`SubjectId`),
  KEY `FK_StudentGamePlay_ClassViewRegId_idx` (`ClassViewRegId`),
  KEY `StudentGamePlay_class_idx1` (`ClassId`),
  KEY `StudentGamePlay_Subject_idx1` (`SubjectId`),
  CONSTRAINT `StudentGamePlay_Profile1` FOREIGN KEY (`ProfileId`) REFERENCES `student_profiles` (`ProfileId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `StudentGamePlay_classid1` FOREIGN KEY (`ClassId`) REFERENCES `class` (`ClassId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `StudentGamePlay_SubjectId1` FOREIGN KEY (`SubjectId`) REFERENCES `subjects` (`SubjectId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `StudentGamePlay_studentAssignmentId1` FOREIGN KEY (`StudentAssignmentId`) REFERENCES `student_assignments` (`StudentAssignmentId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_StudentGamePlay_ClassViewRegId` FOREIGN KEY (`ClassViewRegId`) REFERENCES `class_subjects` (`ClassViewRegId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_StudentGamePlay_ProfileId` FOREIGN KEY (`ProfileId`) REFERENCES `user_profiles` (`ProfileId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='GoalId Foriegn key is still pending'$$


delimiter $$

CREATE TABLE `student_gameplay_levels` (
  `GamePlayLevelId` char(36) NOT NULL,
  `GamePlayId` char(36) NOT NULL,
  `GoalId` char(36) NOT NULL,
  `CurrentLevel` char(36) NOT NULL,
  `RecentScore` int(11) DEFAULT NULL,
  `BestScore` int(11) DEFAULT NULL,
  `BestStarRating` int(11) DEFAULT NULL,
  `HighScoreLevel` char(36) DEFAULT NULL,
  `StudentAssignmentId` char(36) DEFAULT NULL,
  `ProfileId` char(36) NOT NULL,
  `locked` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `student_gameplay_tracking` (
  `PlayTrackingId` char(36) NOT NULL,
  `ProfileId` char(36) DEFAULT NULL,
  `ClassId` char(36) DEFAULT NULL,
  `ClassViewRegId` char(36) DEFAULT NULL,
  `SubjectId` char(36) DEFAULT NULL,
  `AllowedPlays` int(11) DEFAULT NULL,
  `PlayedCount` int(11) DEFAULT NULL,
  `PlayCountUpdate` bit(1) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `LastPlayedDate` datetime DEFAULT NULL,
  `CreatedBy` varchar(50) DEFAULT NULL,
  `LastModifiedDate` datetime DEFAULT NULL,
  `LastModifiedBy` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`PlayTrackingId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$




delimiter $$

CREATE TABLE `student_notes` (
  `AssignmentNoteId` char(36) NOT NULL,
  `ProfileId` char(36) NOT NULL,
  `AssignmentId` char(36) NOT NULL,
  `Viewed` bit(1) NOT NULL,
  `StudentNoteId` char(36) NOT NULL,
  `IsDeleted` bit(1) DEFAULT NULL,
  PRIMARY KEY (`StudentNoteId`),
  KEY `StudentNotes_AssignmentNotes_idx` (`AssignmentNoteId`),
  KEY `FK_StudentNotes_ProfileId_idx` (`ProfileId`),
  CONSTRAINT `FK_StudentNotes_ProfileId` FOREIGN KEY (`ProfileId`) REFERENCES `user_profiles` (`ProfileId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `StudentNotes_AssignmentNotes` FOREIGN KEY (`AssignmentNoteId`) REFERENCES `assignment_notes` (`AssignmentNoteId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `student_notifications` (
  `MessageId` char(36) NOT NULL,
  `ProfileId` char(36) NOT NULL,
  `AssignmentId` char(36) DEFAULT NULL,
  `ClassId` char(36) NOT NULL,
  `Message` longtext,
  `Viewed` tinyint(1) NOT NULL,
  `MessageType` longtext,
  `MessageCategory` longtext,
  `MessageGroup` longtext,
  `CreatedDate` datetime NOT NULL,
  `ModifiedDate` datetime NOT NULL,
  `SubjectId` char(36) DEFAULT NULL,
  `SendBy` varchar(45) DEFAULT NULL,
  `ClassViewRegId` char(36) NOT NULL,
  `CloudyMessageId` int(11) DEFAULT NULL,
  PRIMARY KEY (`MessageId`),
  KEY `FK_user_profiles_profileId_idx` (`ProfileId`),
  KEY `FK_notifications_ClassViewRegId_idx` (`ClassViewRegId`),
  CONSTRAINT `FK_notifications_ClassViewRegId` FOREIGN KEY (`ClassViewRegId`) REFERENCES `class_subjects` (`ClassViewRegId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_notifications_profileId` FOREIGN KEY (`ProfileId`) REFERENCES `user_profiles` (`ProfileId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `am_current_session` (
  `totalTries` int(11) DEFAULT NULL,
  `hints_used` int(11) DEFAULT NULL,
  `itemId` varchar(50) DEFAULT NULL,
  `studentAssignmentId` char(36) DEFAULT NULL,
  `IsActive` bit(1) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `AMCurrentSessionId` int(11) NOT NULL AUTO_INCREMENT,
  `ProfileID` char(36) DEFAULT NULL,
  `Buffer_Items` longtext,
  `SetItemIds` longtext,
  `KnewtonGoalId` char(36) DEFAULT NULL,
  PRIMARY KEY (`AMCurrentSessionId`),
  KEY `StudentAssignment_idx` (`studentAssignmentId`),
  KEY `StudentId_idx` (`ProfileID`),
  CONSTRAINT `StudentAssignment` FOREIGN KEY (`studentAssignmentId`) REFERENCES `student_assignments` (`StudentAssignmentId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `StudentId` FOREIGN KEY (`ProfileID`) REFERENCES `student_profiles` (`ProfileId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=utf8$$

delimiter $$

CREATE TABLE `profile_email_subscriptions` (
  `ProfileId` char(36) NOT NULL,
  `SubscriptionId` char(36) NOT NULL,
  `Subscribed` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`ProfileId`,`SubscriptionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$

delimiter $$

CREATE TABLE `roles_email_subscriptions` (
  `RoleId` char(36) NOT NULL,
  `SubscriptionId` char(36) NOT NULL,
  PRIMARY KEY (`RoleId`,`SubscriptionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$

