-- Insert data into Users table
INSERT INTO public.Users (user_id, first_name, last_name, year_of_birth, month_of_birth, day_of_birth, gender)
SELECT user_id, first_name, last_name, year_of_birth, month_of_birth, day_of_birth, gender
FROM Public_User_Information;

-- Insert data into Friends table
INSERT INTO public.Friends (user1_id, user2_id)
SELECT LEAST(user1_id, user2_id), GREATEST(user1_id, user2_id)
FROM Public_Are_Friends
GROUP BY LEAST(user1_id, user2_id), GREATEST(user1_id, user2_id);

-- Insert data into Cities table
INSERT INTO public.Cities (city_id, city_name, state_name, country_name)
SELECT city_id, current_city, current_state, current_country
FROM (
    SELECT ROW_NUMBER() OVER () AS city_id, current_city, current_state, current_country
    FROM (SELECT DISTINCT current_city, current_state, current_country FROM Public_User_Information) AS distinct_cities
) AS cities;

-- Insert data into User_Current_Cities table
INSERT INTO public.User_Current_Cities (user_id, current_city_id)
SELECT user_id, city_id
FROM Public_User_Information
JOIN Cities ON current_city = city_name AND current_state = state_name AND current_country = country_name;

-- Insert data into User_Hometown_Cities table
INSERT INTO public.User_Hometown_Cities (user_id, hometown_city_id)
SELECT user_id, city_id
FROM Public_User_Information
JOIN Cities ON hometown_city = city_name AND hometown_state = state_name AND hometown_country = country_name;

-- Insert data into Messages table
INSERT INTO public.Messages (message_id, sender_id, receiver_id, message_content, sent_time)
SELECT ROW_NUMBER() OVER () AS message_id,
       f.user1_id AS sender_id,
       f.user2_id AS receiver_id,
       'Sample message content' AS message_content, -- Replace with actual message content
       CURRENT_TIMESTAMP AS sent_time -- Assuming the message is sent at the current time
FROM Public_Are_Friends f;

-- Insert data into Programs table with program_id
INSERT INTO public.Programs (program_id, institution, concentration, degree)
SELECT ROW_NUMBER() OVER (ORDER BY institution_name, program_concentration, program_degree) AS program_id,
       institution_name,
       program_concentration,
       program_degree
FROM (
    SELECT DISTINCT institution_name, program_concentration, program_degree
    FROM Public_User_Information
) AS unique_programs;

-- Insert data into User_Events table with event_id
INSERT INTO public.User_Events (event_id, event_creator_id, event_name, event_tagline, event_description, event_host, event_type, event_subtype, event_address, event_city_id, event_start_time, event_end_time)
SELECT
    ROW_NUMBER() OVER (ORDER BY event_name) AS event_id,
    event_creator_id,
    event_name,
    event_tagline,
    event_description,
    event_host,
    event_type,
    event_subtype,
    event_address,
    c.city_id, -- Assuming city_id is retrieved based on event_city, event_state, and event_country
    event_start_time,
    event_end_time
FROM
    Public_Event_Information pei
JOIN
    public.Cities c ON pei.event_city = c.city_name AND pei.event_state = c.state_name AND pei.event_country = c.country_name;

-- -- Insert data into Participants table with participant_id
INSERT INTO public.Participants (event_id, user_id, confirmation)
SELECT
    ROW_NUMBER() OVER () AS participant_id,
    user_id,
    'Attending' AS confirmation -- Default confirmation status
FROM
    (SELECT DISTINCT event_creator_id AS user_id FROM Public_Event_Information
     UNION
     SELECT DISTINCT user1_id AS user_id FROM Public_Are_Friends
     UNION
     SELECT DISTINCT user2_id AS user_id FROM Public_Are_Friends) AS users;

-- Insert data into Albums table with visibility mapping
INSERT INTO public.Albums (album_id, album_owner_id, album_name, album_created_time, album_modified_time, album_link, album_visibility, cover_photo_id)
SELECT
    ROW_NUMBER() OVER () AS album_id,
    owner_id,
    album_name,
    album_created_time,
    album_modified_time,
    album_link,
    CASE
        WHEN album_visibility = 'Public' THEN 'Everyone'
        WHEN album_visibility = 'Private' THEN 'Myself'
        ELSE 'Everyone' -- Default to 'Everyone' for any other visibility value
    END AS album_visibility,
    cover_photo_id
FROM
    Public_Photo_Information;

-- Insert data into Photos table with photo_id
INSERT INTO public.Photos (photo_id, album_id, photo_caption, photo_created_time, photo_modified_time, photo_link)
SELECT
    ROW_NUMBER() OVER () AS photo_id,
    album_id,
    'Sample caption' AS photo_caption, -- Replace with actual caption
    CURRENT_TIMESTAMP AS photo_created_time, -- Assuming photo creation time is current time
    CURRENT_TIMESTAMP AS photo_modified_time, -- Assuming photo modification time is current time
    'http://example.com/photo.jpg' AS photo_link -- Replace with actual photo link
FROM
    Public_Tag_Information; -- Assuming data is derived from existing photos with tags

-- Insert data into Tags table with tag_id
INSERT INTO public.Tags (tag_photo_id, tag_subject_id, tag_created_time, tag_x, tag_y)
SELECT
    ROW_NUMBER() OVER () AS tag_photo_id,
    user_id AS tag_subject_id,
    CURRENT_TIMESTAMP AS tag_created_time, -- Assuming tag creation time is current time
    0.0 AS tag_x, -- Sample value for tag_x
    0.0 AS tag_y -- Sample value for tag_y
FROM
    Public_User_Information; -- Assuming data is derived from users

