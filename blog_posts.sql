DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_posts`()
BEGIN
	SELECT * FROM posts;
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_post_by_id`(IN input_id BIGINT(20))
BEGIN
	SELECT * FROM posts WHERE id = input_id;
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DROP PROCEDURE create_post;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_post`(
	IN user_id BIGINT(20),
    IN post_parent_id BIGINT(20),
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
DROP PROCEDURE update_post;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_post`(
	IN id BIGINT(20),
	IN user_id BIGINT(20),
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
DROP PROCEDURE delete_post;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_post`(IN input_id BIGINT(20))
BEGIN
	DELETE FROM posts WHERE id = input_id;
    SELECT CONCAT("Procedure completed, post with id ", input_id, " was deleted succesfully.") as "Result";
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DROP PROCEDURE search_by_post_title;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `search_by_post_title`(IN input_title VARCHAR(25))
BEGIN
	SET @input_title = input_title;
	SELECT * FROM posts WHERE title LIKE CONCAT('%', @input_title, '%');
END $$
DELIMITER ; 
-- it is important to set the collation for the posts table to utf8mb4_general_ci in order for the stored procedure above to work
alter table posts convert to character set utf8mb4 collate utf8mb4_general_ci;
-- ------------------------------------------------------------------------------
-- tags
-- ------------------------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_tags`()
BEGIN
	SELECT * FROM tags;
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DROP PROCEDURE get_tag_by_id;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tag_by_id`(IN input_id BIGINT(20))
BEGIN
	SELECT * FROM tags WHERE id = input_id;
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DROP PROCEDURE create_tag;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_tag`(
    IN title VARCHAR(25),
    IN meta_title VARCHAR(100),
    IN slug VARCHAR(100),
    IN content TEXT
)
BEGIN
	INSERT INTO `tags` (title, meta_title, slug, content)
VALUES (
    title,
    meta_title,
    slug,
    content
);
-- SELECT "Procedure completed, new category was created succesfully." as "Result";
CALL get_all_tags();
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DROP PROCEDURE `update_tag`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_tag`(
	IN id BIGINT(20),
    IN title VARCHAR(25),
    IN meta_title VARCHAR(100),
    IN slug VARCHAR(100),
    IN content TEXT
)
BEGIN
    SET @title = title;
    SET @meta_title = meta_title;
    SET @slug = slug;
    SET @content = content;
UPDATE categories
    SET title = @title,
    meta_title = @meta_title,
    slug = @slug,
    content = @content WHERE categories.id = id;
CALL get_tag_by_id(id);
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DROP PROCEDURE delete_tag;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_tag`(IN input_id BIGINT(20))
BEGIN
	DELETE  FROM tags WHERE id = input_id;
    SELECT CONCAT("Procedure completed, tag with id ", input_id, " was deleted succesfully.") as "Result";
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DROP PROCEDURE search_by_tag_title;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `search_by_tag_title`(IN input_title VARCHAR(25))
BEGIN
	SET @input_title = input_title;
	SELECT * FROM tags WHERE title LIKE CONCAT('%', @input_title, '%');
END $$
DELIMITER ; 
-- it is important to set the collation for the posts table to utf8mb4_general_ci in order for the stored procedure above to work
alter table tags convert to character set utf8mb4 collate utf8mb4_general_ci;
-- ------------------------------------------------------------------------------
-- categories
-- ------------------------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_categories`()
BEGIN
	SELECT * FROM categories;
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_category_by_id`(IN input_id BIGINT(20))
BEGIN
	SELECT * FROM categories WHERE id = input_id;
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DROP PROCEDURE create_category;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_category`(
    IN category_parent_id BIGINT(20),
    IN title VARCHAR(25),
    IN meta_title VARCHAR(100),
    IN slug VARCHAR(100),
    IN content TEXT
)
BEGIN
	SET @category_parent_id = category_parent_id;
	IF @category_parent_id <= 0 THEN SET @category_parent_id = NULL; END IF;
	INSERT INTO `categories` (category_parent_id, title, meta_title, slug, content)
VALUES (
    @category_parent_id,
    title,
    meta_title,
    slug,
    content
);
-- SELECT "Procedure completed, new category was created succesfully." as "Result";
CALL get_all_categories();
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DROP PROCEDURE `update_category`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_category`(
	IN id BIGINT(20),
    IN category_parent_id BIGINT(20),
    IN title VARCHAR(25),
    IN meta_title VARCHAR(100),
    IN slug VARCHAR(100),
    IN content TEXT
)
BEGIN
	IF  category_parent_id = '0' THEN SET category_parent_id = NULL; END IF;
    SET @category_parent_id = category_parent_id;
    SET @title = title;
    SET @meta_title = meta_title;
    SET @slug = slug;
    SET @content = content;
UPDATE categories
    SET category_parent_id = @category_parent_id,
    title = @title,
    meta_title = @meta_title,
    slug = @slug,
    content = @content WHERE categories.id = id;
CALL get_category_by_id(id);
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DROP PROCEDURE delete_category;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_category`(IN input_id BIGINT(20))
BEGIN
	DELETE FROM categories WHERE id = input_id;
    SELECT CONCAT("Procedure completed, category with id ", input_id, " was deleted succesfully.") as "Result";
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DROP PROCEDURE search_by_category_title;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `search_by_category_title`(IN input_title VARCHAR(25))
BEGIN
	SET @input_title = input_title;
	SELECT * FROM categories WHERE title LIKE CONCAT('%', @input_title, '%');
END $$
DELIMITER ; 
-- it is important to set the collation for the posts table to utf8mb4_general_ci in order for the stored procedure above to work
alter table categories convert to character set utf8mb4 collate utf8mb4_general_ci;
-- ------------------------------------------------------------------------------
-- comments
-- ------------------------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_comments`()
BEGIN
	SELECT * FROM comments;
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_comment_by_id`(IN input_id BIGINT(20))
BEGIN
	SELECT * FROM comments WHERE id = input_id;
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DROP PROCEDURE create_comment;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_comment`(
	IN post_id BIGINT(20),
    IN comment_parent_id BIGINT(20),
    IN title VARCHAR(25),
    IN published TINYINT(0),
    IN content TEXT
)
BEGIN
	IF comment_parent_id <= 0 THEN SET @comment_parent_id = NULL; END IF;
	INSERT INTO `comments` (post_id, comment_parent_id, title, published, content)
VALUES (post_id, @comment_parent_id, title, published, content);
-- SELECT "Procedure completed, new category was created succesfully." as "Result";
CALL get_all_comments();
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DROP PROCEDURE `update_comment`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_comment`(
	IN id BIGINT(20),
	IN post_id BIGINT(20),
    IN comment_parent_id BIGINT(20),
    IN title VARCHAR(25),
    IN published TINYINT(0),
    IN content TEXT
)
BEGIN
	SET @post_id = post_id;
    SET @comment_parent_id = comment_parent_id;
    SET @title = title;
    SET @published = published;
    SET @content = content;
	IF comment_parent_id <= 0 THEN SET @comment_parent_id = NULL; END IF;
UPDATE comments
    SET post_id = @post_id,
    comment_parent_id = @comment_parent_id,
    title = @title,
    published = @published,
    content = @content WHERE comments.id = id;
CALL get_comment_by_id(id);
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DROP PROCEDURE delete_comment;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_comment`(IN input_id BIGINT(20))
BEGIN
	DELETE FROM comments WHERE id = input_id;
    SELECT CONCAT("Procedure completed, comment with id ", input_id, " was deleted succesfully.") as "Result";
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
-- post_metas
-- ------------------------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_post_metas`()
BEGIN
	SELECT * FROM post_metas;
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_post_meta_by_id`(IN input_id BIGINT(20))
BEGIN
	SELECT * FROM post_metas WHERE id = input_id;
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DROP PROCEDURE create_post_meta;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_post_meta`(
	IN post_id BIGINT(20),
    IN meta_key VARCHAR(20),
    IN meta_value TEXT
)
BEGIN
	INSERT INTO `post_metas` (post_id, meta_key, meta_value)
VALUES (post_id, meta_key, meta_value);
-- SELECT "Procedure completed, new category was created succesfully." as "Result";
CALL get_all_post_metas();
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DROP PROCEDURE `update_post_meta`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_post_meta`(
	IN id BIGINT(20),
	IN post_id BIGINT(20),
    IN meta_key VARCHAR(20),
    IN meta_value TEXT
)
BEGIN
	SET @post_id = post_id;
    SET @meta_key = meta_key;
    SET @meta_value = meta_value;
UPDATE post_metas
    SET post_id = @post_id,
    meta_key = @meta_key,
    meta_value = @meta_value WHERE post_metas.id = id;
CALL get_post_meta_by_id(id);
END $$
DELIMITER ;
-- ------------------------------------------------------------------------------
DROP PROCEDURE delete_post_meta;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_post_meta`(IN input_id BIGINT(20))
BEGIN
	DELETE FROM post_metas WHERE id = input_id;
    SELECT CONCAT("Procedure completed, post meta with id ", input_id, " was deleted succesfully.") as "Result";
END $$
DELIMITER ;