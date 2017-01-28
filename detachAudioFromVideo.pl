#!/usr/bin/env perl
use 5.014;
use strict;
use warnings;
use utf8;
use File::Find;
use Cwd;

my $location=getcwd;
my $count = 0;

sub find_txt {
	my $F = $File::Find::name;
	if ($F =~ /mp4$|mov|m4v|ogv$/i ) {
		my $fout = $F  =~ s/\..*$/.wav/r;
		say "attepmting to convert $F->$fout";
		#my $cmd = qq{ffmpeg -y -i $F -vn -acodec  pcm_s24le $fout > /dev/null 2>&1 };
		my $cmd = qq{ffmpeg -y -i "$F" -vn -acodec  pcm_s24le "$fout"  };
		say "command:" . $cmd;
		system $cmd;
		$count++;
		if ( $? == 0 ) {
			say "convertion successful"
		}
		else {
			say "convertion failed"
		}
	}
}

find({ wanted => \&find_txt, no_chdir=>1}, $location);
say "Files processed:" . $count;

