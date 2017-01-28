#!/usr/bin/env perl
#takes files from the input line, and creates a dir structure in a form of:
#root --- source
#      |- hq
#      |- mq
#      |- lq

use 5.010;
use strict;
use warnings;
use utf8;
use File::Basename;
use File::Copy;
use Getopt::Long;
use Data::Dumper;
use Cwd 'abs_path';

my $TARGET_WIDTH="1280";
my $CRF="32";
my $ext=".mov";
my $HQ_DIR_NAME="hq";
my $MQ_DIR_NAME="mq";
my $LQ_DIR_NAME="lq";
my $SRC_DIR_NAME="source";

my ($nosource, $nohq, $nomq, $nolq) = 0;
GetOptions (
"nosource"  	=> \$nosource,
"nohq"				=> \$nohq,
"nomq"				=> \$nomq,
"nolq"				=> \$nolq)
or die("Error in command line arguments\n");

foreach(@ARGV){
	my $currFile = abs_path($_);
	say "curr file=$currFile";
	my($filename, $dirs, $suffix) = fileparse($currFile);
	(my $without_extension = $filename) =~ s/\.[^.]+$//;
	my $resFilename=$without_extension.$ext;
	#my $resFilename=$filename;

	mkdir $dirs.$SRC_DIR_NAME unless -d $dirs.$SRC_DIR_NAME;
	unless ($nohq) {
		mkdir $dirs.$HQ_DIR_NAME unless -d $dirs.$HQ_DIR_NAME;
	}
	unless ($nomq) {
		mkdir $dirs.$MQ_DIR_NAME unless -d $dirs.$MQ_DIR_NAME;
	}
	unless ($nolq) {
		mkdir $dirs.$LQ_DIR_NAME unless -d $dirs.$LQ_DIR_NAME;
	}

	my $cmd1 = qq{ffmpeg -y -i "$currFile" };
	unless ($nohq) {
		$cmd1 = $cmd1.qq{ -c:v prores -profile:v 3 -q:v 4 -c:a pcm_f32le -q:a 0 -ar 48000 -timecode 00:00:00:00 -metadata title="$without_extension" "$dirs$HQ_DIR_NAME/$resFilename" };
	}
	unless ($nomq) {
		$cmd1 = $cmd1.qq{ -c:v prores -profile:v 0 -q:v 25 -vf scale=$TARGET_WIDTH:-1 -c:a pcm_s16le -ar 48000 -timecode 00:00:00:00 -metadata title="$without_extension" "$dirs$MQ_DIR_NAME/$resFilename" };
	}
	unless ($nolq) {
		$cmd1 = $cmd1.qq{ -c:v libx264 -preset medium -profile:v high -crf "$CRF" -pix_fmt yuv420p -vf scale=$TARGET_WIDTH:-1  -c:a aac -b:a 64k -ac 2 "$dirs$LQ_DIR_NAME/$resFilename" };
	}
	say "cmd is $cmd1";
	system $cmd1;
	if ( $? == 0 ) {
		say "convertion successful"
	}
	else {
		say "convertion failed"
	}
	move("$currFile", "$dirs$SRC_DIR_NAME/$filename");
}
