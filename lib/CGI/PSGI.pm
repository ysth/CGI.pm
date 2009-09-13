package CGI::PSGI;
use strict;
use CGI;

# Doesn't do anything useful: see POD
$CGI::PSGI = 1;

1;

__END__

=head1 NAME

CGI::PSGI - Adds direct support for PSGI to read params

=head1 SYNOPSIS

  use CGI::PSGI;

  my $app = sub {
      my $env = shift;
      local *ENV = $env;
      my $query = CGI->new;

      # ...

      my($status, $headers) = $query->header('text/html'); # $headers is an array ref

      return [ $status, $headers, [ $body ] ];
  };

=head1 DESCRIPTION

CGI::PSGI is a pragma module to let CGI read query and input
parameters from PSGI C<$env> hash ref instead of environment variables
and STDIN. This module actually doesn't do anything but is there for
convenience to set the flag C<$CGI::PSGI> variable to 1, and to check
if your CGI.pm supports PSGI input i.e. if the version of CGI doesn't
support CGI::PSGI, C<use CGI::PSGI> would fail.

Note that if your existent application prints headers and output to
STDOUT, your script is not ready to be handled as a PSGI application
yet. Take a look at L<CGI::Emulate::PSGI> to convert such a script
into a PSGI application.

The built-in support for PSGI in CGI module helps you to convert an
existent Web application framework that calls C<< CGI->new >> inside
to get parameters and such. Note that you should localize, or set and
reset the global C<%ENV> hash with the PSGI input C<$env> hash
reference during the lifetime of your application.

For instance with L<CGI::Application>,

  use MyApp; # is a CGI::Application app
  use CGI::Application::PSGI;

  my $app = sub {
      my $env = shift;
      local *ENV = $env;
      $ENV{CGI_APP_RETURN_ONLY} = 1;

      my $webapp = MyApp->new;
      CGI::Application::PSGI->run($webapp);
  };

=head1 AUTHOR

Tatsuhiko Miyagawa E<lt>miyagawa@bulknews.netE<gt>

=head1 SEE ALSO

L<CGI> L<PSGI> L<Plack> L<CGI::Emulate::PSGI>

=cut
