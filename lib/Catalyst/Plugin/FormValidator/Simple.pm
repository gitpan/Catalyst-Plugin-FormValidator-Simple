package Catalyst::Plugin::FormValidator::Simple;
use strict;
use base qw/Catalyst::Plugin::FormValidator/;
# doesn't use parent module at all, but this is required for Catalyst::Plugin::FillInForm

use NEXT;
require FormValidator::Simple;

our $VERSION = '0.05';

sub setup {
    my $self = shift;
    $self->NEXT::setup(@_);
    my $setting = $self->config->{validator};
    my $plugins = $setting && exists $setting->{plugins}
        ? $setting->{plugins}
        : [];
    FormValidator::Simple->import(@$plugins);
}

sub prepare {
    my $c = shift;
    $c = $c->NEXT::prepare(@_);
    my $setting = $c->config->{validator};
    my $options = $setting && exists $setting->{options}
    	? $setting->{options}
    	: {};
    $c->{validator} = FormValidator::Simple->new(%$options);
    return $c;
}

sub form {
    my $c = shift;
    if ($_[0]) {
        my $form = $_[1] ? [@_] : $_[0];
        $c->{validator}->check($c->req->params, $form);
    }
    return $c->{validator}->results;
}

sub set_invalid_form {
    my $c = shift;
    $c->{validator}->set_invalid(@_);
    return $c->{validator}->results;
}

1;
__END__

=head1 NAME

Catalyst::Plugin::FormValidator::Simple - Validator for Catalyst with FormValidator::Simple

=head1 SYNOPSIS

    use Catalyst qw/FormValidator::Simple FillInForm/;

    # set option
    MyApp->config->{validator} = {
        plugins => ['CreditCard', 'Japanese'],
        options => { charset => 'euc'},
    }

in your controller

    sub defaulti : Private {

        my ($self, $c) = @_;

        $c->form(
            param1 => [qw/NOT_BLANK ASCII/, [qw/LENGTH 4 10/]],
            param2 => [qw/NOT_BLANK/, [qw/JLENGTH 4 10/]],
            mail1  => [qw/NOT_BLANK EMAIL_LOOSE/],
            mail2  => [qw/NOT_BLANK EMAIL_LOOSE/],
            { mail => [qw/mail1 mail2/] } => ['DUPLICATION'],
        );

        print $c->form->valid('param1');

        if ( some condition... ) {

            $c->form(
                other_param => [qw/NOT_INT/],
            );
        }

        if ( some condition... ) {

            # set your original invalid type.
            $c->set_invalid_form( param3 => 'MY_ERROR' );

        }

        if ( $c->form->has_missing || $c->form->has_invalid ) {
            
            if ( $c->form->missing('param1') ) {
                ...
            }

            if ( $c->form->invalid( param1 => 'ASCII' ) ) {
                ...
            }

            if ( $c->form->invalid( param3 => 'MY_ERROR' ) ) {
                ...
            }

        }
    }

=head1 DESCRIPTION

This plugin allows you to validate request parameters with FormValidator::Simple.
See L<FormValidator::Simple> for more information.

This behaves like as L<Catalyst::Plugin::FormValidator>.

=head1 SEE ALSO

L<FormValidator::Simple>

L<Catalyst>

=head1 AUTHOR

Lyo Kato E<lt>lyo.kato@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright(C) 2005 by Lyo Kato

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

