#!usr/bin/env perl

use strict;
use warnings;

# 1st Step: Do all species with an equal training sensitivity and specificity maps. 

open OUT, ">Maxent.Run.Info.All.txt";
print OUT "Species\tAverage\tNumber of Replicates\n";
system "ls -l  >foldernames";
open FX, "<foldernames";
while (<FX>) {
    my @array=();
    my $linenum=0;
    my $average=0;
    my $numvalues=0;
    my $sum=0;
    my $title=();
    if (/Present.(\S+).OUT/) {
	my $species =$1;
### GET SPECIES NAME. OPEN THE FILE IN THE FOLDER.. NEED THE FULL PATH. 

	open FX1, "</scratch/lfs/cgermain/MAXENT/Mask_Yearly/Present100Out/presentMask100Yearly.$species.OUT/maxentResults.csv";
	while (<FX1>) {
#	    print;
	    $linenum++;
	    if ($linenum == 1) {
		my $line=$_;
		@array = split(/,/, $line);
#This is the equal training sensitivity and specificity
		$title = $array[64];
	    }
	    else {
		my $line=$_;
		$numvalues++;
		@array = split(/,/, $line);
		my $threshold = $array[64];
		$sum = $sum + $threshold;
	    }
	}
	$average=$sum/$numvalues;
	print OUT  "$species\t$average\t$numvalues\t$title\n";

        open FH1, "</scratch/lfs/cgermain/MAXENT/Mask_Yearly/Present100Out/presentMask100Yearly.$species.OUT/$species\_$species_avg.asc";
        open OUT1, ">/scratch/lfs/cgermain/MAXENT/Mask_Yearly/Present100Out/presentMask100Yearly.$species.OUT/$species\_present100Mask1.5_avg.threshold.asc";
        open OUT2, ">/scratch/lfs/cgermain/MAXENT/Mask_Yearly/Present100Out/BINARY_MAPS/$species\_present100Mask1.5.threshold.asc";


	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
	}
    }
}
close FH1;
close FX;
close FX1;

#step 2: read the file of species with only 0 from the PresentOut and redo those maps with Minimum Training threshold only

open OUT, ">Maxent.Run.Info.All.txt";
print OUT "Species\tAverage\tNumber of Replicates\n";
#system "ls -l  >foldernames";
open FZ, "<Species.Zero.points.txt";
while (<FZ>) {
    my @array=();
    my $linenum=0;
    my $average=0;
    my $numvalues=0;
    my $sum=0;
    my $title=();
    if (/^(\S+)/) {
	my $species =$1;
	print "$species\n";
### GET SPECIES NAME. OPEN THE FILE IN THE FOLDER.. NEED THE FULL PATH. 
	open FZ1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/maxentResults.csv";
	while (<FZ1>) {
#	    print;
	    $linenum++;
	    if ($linenum == 1) {
		my $line=$_;
		@array = split(/,/, $line);

# This is the minimum training presence threshold                             
                $title = $array[52];
	    }
	    else {
		my $line=$_;
		$numvalues++;
		@array = split(/,/, $line);
		my $threshold = $array[52];
		$sum = $sum + $threshold;
	    }
	}
	$average=$sum/$numvalues;
	print OUT  "$species\t$average\t$numvalues\t$title\n";

	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
	}
    }
}
close FZ;
close FZ1;
close FH1;

#Step 3: Take the 23 costumized species and apply the same threshold than for the present. 
 

my $species= 'Asclepias_variegata';
my $average= '0.01';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Asclepias_viridiflora';
my $average= '0.018';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Catesbaea_parviflora';
my $average= '0.68';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Crotalaria_avonensis';
my $average= '0.12';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Euphorbia_rosescens';
my $average= '0.008';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Gyminda_latifolia';
my $average= '0.67';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Hibiscus_laevis';
my $average= '0.003';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Lespedeza_procumbens';
my $average= '0.01';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Microstegium_vimineum';
my $average= '0.04';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Monarda_citriodora';
my $average= '0.03';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Phegopteris_hexagonoptera';
my $average= '0.018';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Pisonia_rotundata';
my $average= '0.3';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Rhynchospora_megaplumosa';
my $average= '0.25';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Scandix_pecten-veneris';
my $average= '0.005';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Schwalbea_americana';
my $average= '0.011';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Sideroxylon_alachuense';
my $average= '0.09';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Solidago_nemoralis';
my $average= '0.02';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Tragia_urticifolia';
my $average= '0.015';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Trifolium_lappaceum';
my $average= '0.02';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Verbena_simplex';
my $average= '0.012';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Xyris_panacea';
my $average= '0.1';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Ziziphus_celata';
my $average= '0.03';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

my $species= 'Melilotus_officinalis';
my $average= '0.04';
	open FH1, "</scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present.$species.OUT/$species\_present0212_avg.asc";
	open OUT1, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/Present$species.OUT/$species\_presentBio_avg.threshold.asc";
	open OUT2, ">/scratch/lfs/cgermain/MAXENT/YEARLYBIOCLIM/PresentOut/BINARY_MAPS/$species\_presentBio_avg.threshold.asc";
	my $flag=0;
	my $matchgreater=0;
	my $matchless=0;
	my $countnum=0;
	my $totalnum=0;
	while (<FH1>) {
	    if ($flag == 1) {
		my $line=$_;
		chomp $line;
		my @array = split(/ /, $line);
		for my $num (@array) {
		    $totalnum++;
		    if ($num == -9999) {
			print OUT1 "$num ";
			print OUT2 "$num ";
			$countnum++;
		    }
		    elsif ($num >= $average) {
			print OUT1  "1 ";
			print OUT2  "1 ";
#			print "$num\t1\n";
			$matchgreater++;
		    }
		    elsif ($num < $average) {
#			print "$num\t0\n";
			print OUT1 "0 ";
			print OUT2 "0 ";
			$matchless++;
		    }
		}
		print OUT1 "\n";
		print OUT2 "\n";
	    }
	    if ($flag == 0) {
		print OUT1;
		print OUT2;
		if (/NODATA_value/) {
		    $flag =1;
		}
	    }
}
close FH1;

