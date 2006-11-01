package FVSTest::MessagesFile;

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

use FindBin;
__PACKAGE__->config(
    home => "$FindBin::Bin",
    validator => {
        messages => 'conf/messages.yml',
    }
);
__PACKAGE__->setup;
