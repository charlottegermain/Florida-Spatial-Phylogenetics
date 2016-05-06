#!usr/bin/env perl                                                                                                                           

use strict;
use warnings;

open OUT, ">Species.Zero.points.txt";
my $flag=0;
my $oneflag=0;
my $countempty=0;
system "ls -l *.threshold.asc >filenames";
open FH1, "<filenames";
while (<FH1>) {
    if (/(\S+).threshold.asc/) {
	my $file=$1;
	open FH3, "<$file.threshold.asc";
	$flag=0;
	$oneflag=0;
	while (<FH3>) {
	    if ($flag == 1) {  
		my $line=$_;  
		if ($line =~ m/\S/) {  
		    chomp $line; 
		    my @tablearray = split(/ /, $line);
		    for my $num (@tablearray) {
			if ($num == 1) {
			    $oneflag=1;
			}
		    }
		}
	    }
	    if ($flag ==0) { if (/NODATA_value/) {  $flag =1; } }
	}
	if ($oneflag == 0) {
	    $file =~ s/_presentBio_avg//g;
	    print OUT "$file\n";
	    $countempty++;
	}
    }
}

print "$countempty\n";



	
