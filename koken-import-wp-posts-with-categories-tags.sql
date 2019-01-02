-- Posts import
INSERT INTO
    likeafreed_koken.koken_text(
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
    post_status = 'publish'
    AND post_content != ''
    AND post_type = 'post';-- Tags import
INSERT INTO
    likeafreed_koken.koken_tags(
        id,
        name,
        created_on,
        modified_on,
        last_used,
        text_count
    )
SELECT
    likeafreed_wordpress.wp_terms.term_id AS TagID,
    LOWER(
        REPLACE(likeafreed_wordpress.wp_terms.name, ' ', '-')
    ) AS tag_slug,
    unix_timestamp(now()) AS created_at,
    unix_timestamp(now()) AS modified_at,
    unix_timestamp(now()) AS last_used_at,
    SUM(tax.count) AS TagPostCount
FROM
    likeafreed_wordpress.wp_terms
    INNER JOIN likeafreed_wordpress.wp_term_taxonomy tax ON tax.term_id = likeafreed_wordpress.wp_terms.term_id
GROUP BY
    likeafreed_wordpress.wp_terms.term_id;-- Tags relations import
INSERT INTO
    likeafreed_koken.koken_join_tags_text(id, tag_id, text_id)
SELECT
    '',
    tt.term_id,
    p.id
FROM
    wp_posts AS p
    JOIN wp_term_relationships AS tr ON p.id = tr.object_id
    JOIN wp_term_taxonomy AS tt ON tr.term_taxonomy_id = tt.term_taxonomy_id
    JOIN wp_terms AS t ON tt.term_id = t.term_id
ORDER BY
    post_title DESC;-- Categories import
INSERT INTO
    likeafreed_koken.koken_categories(id, title, slug, text_count)
SELECT
    tax.term_id,
    term.name,
    term.slug,
    tax.count
FROM
    wp_term_taxonomy tax
    LEFT JOIN wp_terms term ON term.term_id = tax.term_id
WHERE
    tax.taxonomy = 'category'
ORDER BY
    tax.count DESC;-- Categories relations import
INSERT INTO
    likeafreed_koken.koken_join_categories_text(id, text_id, category_id)
SELECT
    '',
    p.id,
    c.term_id as category_term_id
FROM
    likeafreed_wordpress.wp_posts p
    JOIN likeafreed_wordpress.wp_term_relationships cr on (p.id = cr.object_id)
    JOIN likeafreed_wordpress.wp_term_taxonomy ct on (
        ct.term_taxonomy_id = cr.term_taxonomy_id
        and ct.taxonomy = 'category'
    )
    JOIN likeafreed_wordpress.wp_terms c on (ct.term_id = c.term_id)
    JOIN likeafreed_wordpress.wp_term_relationships tr on (p.id = tr.object_id)
    JOIN likeafreed_wordpress.wp_term_taxonomy tt on (
        tt.term_taxonomy_id = tr.term_taxonomy_id
        and tt.taxonomy = 'post_tag'
    )
    JOIN likeafreed_wordpress.wp_terms t on (tt.term_id = t.term_id)
GROUP BY
    p.id;