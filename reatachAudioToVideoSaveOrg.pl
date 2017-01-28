#!/usr/bin/env perl
use 5.014;
use strict;
use warnings;
use utf8;

#input in pairs: video1 audio1 video2 audio2 etc...
#my $ext = ".mkv";
my $ext = ".mp4";

my $argcount=@ARGV;
die "expectig even number of argumets" if $argcount % 2 !=0 or $argcount == 0;
my $noOfPairs = $argcount / 2;
for (my $c=0; $c < $noOfPairs; $c++){
	my $vFile = shift;
	my $aFile = shift;
	#my ($ext) = $vFile =~ /(\.[^.]+)$/;
	my $fOut = $vFile =~ s/\..*$/_audioBoost$ext/r;
	my $cmd = qq{ffmpeg -y -i $vFile -i $aFile -map 0:0 -map 1:0 -c:v copy -c:a aac -b:a 384k -shortest  $fOut};
	#my $cmd = qq{ffmpeg -y -i $vFile -i $aFile -map 0:0 -map 1:0 -c:v copy -c:a copy -shortest  $fOut};
#-map 1:0 -vcodec prores -profile:v 3
	say "Command is: ". $cmd;
	system $cmd;

	if ( $? == 0 ) {
		say "convertion successful"
	}
	else {
		say "convertion failed"
	}
}
