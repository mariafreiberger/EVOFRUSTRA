use strict;

open (pdb,"@ARGV[2]/OutPutFiles@ARGV[3]/@ARGV[0].pdb");
open (guarda, ">@ARGV[2]/OutPutFiles@ARGV[3]/Modeller/@ARGV[0].pdb");
my $pdbid;
my $cade;
my $expd;
my $r=0;

while(my $pdb=<pdb>){
	chomp $pdb; 
	my @splitter= split " ", $pdb;
	if((@splitter[0]eq "EXPDTA")and(@splitter[1]eq "SOLUTION")){
		print guarda "$pdb\n";
		$expd=@splitter[1];
		}
	else{
		if(@splitter[0]eq "ATOM"){last;}
		else {print guarda "$pdb\n";}
			}
		}
my $com=0;
while(my $pdb=<pdb>){
	chomp $pdb;
	my @splitter= split " ", $pdb;
	my @spl= split "", $pdb;
	if(@splitter[0]eq "TER"){
		if ($expd eq "SOLUTION"){last;}
		}
	if(@splitter[0]eq "ATOM"){
		if(@spl[21] eq @ARGV[1]){	
				print guarda "$pdb\n";
			}
		}
	else {
		if (@splitter[0]eq"HETATM"){
	
			}
		}
		if(@splitter[0] eq "ENDMDL"){
			last;		
				}
			
	}
close(pdb);
close(guarda);	
