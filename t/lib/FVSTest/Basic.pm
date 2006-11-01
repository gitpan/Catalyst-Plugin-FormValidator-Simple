package FVSTest::Basic;

use strict;
use warnings;

use Catalyst qw/FormValidator::Simple/;

sub foo : Global {
    my ($self, $c) = @_;
    $c->form(
        param1 => [qw/NOT_BLANK INT/], 
        param2 => [qw/NOT_BLANK/],
    );
    $c->res->content_type('text/plain');
    if ($c->form->has_error) {
        my $result = $c->form;
        my @keys = $result->error;
        $c->res->body('error:'.join("|", sort @keys));
    } else {
        $c->res->body('success');
    }
}

__PACKAGE__->setup;
