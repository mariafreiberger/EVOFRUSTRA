use strict;
use File::Copy;

open(Lista, "@ARGV[0]/OutPutFiles@ARGV[1]/ListaPDB.txt");

while(my $lista=<Lista>){
	chomp $lista;
	my @splitter=split "_",$lista;
	open(sal,">@ARGV[0]/OutPut@ARGV[1]/VisualizationScript/@splitter[0]_@splitter[1].pml");
	open(Equi,"@ARGV[0]/OutPutFiles@ARGV[1]/Equivalences/SalidaSRes@splitter[0]_@splitter[1].txt");
	print "@ARGV[0]/OutPutFiles@ARGV[1]/Equivalences/SalidaSRes@splitter[0]_@splitter[1].txt";
	open(EstCon,"@ARGV[0]/OutPutFiles@ARGV[1]/Equivalences/CharactPosDataN");
	print sal "load @ARGV[0]/OutPut@ARGV[1]/PDB/@splitter[0].pdb\nhide all\nshow cartoon, all\nbg_color white\ncolor black, all";
	my $EstCon=<EstCon>;
	while($EstCon=<EstCon>){
	my $Equi=<Equi>;
	my @splitE= split " ",$Equi;
	my @splitEC= split " ",$EstCon;
	if((@splitEC[11] eq "MAX")and(@splitEC[10]>0.5)){
		if(@splitEC[0] eq @splitE[0]){
				}
		else{
			while(@splitEC[0] eq @splitE[0]){
				$EstCon=<EstCon>;
					}		
			}
		if(@splitE[1]eq"N/A"){}
		else{		print sal "\nshow sticks, resi @splitE[1]\ncolor red,resi @splitE[1]";
			}			
		}
	if((@splitEC[11] eq "MIN")and(@splitEC[10]>0.5)){
		if(@splitEC[0] eq @splitE[0]){
				}
		else{
			while(@splitEC[0] eq @splitE[0]){
				$EstCon=<EstCon>;
					}
		}
		if(@splitE[1]eq"N/A"){}
		else{
			print sal "\nshow sticks, resi @splitE[1]\ncolor green,resi @splitE[1]";
				}			
		}
	if((@splitEC[11] eq "NEU")and(@splitEC[10]>0.5)){
		if(@splitEC[0] eq @splitE[0]){
				}
		else{
			while(@splitEC[0] eq @splitE[0]){
				$EstCon=<EstCon>;
					}
		}
		if(@splitE[1]eq"N/A"){}
		else{
			print sal "\nshow sticks, resi @splitE[1]\ncolor gray,resi @splitE[1]";
				}			
		}

	}
close(sal);
close(Equi);
close(EstCon);
}
close(Lista);
