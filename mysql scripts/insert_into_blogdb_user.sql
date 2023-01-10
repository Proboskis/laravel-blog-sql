DELIMITER $$

CREATE PROCEDURE insert_into_blogdb_user(
	IN user_first_name VARCHAR(50),
    IN user_middle_name VARCHAR(50),
    IN user_last_name VARCHAR(50),
    IN user_mobile VARCHAR(15),
    IN user_email VARCHAR(50),
    IN user_password VARCHAR(32),
    IN user_intro TINYTEXT,
    IN user_profile TEXT
)
BEGIN
	INSERT INTO `blogdb`.`blogdb_user`(
		user_first_name,
		user_middle_name,
		User_last_name,
		user_mobile,
		user_email,
		user_password_hash,
		user_intro,
		user_profile
    ) VALUES (
		user_first_name,
		user_middle_name,
		user_last_name,
		user_mobile,
		user_email,
		MD5(user_password),
		user_intro,
		user_profile
    )
END$$

DELIMITER ;