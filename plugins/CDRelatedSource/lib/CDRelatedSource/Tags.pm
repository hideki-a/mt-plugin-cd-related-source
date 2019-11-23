package CDRelatedSource::Tags;
use strict;
use Encode;
use utf8;

sub _hdlr_cd_related_sources {
    my ($ctx, $args, $cond) = @_;

    my $blog_id = $ctx->stash('blog')->id;
    my $cd = $ctx->stash('content_type')
        || $ctx->error(MT->translate('You used an [_1] tag outside of the proper context.', 'ContentRelatedSources'));

    # Detect content field id.
    my $content_type_id = $ctx->stash('content_type')->id;
    my $field_id;
    if ($args->{field_name}) {
        my @fields = MT::ContentField->load(
            {   related_content_type_id => $content_type_id,
                name => encode_utf8($args->{field_name})
            }
        );
        for my $field (@fields) {
            $field_id = $field->id;
        }
    } else {
        $field_id = $args->{field_id};
    }

    # Load related source content data ids.
    my @source_ids;
    my @contents_field_idxs = MT::ContentFieldIndex->load(
        {   content_field_id => $field_id,
            value_integer => $args->{related_id}
        }
    );
    for my $contents_field_idx (@contents_field_idxs) {
        push(@source_ids, $contents_field_idx->content_data_id);
    }

    # Load related source content data.
    my $direction = ($args->{sort_order} || '') eq 'ascend' ? 'ASC' : 'DESC';
    my $args = ();
    $args->{sort} = [
        { column => 'authored_on', desc => $direction },
        { column => 'id',          desc => $direction },
    ];
    my @contents = MT::ContentData->load(
        {   blog_id => $blog_id,
            id => \@source_ids,
            status => MT::ContentStatus::RELEASE()
        },
        $args
    );

    # Processing block tag.
    my $out;
    my $i = 0;
    my $vars = $ctx->{__stash}{vars} ||= {};
    for my $content_data (@contents) {
        local $vars->{__first__}    = !$i;
        local $vars->{__last__}     = !defined $contents[ $i + 1 ];
        local $vars->{__odd__}      = ( $i % 2 ) == 0;
        local $vars->{__even__}     = ( $i % 2 ) == 1;
        local $vars->{__counter__}  = $i + 1;

        my $ct_id        = $content_data->content_type_id;
        my $content_type = MT::ContentType->load($ct_id);
        local $ctx->{__stash}{content_type} = $content_type;
        local $ctx->{__stash}{content} = $content_data;

        my $tokens = $ctx->stash('tokens');
        my $builder = $ctx->stash('builder');
        $out .= $builder->build($ctx, $tokens, $cond)
            || return $ctx->error($builder->errstr);
        $i++;
    }

    return $out;
}

1;
