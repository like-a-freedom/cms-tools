SELECT
    p.id,
    p.post_title,
    p.post_content,
    p.post_excerpt,
    unix_timestamp(p.post_date),
    unix_timestamp(p.post_date),
    unix_timestamp(p.post_modified),
    1,
    0,
    md5(CONCAT(p.post_title,p.post_date)),
    p.post_name,
    c.name,
    GROUP_CONCAT(t.`name`)
FROM wp_posts p
JOIN wp_term_relationships cr
    on (p.`id`=cr.`object_id`)
JOIN wp_term_taxonomy ct
    on (ct.`term_taxonomy_id`=cr.`term_taxonomy_id`
    and ct.`taxonomy`='category')
JOIN wp_terms c on
    (ct.`term_id`=c.`term_id`)
JOIN wp_term_relationships tr
    on (p.`id`=tr.`object_id`)
JOIN wp_term_taxonomy tt
    on (tt.`term_taxonomy_id`=tr.`term_taxonomy_id`
    and tt.`taxonomy`='post_tag')
JOIN wp_terms t
    on (tt.`term_id`=t.`term_id`)
GROUP BY p.id