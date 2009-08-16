use Test::More tests => 6;

eval "use WWW::Mechanize";
plan skip_all => "WWW::Mechanize required for testing WebList plugin" if $@;
eval "use Template::Extract";
plan skip_all => "Template::Extract required for testing WebList plugin" if $@;


use CPAN::YACSmoke::Plugin::WebList;

SKIP: {
	skip "Can't see a network connection", 6   if(pingtest());

    {
        my $self  = {};

        my $plugin = CPAN::YACSmoke::Plugin::WebList->new($self);
        isa_ok($plugin,'CPAN::YACSmoke::Plugin::WebList');

        my @list = $plugin->download_list();
        ok(@list > 0, 'returns list for default file');
    }

    {
        my $self  = {webpath => 'http://cpan.uwinnipeg.ca/recent'};

        my $plugin = CPAN::YACSmoke::Plugin::WebList->new($self);
        isa_ok($plugin,'CPAN::YACSmoke::Plugin::WebList');

        my @list = $plugin->download_list();
        ok(@list > 0, 'returns list for named file');
    }

    {
        my $self  = {webpath => 'http://www.example.org/recent'};   # this doesn't exist

        my $plugin = CPAN::YACSmoke::Plugin::WebList->new($self);
        isa_ok($plugin,'CPAN::YACSmoke::Plugin::WebList');

        my @list = $plugin->download_list();
        ok(@list == 0, 'returns nothing for named non-existant file');
    }
}

###########################################################

# crude, but it'll hopefully do ;)
sub pingtest {
  system("ping -q -c 1 www.google.com >/dev/null 2>&1");
  my $retcode = $? >> 8;
  # ping returns 1 if unable to connect
  return $retcode;
}
