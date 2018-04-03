use strict;

open(blista,"@ARGV[0]/OutPutFiles@ARGV[1]/Sequences.fasta");
open(ListaBlast,">@ARGV[0]/OutPutFiles@ARGV[1]/ListaPDB.txt");
open(error,">@ARGV[0]/OutPutFiles@ARGV[1]/SinPDB.txt");
open(outfasta,">@ARGV[0]/OutPutFiles@ARGV[1]/SequencesComplete.fasta");

my $e=1;

while(my $lineB=<blista>){
	chomp $lineB;
	$lineB =~ tr/a-z/A-Z/;
	my @splitter= split "", $lineB;
	system("awk '\$2 ~ /$lineB/' @ARGV[0]/pdb_seq.txt > @ARGV[0]/OutPutFiles@ARGV[1]/Listaawk.txt");
	open (awk,"@ARGV[0]/OutPutFiles@ARGV[1]/Listaawk.txt");
	my $linepdb=<awk>;
	my @splitpdb=split " ",$linepdb;
	if (@splitpdb[0]eq""){
		my $tam=@splitter;
		my $lineBc=substr($lineB,0,$tam/2);
		my $lineBf=substr($lineB,$tam/2,$tam);
		system("awk '\$2 ~ /my $lineBc/' @ARGV[0]/pdb_seq.txt > @ARGV[0]/OutPutFiles@ARGV[1]/Listaawk.txt");
		open (awk,"@ARGV[0]/OutPutFiles@ARGV[1]/Listaawk.txt");
		my $linepdb=<awk>;
		my @splitpdb=split " ",$linepdb;
			if (@splitpdb[0]eq""){
				system("awk '\$2 ~ /my $lineBf/' @ARGV[0]/pdb_seq.txt > @ARGV[0]/OutPutFiles@ARGV[1]/Listaawk.txt");
				open (awk,"@ARGV[0]/OutPutFiles@ARGV[1]/Listaawk.txt");
				my $linepdb=<awk>;
				my @splitpdb=split " ",$linepdb;
				if (@splitpdb[0]eq""){
					print ListaBlast ">seqerror$e\n";
					print error "$lineB\n";
					$e++;		
					}
				else{
					print ListaBlast "@splitpdb[0]\n";
					}
				}
			else{
				print ListaBlast "@splitpdb[0]\n";
		}
	}
	else{
		print ListaBlast "@splitpdb[0]\n";
		}
	close(awk);
}

close(blista);
