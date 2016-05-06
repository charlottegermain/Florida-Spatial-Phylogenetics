#!usr/bin/env perl                                                                                                                           

use strict;
use warnings;

open OUT, ">Species.AllrepsZero.txt";
open OUT2, ">Species.ReplicateToUse.txt";
my $flag=0;
my $oneflag=0;
my $countempty=0;
my $numtax=0;
my $numzeroonlytax=0;
my $numfound=0;
open FH1, "<Species.Zero.points.txt";
my %taxhash=();
while (<FH1>) {
    my $newcount=0;
    my $onecount=0;
    if (/(\S+)/) {
	my $tax=$1;
	$numtax++;
	print "$tax\t$numtax\n";
	$taxhash{$tax}=0;
	system "ls -l Present.$tax\.OUT/$tax\_*_thresholded.asc >files";
	open FH2, "<files";
	while (<FH2>) {
	    if (/(\S+)_present0212_thresholded.asc/) {
		my $file=$1;
		$flag=0;
		$newcount=0;
		open FH3, "<$file\_present0212_thresholded.asc";
		while (<FH3>) {
		    if ($flag == 1) {  
			my $line=$_;  
			chomp $line; 
			my @tablearray = split(/ /, $line);
			for my $num (@tablearray) {
			    if ($num == 1) {
				$newcount++;
			    }
			}
		    } 
		    if ($flag ==0) { 
			if (/NODATA_value/) {  
			    $flag =1; 
			} 
		    }
		}
		print "oldcout $onecount  newcount $newcount\n";
		if ($newcount > $onecount) {
		    $onecount = $newcount;
		    $taxhash{$tax}=$file;
		}
	    }
	}
	if ($onecount == 0 ) { $numzeroonlytax++; print OUT "$tax\n"; print "$tax does not have any 1s\n"; }
	else { 
		`cp $taxhash{$tax}\_present0212_thresholded.asc PATHTOFOLDER/$tax\_presentBIO_bestrep.threshold.asc`;
	    #open FH4, "<$taxhash{$tax}\_present0212_thresholded.asc";
	    #open OUTx, ">$tax\_presentBIO_bestrep.threshold.asc";
	    print OUT2 "$tax\t$taxhash{$tax}\t$onecount\n"; 
	    #while (<FH4>) { print OUTx; } 
	    print "for taxon $tax\tthe replicate to keep is $taxhash{$tax}\n";  
	    $numfound++; 
	}
    }
}

print "Total tax $numtax  total with only zeros $numzeroonlytax  total with at least one non empty file $numfound\n";


#    if ($oneflag == 0) {
#		$file =~ s/_presentBio_avg//g;
#		print OUT "$file\n";
#		$countempty++;
#	    }
#	}
 #   }
  #  
  #  print "$countempty\n";

	
####  species_presentBIO_avg.threshold.asc   and print out the species names.
#### for the ones without any 1s give charlotte a list of those names. 
#### find the replicate with the most 1s 
######  cp the file into binary maps and rename it 
