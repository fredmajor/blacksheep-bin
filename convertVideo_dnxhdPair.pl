#!/usr/bin/env perl
use File::Basename;
use Cwd 'abs_path';
use 5.014;
use strict;
use warnings;
use utf8;

my $TARGET_WIDTH_HQ="1280";
my $TARGET_WIDTH_PROXY="1280";
my $TARGET_EXT=".mov";
my $SUFFIX_PROXY="_DNXHD_PROX" .  "_W_" . $TARGET_WIDTH_HQ.$TARGET_EXT;
my $SUFFIX_HQ="_DNXHD_HQ_W_" . $TARGET_WIDTH_PROXY.$TARGET_EXT;

my $argcount=@ARGV;
for (my $c=0; $c < $argcount; $c++){
	my $currFile = abs_path(shift);
	my($filename, $dirs, $suffix) = fileparse($currFile);
	(my $without_extension = $filename) =~ s/\.[^.]+$//;
	my $fOutBasename = $without_extension . $SUFFIX_PROXY;
	my $fOutBasenameHQ = $without_extension . $SUFFIX_HQ;
	my $fOut = $dirs . $fOutBasename;
	my $fOutHQ = $dirs . $fOutBasenameHQ;
	say "fOut:" . $fOut;
	say "fOut HQ:" . $fOutHQ;
	my $cmd1 = qq{ffmpeg -y -i "$currFile" -c:v dnxhd -b:v 110M -vf scale=$TARGET_WIDTH_HQ:-1 -r 30000/1001 -pix_fmt yuv422p -c:a  pcm_f32le -q:a 0 -ar 48000 -timecode 00:00:00:00 -metadata title="$without_extension"  "$fOutHQ" -c:v dnxhd -b:v 75M -vf scale=$TARGET_WIDTH_PROXY:-1 -r 30000/1001 -pix_fmt yuv422p -c:a pcm_s16le -ar 48000 -timecode 00:00:00:00 -metadata title="$without_extension" "$fOut"};
	say "Command is: ". $cmd1;
	system $cmd1;
	if ( $? == 0 ) {
		say "convertion successful"
	}
	else {
		say "convertion failed"
	}
}
