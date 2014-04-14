/*(select TeacherId from class_teachers where class_teachers.ClassViewRegId in (select ClassViewRegId from class_subjects where class_subjects.ClassId  in (select ClassId from class inner join schools where schools.SchoolId=class.SchoolId)));

select distinct  t1.ClassId,t1.SchoolId from class as t1 join schools t2 on t1.SchoolId=t2.SchoolId;
*/

/*1.Write a query to get all the users whole belong to a Role Teacher for a given schoolId  */

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
	select distinct tp.ProfileId ,up.LastName,r.RoleName  from roles as r 
	join user_roles ur
		on r.RoleId=ur.RoleId
	join teacher_profiles tp
		on ur.UserId=tp.ProfileId
	join user_profiles up
		on tp.ProfileId=up.ProfileId
	join user_profiles_school ups
		on  up.ProfileId = ups.ProfileId
	join schools scls
		on ups.SchoolId=scls.SchoolId
	where r.RoleName='Teacher' or r.RoleName='School Admin' and tp.active='on'; 
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;

/*2.Write a query to get all Students and teachers for a given schoolId  */

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
	select up.FirstName,up.ProfileId from user_profiles as up
		left join student_profiles sp 
			on up.ProfileId=sp.ProfileId 
		left join teacher_profiles tp
			on up.ProfileId=tp.ProfileId
		join user_profiles_school ups
			on up.ProfileId=ups.ProfileId	
		where ups.SchoolId=SchoolId and tp.active='on' or sp.Active='on';
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;

/*3.Write a query to get all classes for a given teacherId  */

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
	select distinct cls.ClassName from class as cls
	join class_teachers ct
		on cls.ClassId=ct.ClassId
	join teacher_profiles tp
		on ct.TeacherId=tp.ProfileId
	where tp.active='on';
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;

/* 4.Write a query to get all the students for a given groupId  */

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
	select distinct sg.ProfileId,up.FirstName from user_profiles as up
	join student_profiles sp
		on up.profileId=sp.ProfileId
	join student_group sg
		on sp.ProfileId=sg.ProfileId
	join waggle_latest.group grp
		on sg.GroupId=grp.GroupId
	where sp.Active='on';
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;


/* 5.Write a query to get all the assignments assigned to a student for a given studentId  */

/* for students*/
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
	select distinct a1.assignmentName,sa.ProfileId from assignments as a1
	join assignment_assigned aa
		on a1.AssignmentId=aa.AssignmentId
	join student_assignments sa
		on aa.AssignedToId=sa.ProfileId
	join student_profiles sp
		on sa.ProfileId=sp.ProfileId
where sp.Active='on';
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;

/* for class */

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
	select distinct a1.assignmentName,aa.AssignedToId from assignments as a1
	join assignment_assigned aa
		on a1.AssignmentId=aa.AssignmentId
	join student_assignments sa
		on aa.AssignedToId=sa.ClassId
	join student_profiles sp
		on sa.ProfileId=sp.ProfileId
	where sp.Active='on';
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;

/* 6.Write a query to get all the students who don't have any assignments  */

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
	select ProfileId from student_profiles as sp
	 where sp.Active='on' and ProfileId not in (select ProfileId from student_assignments);

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;