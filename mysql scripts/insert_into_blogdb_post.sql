DELIMITER $$

CREATE PROCEDURE insert_into_blogdb_post(
	IN post_parent_id BIGINT(20),
	IN post_title VARCHAR(75),
	IN post_meta_title VARCHAR(100),
    IN post_slug VARCHAR(100),
    IN post_summary TINYTEXT,
    IN post_published,
    IN post_content
)
BEGIN
	INSERT INTO `blogdb`.`blogdb_post`(
		post_parent,
        post_title,
        post_meta_title,
        post_slug,
        post_summary,
        post_published,
        post_content
    ) VALUES (
		post_parent_id,
		post_title,
		post_meta_title,
		post_slug,
		post_summary,
		post_published,
		post_content
    )
END$$

