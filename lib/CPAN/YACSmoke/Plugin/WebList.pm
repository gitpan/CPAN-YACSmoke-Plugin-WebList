package CPAN::YACSmoke::Plugin::WebList;

use 5.006001;
use strict;
use warnings;

our $VERSION = '0.03';

# -------------------------------------

=head1 NAME

CPAN::YACSmoke::Plugin::WebList - WebList plugin for CPAN::YACSmoke

=head1 SYNOPSIS

  use CPAN::YACSmoke;
  my $config = {
      list_from => 'WebList', 
      webpath => 'http://my.web.list/' # defaults to KobeSearch site
  };
  my $foo = CPAN::YACSmoke->new(config => $config);
  my @list = $foo->download_list();

=head1 DESCRIPTION

This module provides the backend ability to access the list of current
modules from the 'recent uploads to CPAN' web pages available. Note the
default is to access KobeSearch.

This module should be use together with CPAN::YACSmoke.

The WebList plugin accesses a formatted webpage to return
the current list of distributions. The current pages which provide
this list in correct format are cycled through, unless a specific
webpage is requested.

Currently used webpages:

  http://cpan.uwinnipeg.ca/recent

Note that the following webpages do not provide a 'download' link,
which can identify the exact distribution. Further checking may be
added in the future.

  http://search.cpan.org/recent
  http://use.perl.org/modulelist/

=cut

# -------------------------------------
# Library Modules

use CPAN::YACSmoke;
use WWW::Mechanize;
use Template::Extract;

# -------------------------------------
# Variables

my @webpaths = (
    'http://cpan.uwinnipeg.ca/recent'
#   'http://search.cpan.org/recent',
#   'http://use.perl.org/modulelist/',
);

my $mechanize = WWW::Mechanize->new();
my $extract   = Template::Extract->new();

my $template = <<HERE;
<div class=path>[% ... %][% FOREACH data %]
<li>[% ... %]
/authors/id/[% distro %]">Download</a>[% ... %]
[% END %]<HR />
HERE

# -------------------------------------
# The Subs

=head1 CONSTRUCTOR

=over 4

=item new()

Creates the plugin object.

=back

=cut
    
sub new {
    my $class = shift || __PACKAGE__;
    my $hash  = shift;

    my $self = {};
    foreach my $field (qw( webpath )) {
        $self->{$field} = $hash->{$field}   if(exists $hash->{$field});
    }

    bless $self, $class;
}

=head1 METHODS

=over 4

=item download_list()

Return the list of distributions recorded on the designated latest recent webpage.

=cut
    
sub download_list {
    my $self = shift;
    my @testlist;

    my @paths = $self->{webpath} ? ($self->{webpath}) : @webpaths;
    for my $path (@paths) {
        $mechanize->get( $path );
        last    if($mechanize->success());
    }
    return undef    unless($mechanize->success());

    my $data = $extract->extract($template, $mechanize->content());
    foreach my $post (@{$data->{data}}) {
        push @testlist, $post->{distro};
    }
    return reverse @testlist;
}

1;
__END__

=back

=head1 CAVEATS

This is a proto-type release. Use with caution and supervision.

The current version has a very primitive interface and limited
functionality.  Future versions may have a lot of options.

There is always a risk associated with automatically downloading and
testing code from CPAN, which could turn out to be malicious or
severely buggy.  Do not run this on a critical machine.

This module uses the backend of CPANPLUS to do most of the work, so is
subject to any bugs of CPANPLUS.

=head1 BUGS, PATCHES & FIXES

There are no known bugs at the time of this release. However, if you spot a
bug or are experiencing difficulties, that is not explained within the POD
documentation, please send an email to barbie@cpan.org or submit a bug to the
RT system (http://rt.cpan.org/). However, it would help greatly if you are 
able to pinpoint problems or even supply a patch. 

Fixes are dependant upon their severity and my availablity. Should a fix not
be forthcoming, please feel free to (politely) remind me.

=head1 SEE ALSO

The CPAN Testers Website at L<http://testers.cpan.org> has information
about the CPAN Testing Service.

For additional information, see the documentation for these modules:

  CPANPLUS
  Test::Reporter
  CPAN::YACSmoke

=head1 AUTHOR

  Barbie, <barbie@cpan.org>
  for Miss Barbell Productions <http://www.missbarbell.co.uk>.

=head1 COPYRIGHT AND LICENSE

  Copyright (C) 2005 Barbie for Miss Barbell Productions.
  All Rights Reserved.

  This module is free software; you can redistribute it and/or 
  modify it under the same terms as Perl itself.

=cut
