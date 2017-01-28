#!/usr/bin/env perl
use File::Basename;
use Cwd 'abs_path';
use 5.014;
use strict;
use warnings;
use utf8;

my $TARGET_WIDTH="1280";
my $TARGET_EXT=".mov";
my $SUFFIX="_PRORES_PROX" .  "_W_" . $TARGET_WIDTH.$TARGET_EXT;
my $SUFFIX_HQ="_PRORES_HQ".$TARGET_EXT;

my $argcount=@ARGV;
for (my $c=0; $c < $argcount; $c++){
	my $currFile = abs_path(shift);
	my($filename, $dirs, $suffix) = fileparse($currFile);
	(my $without_extension = $filename) =~ s/\.[^.]+$//;
	my $fOutBasename = $without_extension . $SUFFIX;
	my $fOutBasenameHQ = $without_extension . $SUFFIX_HQ;
	my $fOut = $dirs . $fOutBasename;
	my $fOutHQ = $dirs . $fOutBasenameHQ;
	say "fOut:" . $fOut;
	say "fOut HQ:" . $fOutHQ;
	#my $cmd1 = qq{ffmpeg -y -i "$currFile" -c:v prores -profile:v 0 -q:v 25 -vf scale=$TARGET_WIDTH:-1  -c:a pcm_s16le -ar 48000 "$fOut"};
	my $cmd1 = qq{ffmpeg -y -i "$currFile" -c:v prores -profile:v 3 -q:v 4 -c:a pcm_s16le -q:a 0 -ar 48000 -timecode 00:00:00:00 -metadata title="$without_extension" "$fOutHQ" -c:v prores -profile:v 0 -q:v 25 -vf scale=$TARGET_WIDTH:-1 -c:a pcm_s16le -ar 48000 -timecode 00:00:00:00 -metadata title="$without_extension" "$fOut"};
	say "Command is: ". $cmd1;
	system $cmd1;
	if ( $? == 0 ) {
		say "convertion successful"
	}
	else {
		say "convertion failed"
	}
}
