#!/usr/bin/env perl
use File::Basename;
use Cwd 'abs_path';
use 5.014;
use strict;
use warnings;
use utf8;

my $BITRATE="600k";
my $TARGET_WIDTH="1280";
my $TARGET_EXT=".mp4";
my $SUFFIX="_PODCAST_BR_" . $BITRATE . "_W_" . $TARGET_WIDTH.$TARGET_EXT;

my $argcount=@ARGV;
for (my $c=0; $c < $argcount; $c++){
	my $currFile = abs_path(shift);
	my($filename, $dirs, $suffix) = fileparse($currFile);
	(my $without_extension = $filename) =~ s/\.[^.]+$//;
	my $fOutBasename = $without_extension . $SUFFIX;
	my $fOut = $dirs . $fOutBasename;
	say "fOut:" . $fOut;
	my $cmd1 = qq{ffmpeg -y -i "$currFile" -c:v libx264 -preset slow -profile:v high -b:v $BITRATE -vf scale=$TARGET_WIDTH:-1 -pass 1 -pix_fmt yuv420p  -c:a aac -b:a 128k -ac 1 -f mp4 /dev/null};
	my $cmd2 = qq{ffmpeg -y -i "$currFile" -c:v libx264 -preset slow -profile:v high -b:v $BITRATE -vf scale=$TARGET_WIDTH:-1 -pass 2 -pix_fmt yuv420p  -c:a aac -b:a 128k -ac 1  "$fOut"};
	say "Command is: ". $cmd1;
	say "Command is: ". $cmd2;
	system $cmd1;
	system $cmd2;
	if ( $? == 0 ) {
		say "convertion successful"
	}
	else {
		say "convertion failed"
	}
}
