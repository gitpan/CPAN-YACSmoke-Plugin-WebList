use ExtUtils::MakeMaker;
WriteMakefile
(
    'NAME' => 'CPAN::YACSmoke::Plugin::WebList',
    'VERSION_FROM' => 'lib/CPAN/YACSmoke/Plugin/WebList.pm',
    'PREREQ_PM' => {
                'Test::More'            => 0,
				'WWW::Mechanize'        => 0,
				'Template::Extract'     => 0,
				'Template'              => '2.00',
    },
	NO_META			=> 1,

    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT	=> 'WebList plugin for CPAN::YACSmoke',
       AUTHOR	=> 'Barbie <barbie@cpan.org>') : ()),
);
