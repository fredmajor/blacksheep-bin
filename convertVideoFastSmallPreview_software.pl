#!/usr/bin/env perl
use File::Basename;
use Cwd 'abs_path';
use 5.014;
use strict;
use warnings;
use utf8;

my $CRF="32";
my $TARGET_WIDTH="1280";
my $TARGET_EXT=".mp4";
my $SUFFIX="_PREVIEW_SFTW_CRF_" . $CRF . "_W_" . $TARGET_WIDTH.$TARGET_EXT;

my $argcount=@ARGV;
for (my $c=0; $c < $argcount; $c++){
	my $currFile = abs_path(shift);
	my($filename, $dirs, $suffix) = fileparse($currFile);
	(my $without_extension = $filename) =~ s/\.[^.]+$//;
	my $fOutBasename = $without_extension . $SUFFIX;
	my $fOut = $dirs . $fOutBasename;
	say "fOut:" . $fOut;
	my $cmd1 = qq{ffmpeg -y -i "$currFile" -c:v libx264 -preset ultrafast -crf "$CRF" -pix_fmt yuv420p -vf scale=$TARGET_WIDTH:-1  -c:a aac -b:a 64k -ac 1 "$fOut"};
	say "Command is: ". $cmd1;
	system $cmd1;
	if ( $? == 0 ) {
		say "convertion successful"
	}
	else {
		say "convertion failed"
	}
}
