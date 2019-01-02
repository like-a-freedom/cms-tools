INSERT INTO likeafreed_koken.koken_text(
    id,
    title,
    content,
    excerpt,
    created_on,
    published_on,
    modified_on,
    published,
    page_type,
    internal_id
)
SELECT
    ID,
    post_title,
    post_content,
    post_excerpt,
    UNIX_TIMESTAMP(post_date),
    UNIX_TIMESTAMP(post_date),
    UNIX_TIMESTAMP(post_modified),
    1,
    0,
    MD5(CONCAT(post_title, post_date))
FROM
    likeafreed_wordpress.wp_posts
WHERE
    post_status = 'publish' AND post_content != '' AND post_type = 'post'