use ig_clone;

# Tables 
select * from comments;
select * from follows;
select * from likes;
select * from photo_tags;
select * from tags;
select * from users;
select * from photos;


# We want to reward the user who has been around the longest, Find the 5 oldest users.

select * from users
where year(created_at)='2017'
order by (created_at) asc ;

# To understand when to run the ad campaign, figure out the day of the week most users register on? 

select dayname(created_at) as day_name,count(*) from users
group by dayname(created_at)
order by count(*) desc limit 2;


# Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?

select u.username,u.id as user_id,p.id as photo_id,count(*) from likes l
inner join photos p
on l.photo_id=p.id
inner join users u
on p.user_id=u.id
group by photo_id
order by count(*) desc limit 1 ;

# To target inactive users in an email ad campaign, find the users who have never posted a photo.


select u.id as user_id,username,p.id as photo_id from users u
left join photos p
on u.id=p.user_id
where p.id is null 
order by u.id;


#6 The investors want to know how many times does the average user post.

create view avg_post_count
as
select id,count(*) as avg_time from photos 
group by user_id;

select avg(avg_time) from avg_post_count;


# A brand wants to knowu which hashtag to use on a post, and find the top 5 most used hashtags.

select p.tag_id,t.tag_name,count(*) from photo_tags p
inner join tags t
on p.tag_id=t.id
group by p.tag_id
order by count(*) desc limit 7;


# To find out if there are bots, find users who have liked every single photo on the site.

select user_id,count(*) from likes 
group by user_id
having count(*)=(select count(id) from photos);


# To know who the celebrities are, find users who have never commented on a photo.

select * from users u
left join comments c
on u.id=c.user_id
where comment_text is null 
order by u.id;


# Now it's time to find both of them together, find the users who have never commented on any photo or have commented on every photo.

(select u.id as user_id,username,comment_text,count(*)-1 as comment_count from users u
left join comments c
on u.id=c.user_id
where comment_text is null 
group by u.id
order by u.id asc)
UNION ALL
(select u.id as user_id,username,comment_text,count(*) as comment_count from users u
left join comments c
on u.id=c.user_id
group by u.id
having count(*)=(select count(id) from photos)
order by u.id asc);









