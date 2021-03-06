use strict;
use Bio::SeqIO;

open(salida, ">@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign3.fasta"); #Alingment replacing Missing residues for "-"
open(sali, ">@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign4.fasta");  #Alingment replacing Missing residues for "Z"

my $pdbid;
my @sp;

open(align,"@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign2.fasta"); 
my $c;	

while (my $SEQ = <align>){
	chomp $SEQ;
	my @splitter= split "",$SEQ;
	my @spname= split "_",$SEQ;
	my $Sres;
	if(@splitter[0] eq ">"){
		$c=@spname[2];
		open(Sres,"@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6].pdb.done/FrustrationData/@splitter[1]@splitter[2]@splitter[3]@splitter[4].pdb_singleresidue");
		print salida "$SEQ\n";
		print sali "$SEQ\n";
		print "$SEQ\n";
		$Sres=<Sres>;
		}
	else{		
		my $Sres=<Sres>;
		my @splitres=split " ", $Sres;
		my $long=@splitter;
		my $i=@splitres[0];
		while($i<$c){
			if($i==$c){last;}
			$Sres=<Sres>;
			@splitres=split " ", $Sres;
			$i=@splitres[0];
			}
		$c=0;
		while($c<$long){
			@splitres=split " ", $Sres;
			if((@splitter[$c] eq "-") or (@splitter[$c] eq "X")){
				print salida "-";
				print sali "-";
				}	
			else{	
				if(@splitres[4] eq "Missing"){
					print salida "-";
					print sali "Z";
					$Sres=<Sres>;
					
				}
				else {
					print sali "@splitres[3]";
					print salida "@splitter[$c]";
					$Sres=<Sres>;
					}
				}
			$c++;
			}
	print sali "\n";
	print salida "\n";
	}

}

close(corregido);
close(salida);
close(sali);
