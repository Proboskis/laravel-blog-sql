DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_posts`()
BEGIN
	SELECT * FROM products;
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_post_by_id`(IN input_id BIGINT)
BEGIN
	SELECT * FROM posts WHERE id = input_id;
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
-- DROP PROCEDURE create_post;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_post`(
	IN user_id BIGINT,
    IN post_parent_id BIGINT,
    IN title VARCHAR(25),
    IN meta_title VARCHAR(100),
    IN slug VARCHAR(100),
    IN summary TINYTEXT,
    IN content TEXT
)
BEGIN
	SET @post_parent_id = post_parent_id;
	IF @post_parent_id <= 0 THEN SET @post_parent_id = NULL;
    END IF;
	-- IF  published = 0 THEN SET published = 0; END IF;
	INSERT INTO `posts` (user_id, post_parent_id, title, meta_title, slug, summary, content)
VALUES (
	user_id,
    @post_parent_id,
    title,
    meta_title,
    slug,
    summary,
    content
);
-- SELECT "Procedure completed, new post was created succesfully." as "Result";
CALL get_all_posts();
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_post`(
	IN id BIGINT,
	IN user_id BIGINT,
    IN post_parent_id BIGINT,
    IN title VARCHAR(25),
    IN meta_title VARCHAR(100),
    IN slug VARCHAR(100),
    IN summary TINYTEXT,
    IN published TINYINT(0),
    IN content TEXT
)
BEGIN
	IF  post_parent_id = '0' THEN SET post_parent_id = NULL; END IF;
	SET @user_id = user_id;
    SET @post_parent_id = post_parent_id;
    SET @title = title;
    SET @meta_title = meta_title;
    SET @slug = slug;
    SET @summary = summary;
    SET @published = published;
    SET @content = content;
UPDATE users
    SET id = @user_id;
UPDATE posts
    SET user_id = @user_id,
    post_parent_id = @post_parent_id,
    title = @title,
    meta_title = @meta_title,
    slug = @slug,
    summary = @summary,
    published = @published,
    content = @content WHERE posts.id = id;
CALL get_post_by_id(id);
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_post`(IN input_id BIGINT)
BEGIN
	DELETE FROM posts WHERE id = input_id;
    SELECT CONCAT("Procedure completed, post with id ", input_id, " was deleted succesfully.") as "Result";
END $$
DELIMITER ;