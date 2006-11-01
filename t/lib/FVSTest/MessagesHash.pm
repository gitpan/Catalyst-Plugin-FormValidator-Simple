package FVSTest::MessagesHash;

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
        my $messages = $result->messages('test');
        $c->res->body('error:'.join("|", sort @$messages));
    } else {
        $c->res->body('success');
    }
}

__PACKAGE__->config({
    validator => {
        messages => {
            test => {
                param1 => {
                    NOT_BLANK => 'param1notblankerror',
                    INT       => 'param1interror',
                },
                param2 => {
                    NOT_BLANK => 'param2notblankerror',
                }
            }
        },
    }
});
__PACKAGE__->setup;
