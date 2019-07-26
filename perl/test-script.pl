#! /usr/bin/env perl

use feature qw(say);
use strict;
use warnings;

use Mojolicious::Lite;
 
get '/' => sub {
  my $c = shift;
  $c->render(template => 'index');
};
get '/foo' => sub {
  my $c    = shift;
  my $user = $c->param('user');
  $c->render(text => "Hello user.");
};
app->start;

__DATA__
 
@@ index.html.ep
<!DOCTYPE html>
<html>
  <head><title>Detected</title></head>
  <body>HTML was detected.</body>
</html>
 
