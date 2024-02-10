-- Drop all the previous tables in the database
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

-- Create sequence for photo_id in Photos table
CREATE SEQUENCE photo_id_seq
    START WITH 1
    INCREMENT BY 1;

-- Create sequence for tag_photo_id in Tags table
CREATE SEQUENCE tag_photo_id_seq
    START WITH 1
    INCREMENT BY 1;

-- Create sequence for tag_subject_id in Tags table
CREATE SEQUENCE tag_subject_id_seq
    START WITH 1
    INCREMENT BY 1;

-- Create Users table
CREATE TABLE Users (
    user_id INTEGER PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    year_of_birth INTEGER,
    month_of_birth INTEGER,
    day_of_birth INTEGER,
    gender VARCHAR(100)
);

-- Create Friends table with trigger
CREATE TABLE Friends (
    user1_id INTEGER NOT NULL,
    user2_id INTEGER NOT NULL,
    CONSTRAINT fk_friends_user1 FOREIGN KEY (user1_id) REFERENCES Users(user_id),
    CONSTRAINT fk_friends_user2 FOREIGN KEY (user2_id) REFERENCES Users(user_id),
    CONSTRAINT pk_friends PRIMARY KEY (user1_id, user2_id),
    CHECK (user1_id < user2_id)
);

-- Create trigger for sorting friend pairs
CREATE OR REPLACE FUNCTION order_friend_pairs()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.user1_id > NEW.user2_id THEN
        NEW.user1_id = NEW.user1_id + NEW.user2_id;
        NEW.user2_id = NEW.user1_id - NEW.user2_id;
        NEW.user1_id = NEW.user1_id - NEW.user2_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER order_friend_pairs_trigger
BEFORE INSERT ON Friends
FOR EACH ROW
EXECUTE FUNCTION order_friend_pairs();

-- Create Cities table
CREATE TABLE Cities (
    city_id INTEGER PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    country_name VARCHAR(100) NOT NULL
);

-- Create User_Current_Cities table
CREATE TABLE User_Current_Cities (
    user_id INTEGER NOT NULL,
    current_city_id INTEGER NOT NULL,
    CONSTRAINT fk_user_current_cities_user FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT fk_user_current_cities_city FOREIGN KEY (current_city_id) REFERENCES Cities(city_id)
);

-- Create User_Hometown_Cities table
CREATE TABLE User_Hometown_Cities (
    user_id INTEGER NOT NULL,
    hometown_city_id INTEGER NOT NULL,
    CONSTRAINT fk_user_hometown_cities_user FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT fk_user_hometown_cities_city FOREIGN KEY (hometown_city_id) REFERENCES Cities(city_id)
);

-- Create Messages table
CREATE TABLE Messages (
    message_id INTEGER PRIMARY KEY,
    sender_id INTEGER NOT NULL,
    receiver_id INTEGER NOT NULL,
    message_content VARCHAR(2000) NOT NULL,
    sent_time TIMESTAMP NOT NULL,
    CONSTRAINT fk_messages_sender FOREIGN KEY (sender_id) REFERENCES Users(user_id),
    CONSTRAINT fk_messages_receiver FOREIGN KEY (receiver_id) REFERENCES Users(user_id)
);

-- Create Programs table
CREATE TABLE Programs (
    program_id INTEGER PRIMARY KEY,
    institution VARCHAR(100) NOT NULL,
    concentration VARCHAR(100) NOT NULL,
    degree VARCHAR(100) NOT NULL
);

-- Create Education table
CREATE TABLE Education (
    user_id INTEGER NOT NULL,
    program_id INTEGER NOT NULL,
    program_year INTEGER NOT NULL,
    CONSTRAINT fk_education_user FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT fk_education_program FOREIGN KEY (program_id) REFERENCES Programs(program_id)
);

-- Create User_Events table
CREATE TABLE User_Events (
    event_id INTEGER PRIMARY KEY,
    event_creator_id INTEGER NOT NULL,
    event_name VARCHAR(100) NOT NULL,
    event_tagline VARCHAR(100),
    event_description VARCHAR(100),
    event_host VARCHAR(100),
    event_type VARCHAR(100),
    event_subtype VARCHAR(100),
    event_address VARCHAR(2000),
    event_city_id INTEGER NOT NULL,
    event_start_time TIMESTAMP,
    event_end_time TIMESTAMP,
    CONSTRAINT fk_user_events_creator FOREIGN KEY (event_creator_id) REFERENCES Users(user_id),
    CONSTRAINT fk_user_events_city FOREIGN KEY (event_city_id) REFERENCES Cities(city_id)
);

-- Create Participants table
CREATE TABLE Participants (
    event_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    confirmation VARCHAR(100) NOT NULL,
--     CONSTRAINT fk_participants_event FOREIGN KEY (event_id) REFERENCES User_Events(event_id),
    CONSTRAINT fk_participants_user FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT ck_participants_confirmation CHECK (confirmation IN ('Attending', 'Unsure', 'Declines', 'Not_Replied'))
);

-- Create Albums table
CREATE TABLE Albums (
    album_id INTEGER PRIMARY KEY,
    album_owner_id INTEGER NOT NULL,
    album_name VARCHAR(100) NOT NULL,
    album_created_time TIMESTAMP NOT NULL,
    album_modified_time TIMESTAMP,
    album_link VARCHAR(2000) NOT NULL,
    album_visibility VARCHAR(100) NOT NULL,
    cover_photo_id INTEGER NOT NULL,
    CONSTRAINT fk_albums_owner FOREIGN KEY (album_owner_id) REFERENCES Users(user_id),
    CONSTRAINT ck_albums_visibility CHECK (album_visibility IN ('Everyone', 'Friends', 'Friends_Of_Friends', 'Myself'))
);

-- Create Photos table with sequence
CREATE TABLE Photos (
    photo_id INTEGER PRIMARY KEY DEFAULT NEXTVAL('photo_id_seq'),
    album_id INTEGER NOT NULL,
    photo_caption VARCHAR(2000),
    photo_created_time TIMESTAMP NOT NULL,
    photo_modified_time TIMESTAMP,
    photo_link VARCHAR(2000) NOT NULL,
    CONSTRAINT fk_photos_album FOREIGN KEY (album_id) REFERENCES Albums(album_id)
);

-- Create Tags table with sequences
CREATE TABLE Tags (
    tag_photo_id INTEGER DEFAULT NEXTVAL('tag_photo_id_seq') NOT NULL,
    tag_subject_id INTEGER DEFAULT NEXTVAL('tag_subject_id_seq') NOT NULL,
    tag_created_time TIMESTAMP NOT NULL,
    tag_x NUMERIC NOT NULL,
    tag_y NUMERIC NOT NULL,
    CONSTRAINT fk_tags_photo FOREIGN KEY (tag_photo_id) REFERENCES Photos(photo_id),
    CONSTRAINT fk_tags_subject FOREIGN KEY (tag_subject_id) REFERENCES Users(user_id),
    CONSTRAINT pk_tags PRIMARY KEY (tag_photo_id, tag_subject_id)
);