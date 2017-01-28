#!/usr/bin/env perl
use File::Basename;
use Cwd 'abs_path';
use 5.014;
use strict;
use warnings;
use utf8;

my $FS=44100;
my $BITRATE="64k";
my $CHANNELS="1";
my $TARGET_EXT=".mp3";
my $SUFFIX="_PODCAST_FS_"."$FS"."_BR_".$BITRATE."_CH_".$CHANNELS.$TARGET_EXT;

my $argcount=@ARGV;
for (my $c=0; $c < $argcount; $c++){
	my $currFile = abs_path(shift);
	my($filename, $dirs, $suffix) = fileparse($currFile);
	(my $without_extension = $filename) =~ s/\.[^.]+$//;
	my $fOutBasename = $without_extension . $SUFFIX;
	my $fOut = $dirs . $fOutBasename;
	say "fOut:" . $fOut;
	my $cmd1 = qq{ffmpeg -y -i "$currFile" -vn -c:a libmp3lame -b:a $BITRATE -ar $FS -ac $CHANNELS  "$fOut"};
	say "Command is: ". $cmd1;
	system $cmd1;
	if ( $? == 0 ) {
		say "convertion successful"
	}
	else {
		say "convertion failed"
	}
}
