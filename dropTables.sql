-- Drop constraints before dropping Tables
ALTER TABLE Tags DROP CONSTRAINT IF EXISTS fk_tags_subject CASCADE;
ALTER TABLE Friends DROP CONSTRAINT IF EXISTS fk_friends_user1 CASCADE;
ALTER TABLE Friends DROP CONSTRAINT IF EXISTS fk_friends_user2 CASCADE;
ALTER TABLE Participants DROP CONSTRAINT IF EXISTS fk_participants_event CASCADE;
ALTER TABLE Participants DROP CONSTRAINT IF EXISTS fk_participants_user CASCADE;
ALTER TABLE User_Events DROP CONSTRAINT IF EXISTS fk_user_events_creator CASCADE;
ALTER TABLE User_Events DROP CONSTRAINT IF EXISTS fk_user_events_city CASCADE;
ALTER TABLE Education DROP CONSTRAINT IF EXISTS fk_education_user CASCADE;
ALTER TABLE Education DROP CONSTRAINT IF EXISTS fk_education_program CASCADE;
ALTER TABLE User_Hometown_Cities DROP CONSTRAINT IF EXISTS fk_user_hometown_cities_user CASCADE;
ALTER TABLE User_Hometown_Cities DROP CONSTRAINT IF EXISTS fk_user_hometown_cities_city CASCADE;
ALTER TABLE User_Current_Cities DROP CONSTRAINT IF EXISTS fk_user_current_cities_user CASCADE;
ALTER TABLE User_Current_Cities DROP CONSTRAINT IF EXISTS fk_user_current_cities_city CASCADE;
ALTER TABLE Messages DROP CONSTRAINT IF EXISTS fk_messages_sender CASCADE;
ALTER TABLE Messages DROP CONSTRAINT IF EXISTS fk_messages_receiver CASCADE;
ALTER TABLE Photos DROP CONSTRAINT IF EXISTS fk_photos_album CASCADE;
ALTER TABLE Albums DROP CONSTRAINT IF EXISTS fk_albums_cover_photo CASCADE;

-- Drop all data tables
DROP TABLE IF EXISTS Participants;
DROP TABLE IF EXISTS User_Events;
DROP TABLE IF EXISTS Education;
DROP TABLE IF EXISTS Programs;
DROP TABLE IF EXISTS Messages;
DROP TABLE IF EXISTS User_Hometown_Cities;
DROP TABLE IF EXISTS User_Current_Cities;
DROP TABLE IF EXISTS Cities;
DROP TABLE IF EXISTS Friends;
DROP TABLE IF EXISTS Tags;
DROP TABLE IF EXISTS Photos;
DROP TABLE IF EXISTS Albums;
DROP TABLE IF EXISTS Users;

-- Drop Sequences
DROP SEQUENCE IF EXISTS photo_id_seq CASCADE;
DROP SEQUENCE IF EXISTS tag_photo_id_seq CASCADE;
DROP SEQUENCE IF EXISTS tag_subject_id_seq CASCADE;

-- Drop triggers and functions
DROP TRIGGER IF EXISTS order_friend_pairs_trigger ON Friends;
DROP FUNCTION IF EXISTS order_friend_pairs();
