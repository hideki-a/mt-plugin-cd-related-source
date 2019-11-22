package CDRelatedSource::Tags;
use strict;
use Encode;
use utf8;
use MT::ContentField;

sub _hdlr_cd_related_source {
    my ($ctx, $args) = @_;
    my @source_ids;
    my $field_id;

    my $cd = $ctx->stash('content_type')
        || $ctx->error(MT->translate('You used an [_1] tag outside of the proper context.', 'CDRelatedSource'));

    if ($args->{field_name}) {
        # <mt:ContentID setvar="cd_id" /><mt:CDRelatedSource field_name="関連商品" content_type_id="6" related_id="$cd_id" />
        my @fields = MT::ContentField->load({
            content_type_id => $args->{content_type_id},
            name => encode_utf8($args->{field_name})
        });

        for my $field (@fields) {
            $field_id = $field->id;
        }
    } else {
        # <mt:ContentID setvar="cd_id" /><mt:CDRelatedSource field_id="30" related_id="$cd_id" />
        $field_id = $args->{field_id};
    }

    my $iter = MT::ContentFieldIndex->load_iter({
        content_field_id => $field_id,
        value_integer => $args->{related_id}
    });

    while (my $obj = $iter->()) {
        push(@source_ids, $obj->content_data_id);
    }

    return join(',', @source_ids);
}

1;
