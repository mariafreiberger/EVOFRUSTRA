use strict;

#/home/maria/Desktop/AutoLogo/OutPutFilesCDD15489

open(alin,"@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign.fasta");
open(sal,">@ARGV[0]/OutPutFiles@ARGV[1]/AlignSE.fasta");
open(lista,"@ARGV[0]/OutPutFiles@ARGV[1]/ListaPDB.txt");

my $c=0;
my $d=0;

my $line=<alin>;
chomp $line;
my @spline=split "", $line;
my $sq="@spline[4]@spline[5]";
my $r=0;

while(my $lista=<lista>){
	chomp $lista;
	$r++;
	if($r eq $sq){	
		$line=<alin>;
		print sal ">$lista\n$line";
	}
}

close(lista);

open(lista,"@ARGV[0]/OutPutFiles@ARGV[1]/ListaPDB.txt");
while($line=<alin>){
	$c++;
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
