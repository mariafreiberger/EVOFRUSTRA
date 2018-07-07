use strict;
use File::Copy;

open(blista,"@ARGV[0]/OutPutFiles@ARGV[1]/Sequences.fasta");
open(salida,">@ARGV[0]/OutPutFiles@ARGV[1]/ListaPDB.txt");
open(ali,"@ARGV[0]/OutPutFiles@ARGV[1]/Alignment.fasta");
open(sal,">@ARGV[0]/OutPutFiles@ARGV[1]/Alignment2.fasta");

my $pdb;

while(my $lineB=<blista>){
	chomp $lineB;
	my $miss=-1;
	$lineB =~ tr/a-z/A-Z/;
	system("awk 'match(\$2, /$lineB/)' @ARGV[0]/DBSeq.fasta > @ARGV[0]/OutPutFiles@ARGV[1]/Listaawk.txt");
	open (awk,"@ARGV[0]/OutPutFiles@ARGV[1]/Listaawk.txt");
	my $ali=<ali>;
	$ali=<ali>;
	my $awk=<awk>;
	chomp $awk;
	my @spa= split " ",$awk; 
	my @sp= split "_",@spa[0];
	if($awk eq ""){
		
		}
	else{
		print salida "@spa[0]_";
		print sal ">@spa[0]_";	
		open(busca,"/home/maria/Desktop/PDBs/@sp[0].pdb");
		while(my $busca=<busca>){
			my @busca= split " ", $busca;
			if(@busca[0] eq "ATOM"){last;}
			if((@busca[0] eq "REMARK")and(@busca[1]==465)and(@busca[3] eq @sp[1])and(@busca[4]<0)){
					$miss=@busca[4]*(-1);
					last;
					}
				}
			close(busca);	
		}
	my $string = @spa[1];
	my $char = $lineB;
	my $tam= length($lineB);
	my $offset = 0;
	my $result = index($string, $char, $offset);
	while ($result != -1) {
		my $end=$result+$tam;
		my $ini=$result-$miss;
      		print salida "$ini\_$end\n";
		print sal "$ini\_$end\n";
        	$offset = $result + 1;
        	$result = index($string, $char, $offset);
		print sal "$ali\n"
	}
}
copy("@ARGV[0]/OutPutFiles@ARGV[1]/Alignment2.fasta","@ARGV[0]/OutPutFiles@ARGV[1]/Alignment.fasta");
close(blista);
close(seq);
close(ali)
