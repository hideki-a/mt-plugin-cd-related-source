<?php
function smarty_block_mtcontentrelatedsources($args, $out, &$ctx, &$repeat)
{
    $localvars = array(
        'content',
        '_content_data',
        '_content_data_counter',
        common_loop_vars()
    );

    $context = $ctx->stash('content');
    if (!$context) {
        return;
    }

    if (!isset($out)) {
        $ctx->localize($localvars);

        # Detect content field id.
        if (isset($args['field_name'])) {
            $escaped_field_name = $ctx->mt->db()->escape($args['field_name']);
            $fetch_args = array('name' => $escaped_field_name);
            $content_fields = $ctx->mt->db()->fetch_content_fields($fetch_args);
            if (isset($content_fields)) {
                $content_field = $content_fields[0];
                $content_field_id = (int)$content_field->id;
            }
        } elseif (isset($args['field_id'])) {
            $content_field_id = (int)$args['field_id'];
        }

        # Load related source content data ids.
        $source_ids = array();
        if (isset($content_field_id) && is_int($content_field_id)) {
            $related_id = (int)$args['related_id'];
            $sql  = "SELECT cf_idx_content_data_id FROM mt_cf_idx";
            $sql .= " WHERE cf_idx_content_field_id = ${content_field_id}";
            $sql .= " AND cf_idx_value_integer = ${related_id}";
            $results = $ctx->mt->db()->SelectLimit($sql);
            if (!empty($results)) {
                $contents_field_idxs = $results->GetArray();
                foreach ($contents_field_idxs as $row) {
                    foreach ($row as $key => $value) {
                        if ($key === 'cf_idx_content_data_id') {
                            array_push($source_ids, $value);
                        }
                    }
                }
            }
        }

        if (count($source_ids)) {
            # Detect content id.
            $id = $source_ids[0];
            $sql  = "SELECT cd_content_type_id FROM mt_cd";
            $sql .= " WHERE cd_id = ${id}";
            $results = $ctx->mt->db()->SelectLimit($sql);
            if (!empty($results)) {
                $ids = $results->GetArray();
                if (isset($ids) && isset($ids[0]) && isset($ids[0]['cd_content_type_id'])) {
                    $content_type_id = $ids[0]['cd_content_type_id'];
                    # Load related source content data.
                    foreach ($source_ids as $id) {
                        $fetched_content_data = $ctx->mt->db()->fetch_contents(
                            array('id' => $id),
                            $content_type_id
                        );
                        if (is_array($content_data_array)) {
                            $content_data_array = array_merge($content_data_array, $fetched_content_data);
                        } else {
                            $content_data_array = $fetched_content_data;
                        }
                    }
                    $ctx->stash('_content_data', $content_data_array);
                    $counter = 0;
                }
            }
        }
    } else {
        $content_data_array = $ctx->stash('_content_data');
        $counter = $ctx->stash('_content_data_counter');
    }

    # Processing block tag.
    if ($counter < count($content_data_array)) {
        $content_data = $content_data_array[$counter];
        $content_type = $content_data->content_type();
        $ctx->stash('content_type', $content_type);
        $ctx->stash('content', $content_data);
        $ctx->stash('_content_data_counter', $counter + 1);

        $counter += 1;
        $ctx->__stash['vars']['__counter__'] = $counter;
        $ctx->__stash['vars']['__odd__'] = ($counter % 2) == 1;
        $ctx->__stash['vars']['__even__'] = ($counter % 2) == 0;
        $ctx->__stash['vars']['__first__'] = $counter == 1;
        $ctx->__stash['vars']['__last__'] = ($counter == count($content_data_array));
        $repeat = true;
    } else {
        $ctx->restore($localvars);
        $repeat = false;
    }

    return $out;
}
