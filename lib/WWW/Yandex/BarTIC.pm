package WWW::Yandex::BarTIC;

use 5.006;
use strict;
use warnings;
our $VERSION = '0.01';

use LWP::UserAgent;
use URI::Escape;
use Carp 'carp';

use constant BAR_HOST => 'bar-navig.yandex.ru';
use constant UA_HEADER =>
  'Mozilla/5.0 (Ubuntu; X11; Linux i686; rv:9.0.1) Gecko/20100101 Firefox/9.0.1 YB/6.5.0-en';

sub new {
  my $class = shift;
  my %par   = @_;
  my $self;

  $self->{ua} = LWP::UserAgent->new(agent => $par{agent} || UA_HEADER)
    or return;
  $self->{ua}->env_proxy if $par{env_proxy};
  $self->{ua}->proxy('http', $par{proxy}) if $par{proxy};
  $self->{ua}->timeout($par{timeout}) if $par{timeout};
  $self->{host} = $par{host} || BAR_HOST;

  bless($self, $class);
}

sub get {
  my ($self, $url) = @_;
  return unless defined $url;
  unless ($url =~ m[^https?://]i) {
    carp 'use "http://some.domain" format for url';
    return;
  }

  my $query =
    'http://' . $self->{host} . '/u?url=' . uri_escape($url) . '&show=1';

  my $resp = $self->{ua}->get($query);
  if ( $resp->is_success
    && $resp->content =~ m#<tcy rang="\d+" value="(\d+)"/>#)
  {
    if (wantarray) {
      return ($1, $resp);
    }
    else {
      return $1;
    }
  }
  else {
    if (wantarray) {
      return (undef, $resp);
    }
    else {
      return;
    }
  }
}


=head1 NAME

WWW::Yandex::BarTIC - Query Yandex citation index (Яндекс ТИЦ in russian)

=head1 VERSION

Version 0.01

=cut


=head1 SYNOPSIS

    use WWW::Yandex::BarTIC;

    my $yb = WWW::Yandex::BarTIC->new();
    my ($tic, $resp) = $yb->get('http://cpan.org');


=head1 DESCRIPTION

As you can see, I have copy-pasted some code and doc from C<WWW::Google::PageRank>. Another modules (WWW::Yandex::) dit not work for me, so this module is the slapdash solution.

The C<WWW::Yandex::BarTIC> is a class implementing a interface for
querying yandex citation index.

To use it, you should create C<WWW::Yandex::BarTIC> object and use its
method get(), to query page rank of URL.

It uses C<LWP::UserAgent> for making request to Google.

=head1 CONSTRUCTOR METHOD

=over 4

=item  $yb = WWW::Yandex::BarTIC->new(%options);

This method constructs a new C<WWW::Yandex::BarTIC> object and returns it.
Key/value pair arguments may be provided to set up the initial state.
The following options correspond to attribute methods described below:

   KEY                     DEFAULT
   -----------             --------------------
   agent                   "Mozilla/5.0 (Ubuntu; X11; Linux i686; rv:9.0.1) Gecko/20100101 Firefox/9.0.1 YB/6.5.0-en"
   proxy                   undef
   timeout                 undef
   env_proxy               undef
   host                    "bar-navig.yandex.ru"

C<agent> specifies the header 'User-Agent' when querying Yandex.  If
the C<proxy> option is passed in, requests will be made through
specified poxy. C<proxy> is the host which serve requests from Yandex Bar.

If the C<env_proxy> option is passed in with a TRUE value, then proxy
settings are read from environment variables (see
C<LWP::UserAgent::env_proxy>)

=back

=head1 QUERY METHOD

=over 4

=item  $tic = $yb->get('http://cpan.org');

Queries Yandex for a specified URL and returns TIC. If
query successfull, integer value > 0 returned. If query fails
for some reason (yandex unreachable, url does not begin from
'http://', undefined url passed) it return C<undef>.

In list context this function returns list from two elements where
first is the result as in scalar context and the second is the
C<HTTP::Response> object (returned by C<LWP::UserAgent::get>). This
can be usefull for debugging purposes and for querying failure
details.

=back


=head1 AUTHOR

Alex, C<< <alexbyk at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-yandex-bartic at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Yandex-BarTIC>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Yandex::BarTIC


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Yandex-BarTIC>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-Yandex-BarTIC>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-Yandex-BarTIC>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-Yandex-BarTIC/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alex.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1;    # End of WWW::Yandex::BarTIC
