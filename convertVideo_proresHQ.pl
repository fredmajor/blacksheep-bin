#!/usr/bin/env perl
use File::Basename;
use Cwd 'abs_path';
use 5.014;
use strict;
use warnings;
use utf8;

my $TARGET_WIDTH="1280";
my $TARGET_EXT=".mov";
my $SUFFIX="_PRORES_HQ" .  "_W_" . $TARGET_WIDTH.$TARGET_EXT;

my $argcount=@ARGV;
for (my $c=0; $c < $argcount; $c++){
	my $currFile = abs_path(shift);
	my($filename, $dirs, $suffix) = fileparse($currFile);
	(my $without_extension = $filename) =~ s/\.[^.]+$//;
	my $fOutBasename = $without_extension . $SUFFIX;
	my $fOut = $dirs . $fOutBasename;
	say "fOut:" . $fOut;
	my $cmd1 = qq{ffmpeg -y -i "$currFile"  -c:v prores -r 30000/1001 -profile:v 3 -q:v 4 -vf scale=$TARGET_WIDTH:-1  -c:a pcm_s16le -ar 48000 "$fOut"};
	#my $cmd1 = qq{ffmpeg -y -i "$currFile" -c:v prores -profile:v 3 -q:v 4 -vf scale=$TARGET_WIDTH:-1  -an "$fOut"};
	say "Command is: ". $cmd1;
	system $cmd1;
	if ( $? == 0 ) {
		say "convertion successful"
	}
	else {
		say "convertion failed"
	}
}
