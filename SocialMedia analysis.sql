create database social_media;
use social_media;

-- users_table

create table users
(
user_id int primary key,
username varchar(25) NOT NULL,
name varchar(20),
location varchar(50)
);

-- post_table
create table posts
(
post_id int primary key,
user_id int,
content text,
timestamp datetime,
FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- likes_table
create table likes 
(
like_id int primary key,
post_id int,
user_id int,
timestamp datetime,
foreign key (user_id) references users(user_id),
foreign key (post_id) references posts(post_id)
);

-- comments
create table comments
(
comment_id int primary key,
post_id int,
user_id int,
content text,
timestamp datetime,
foreign key (user_id) references users(user_id),
foreign key (post_id) references posts(post_id)
);

INSERT INTO users (user_id, username, name, location)
VALUES 
(1, 'alice123', 'Alice Smith', 'New York'),
(2, 'bob456', 'Bob Jones', 'Los Angeles'),
(3, 'charlie789', 'Charlie Brown', 'Chicago');


INSERT INTO posts (post_id, user_id, content, timestamp)
VALUES 
(100, 1, 'Just finished reading a great book!', '2024-05-20'),
(101, 2, 'What are you guys up to this weekend?', '2024-05-21'),
(102, 3, 'Happy birthday to me!', '2024-05-25');


INSERT INTO likes (like_id, post_id, user_id, timestamp)
VALUES 
(1, 100, 2, '2024-05-20'),
(2, 100, 3, '2024-05-21'),
(3, 101, 1, '2024-05-21'),
(4, 102, 1, '2024-05-25');


INSERT INTO comments (comment_id, post_id, user_id, content, timestamp)
VALUES 
(1, 100, 3, 'This book sounds interesting!', '2024-05-21'),
(2, 101, 2, 'Let\'s go hiking!', '2024-05-22'),
(3, 102, 1, 'Happy birthday!', '2024-05-25');

-- For Most Active User

select u.user_id,u.username,count(p.post_id) as total_post,
count(l.like_id) as total_likes, count(c.comment_id) as total_comments,
(count(p.post_id)+count(l.like_id)+count(c.comment_id)) as total_interation
from users u
left join posts p on u.user_id = p.user_id
left join likes l on u.user_id = l.user_id
left join comments c on u.user_id = c.user_id
group by u.user_id,u.username
order by total_interation desc;

-- Most Popular Post By Likes 

SELECT p.post_id, p.content, COUNT(l.like_id) AS total_likes
FROM Posts p
LEFT JOIN Likes l ON p.post_id = l.post_id
GROUP BY p.post_id, p.content
ORDER BY total_likes DESC;

-- Top Commenting Users

SELECT u.user_id, u.username, COUNT(c.comment_id) AS total_comments
FROM Users u
LEFT JOIN Comments c ON u.user_id = c.user_id
GROUP BY u.user_id, u.username
ORDER BY total_comments DESC;

-- User Engagement by Location

SELECT u.location, 
       COUNT(p.post_id) AS total_posts, 
       COUNT(l.like_id) AS total_likes, 
       COUNT(c.comment_id) AS total_comments,
       (COUNT(p.post_id) + COUNT(l.like_id) + COUNT(c.comment_id)) AS total_interactions
FROM Users u
LEFT JOIN Posts p ON u.user_id = p.user_id
LEFT JOIN Likes l ON u.user_id = l.user_id
LEFT JOIN Comments c ON u.user_id = c.user_id
GROUP BY u.location
ORDER BY total_interactions DESC;

-- Average Daily Posts

SELECT AVG(daily_posts) AS avg_daily_posts
FROM (
    SELECT DATE(p.timestamp) AS post_date, COUNT(p.post_id) AS daily_posts
    FROM Posts p
    GROUP BY post_date
) AS subquery;

-- Most Active Days for Posting

SELECT DATE(p.timestamp) AS post_date, COUNT(p.post_id) AS total_posts
FROM Posts p
GROUP BY post_date
ORDER BY total_posts DESC;





