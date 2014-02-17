use strict;
use warnings;
use File::Glob;
use File::Copy;
my $parent = 'C:/Program Files/Apache Software Foundation/Tomcat 6.0/webapps/ROOT/mebooks/clients/library.nelson/images';
my $tei = 'C:/Program Files/Apache Software Foundation/Tomcat 6.0/webapps/ROOT/mebooks/clients/library.nelson/tei';

my @titles = (
'appendix_cover.html',
'appendix.html',
'1_Spider_on_web-Eric_Lloyd.html',
'2_Spider-Ken_Garton.html',
'3_Fish_in_weeds-Michael_Heremia.html',
'4_Fantails_and_mosquitoes-Michael_Heremia.html',
'5_Hangi_at_Taratara-David_Windust.html',
'6_Three_ferns-Allan_Foster.html',
'7_Lizard_from_Tokerau-Sonny_Takinui.html',
'8_Looking_through_the_grass-Clifton_Foster.html',
'9_Crabs-Jenny_Lloyd.html',
'10_Fern_design-Raymond_Adamson.html',
'11_House-Anon.html',
'12_Pheasant-David_Heremia.html',
'13_Pukeko_hunting-David_Windust.html',
'14_Two_bad_boys-Kevin_Windust.html',
'15_Goldfinches_feeding-Kathleen_Heremia.html',
'16_Reeds-anon.html',
'17_Night_faces-Clifton_Foster_or_Kevin_Windust.html',
'18_Bitch_and_hare-Dennis_Windust.html',
'19_Native_dancer-David_Heremia.html',
'20_Three_people-Necia_Lloyd.html',
'21_Dream_of_Spirit-Ken_Garton.html',
'22_Sunflower_and_bees-Mary_Matiu.html',
'23_Preacher-Dennis_Windust.html',
'24_Morepork-David_Heremia.html',
'25_Tree_design-Eric_Lloyd.html',
'26_Two_trees_and_man-Colin_Foster.html',
'27_Tree_and_birds-Bevin_Windust.html',
'28_Barbecue_(Maoris_cooking)-Ken_Garton.html',
'29_Wasp_nest-Irene_Matiu.html',
'30_Down_in_depths_(fish_under_sea)-Allan_Foster.html',
'31_Godwits_on_beach-Clifton_Foster.html',
'32_Fish_under_sea-Bruce_Foster.html',
'32_Maori_man-Dennis_Windust.html',
'33_Farm_Oruaiti-Ken_Garton.html',
'34_Bearded_man-Colin_Foster.html',
'35_Dancers-Glennis_Foster.html',
'36_Bird_on_nest-Jenny_Lloyd.html',
'37_Two_banjo_boys-Jenny_Lloyd.html',
'38_Three_faces-Kevin_Windust.html',
'39_Thrush_flying-Marilyn_Dickson.html',
'40_Pheasant-David_Heremia.html',
);

&create_toc();

sub create_toc() {
	open TOC, ">", 'toc.txt' or die $!;
	foreach my $title (@titles) {
		print "Creating toc entry for $title\n";

		my $hereDoc = <<FINISH;
<navPoint id="navPoint-23" playOrder="23">
	<navLabel>
		<text>Back Cover</text>
	</navLabel>
	<content src="back.html"/>
</navPoint>
FINISH

		(my $niceTitle = $title) =~ s{_}{ }g;
		$niceTitle =~ s{\.html}{};
		$niceTitle =~ s{-}{: };
		$hereDoc =~ s{<text>Back Cover</text>}{<text>$niceTitle</text>};
		$hereDoc =~ s{<content src="back.html"/>}{<content src="$title"/>};

		print TOC $hereDoc;
		}
	close TOC;
}

sub create_files() {
	foreach my $title (@titles) {
		print "Creating file for $title\n";
		open HTML, ">", $title or die $!;

		my $hereDoc = <<END;
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns:svg="http://www.w3.org/2000/svg" xmlns="http://www.w3.org/1999/xhtml" xmlns:xlink="http://www.w3.org/1999/xlink">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Front Cover</title>
<link rel="stylesheet" href="coverstyle.css" type="text/css" />
</head>
<body>
<div id="caja">
<img src="images/cover.jpg" alt="front cover" />
</div>
</body>
</html>
END

		(my $niceTitle = $title) =~ s{_}{ }g;
		$niceTitle =~ s{\.html}{};
		$niceTitle =~ s{-}{: };
		$hereDoc =~ s{<title>Front Cover</title>}{<title>$niceTitle</title>};
		(my $jpgTitle = $title) =~ s{\.html}{.jpg};
		$hereDoc =~ s{<img src="images/cover.jpg" alt="front cover" />}{<img src="images/$jpgTitle" alt="$niceTitle" />};

		print HTML $hereDoc;

		close HTML;
	}
}