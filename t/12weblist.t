use Test::More tests => 2;

eval "use WWW::Mechanize";
plan skip_all => "WWW::Mechanize required for testing WebList plugin" if $@;
eval "use Template::Extract";
plan skip_all => "Template::Extract required for testing WebList plugin" if $@;


use CPAN::YACSmoke::Plugin::WebList;

my $self  = {};

my $plugin = CPAN::YACSmoke::Plugin::WebList->new($self);
isa_ok($plugin,'CPAN::YACSmoke::Plugin::WebList');

my @list = $plugin->download_list();
ok(@list > 0);

