#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use lib 't/lib';

BEGIN {
  eval { require Test::WWW::Mechanize::Catalyst }
  or plan skipp_all => 'Test::WWW::Mechanize::Catalyst is required for this test';
  plan tests => 4;
}

use Test::WWW::Mechanize::Catalyst 'FVSTest::MessagesFile';
my $ua = Test::WWW::Mechanize::Catalyst->new;
$ua->get_ok("http://localhost/foo?param1=1&param2=string");
$ua->content_is("success");
$ua->get_ok("http://localhost/foo?param1=string&param2=1");
$ua->content_is("error:param1interror");

