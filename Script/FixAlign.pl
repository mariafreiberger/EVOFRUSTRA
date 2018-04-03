use strict;

#/home/maria/Desktop/AutoLogo/OutPutFilesCDD15489

open(alin,"@ARGV[0]/OutPutFiles@ARGV[1]/AlignSE.fasta");
open(sal,">@ARGV[0]/OutPutFiles@ARGV[1]/Alignment.fasta");
open(lista,"@ARGV[0]/OutPutFiles@ARGV[1]/ListaPDB.txt");

my $c=0;

while(my $line=<alin>){
	my $lista=<lista>;
	chomp $lista;
	my @splista=split "", $lista; 
	my @sp=split "", $line;
	$line=<alin>;
	if($splista[0]eq">"){
		}		
	else{	
		print sal ">$lista\n$line";
		}
}

close(alin);
close(sal);
