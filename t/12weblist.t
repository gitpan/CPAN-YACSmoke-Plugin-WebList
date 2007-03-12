use Test::More tests => 6;

eval "use WWW::Mechanize";
plan skip_all => "WWW::Mechanize required for testing WebList plugin" if $@;
eval "use Template::Extract";
plan skip_all => "Template::Extract required for testing WebList plugin" if $@;


use CPAN::YACSmoke::Plugin::WebList;

{
    my $self  = {};

    my $plugin = CPAN::YACSmoke::Plugin::WebList->new($self);
    isa_ok($plugin,'CPAN::YACSmoke::Plugin::WebList');

    my @list = $plugin->download_list();
    ok(@list > 0);
}

{
    my $self  = {webpath => 'http://cpan.uwinnipeg.ca/recent'};

    my $plugin = CPAN::YACSmoke::Plugin::WebList->new($self);
    isa_ok($plugin,'CPAN::YACSmoke::Plugin::WebList');

    my @list = $plugin->download_list();
    ok(@list > 0);
}

{
    my $self  = {webpath => 'http://perl.grango.org/recent'};

    my $plugin = CPAN::YACSmoke::Plugin::WebList->new($self);
    isa_ok($plugin,'CPAN::YACSmoke::Plugin::WebList');

    my @list = $plugin->download_list();
    ok(@list == 0);
}
