use ExtUtils::MakeMaker;
WriteMakefile
(
    'NAME' => 'CPAN::YACSmoke::Plugin::WebList',
    'VERSION_FROM' => 'lib/CPAN/YACSmoke/Plugin/WebList.pm',
    'PREREQ_PM' => {
                'Test::More'            => 0,
                'CPAN::YACSmoke'        => '0.02_03',
				'WWW::Mechanize'        => 0,
				'Template::Extract'     => 0,
    },
    'INSTALLDIRS' => 'site',
    'PL_FILES' => {}
);
