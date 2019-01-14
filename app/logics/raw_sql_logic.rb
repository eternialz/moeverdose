class RawSqlLogic
    def self.get_tags_array
        '   SELECT array_agg("tags"."id") as tags_list, "posts_tags"."post_id" as id
            FROM "tags" LEFT OUTER JOIN "posts_tags" ON "posts_tags"."tag_id" = "tags"."id"
            GROUP BY "posts_tags"."post_id" '
    end
end
