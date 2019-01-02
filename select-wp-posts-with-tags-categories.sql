SELECT
    p.id,
    p.post_title,
    p.post_content,
    p.post_excerpt,
    unix_timestamp(p.post_date) as post_created_on,
    unix_timestamp(p.post_date) as post_published_on,
    unix_timestamp(p.post_modified) as post_modified_on,
    1,
    0,
    md5(CONCAT(p.post_title,p.post_date)) as post_id,
    p.post_name,
   	c.term_id as category_term_id,
    c.name as category,
    GROUP_CONCAT(t.term_id) as tags_id,
    GROUP_CONCAT(t.name) as tags
FROM wp_posts p
JOIN wp_term_relationships cr
    on (p.id=cr.object_id)
JOIN wp_term_taxonomy ct
    on (ct.term_taxonomy_id=cr.term_taxonomy_id
    and ct.taxonomy='category')
JOIN wp_terms c on
    (ct.term_id=c.term_id)
JOIN wp_term_relationships tr
    on (p.id=tr.object_id)
JOIN wp_term_taxonomy tt
    on (tt.term_taxonomy_id=tr.term_taxonomy_id
    and tt.taxonomy='post_tag')
JOIN wp_terms t
    on (tt.term_id=t.term_id)
GROUP BY p.id