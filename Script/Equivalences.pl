use strict;

open(align,"@ARGV[0]/OutPutFiles@ARGV[1]/Posiciones");
my $pdb;

while(my $align=<align>){
	my $Sres;
	my @splitalign=split "",$align;	
	if(@splitalign[0]eq">"){
		my @sp=split "_",$align;
		my $t=@sp;
		if($t>2){	
			open(salida,">@ARGV[0]/OutPutFiles@ARGV[1]/Equivalences/SalidaSRes@splitalign[1]@splitalign[2]@splitalign[3]@splitalign[4]_@splitalign[6]_@sp[2].txt");#Create the Equival File
			}
		else{
			open(salida,">@ARGV[0]/OutPutFiles@ARGV[1]/Equivalences/SalidaSRes@splitalign[1]@splitalign[2]@splitalign[3]@splitalign[4]_@splitalign[6].txt"); #Create the Equival File
			}
		open(Sres,"@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/@splitalign[1]@splitalign[2]@splitalign[3]@splitalign[4]_@splitalign[6].pdb.done/FrustrationData/@splitalign[1]@splitalign[2]@splitalign[3]@splitalign[4].pdb_singleresidue"); #Frustration file
		$Sres=<Sres>; #Read the header
		$pdb="@splitalign[1]@splitalign[2]@splitalign[3]@splitalign[4]";
			}
	else{
		my @splitalignes=split " ",$align;
		my $ter=0;
		my $tam=@splitalignes;
		while($ter<$tam){
			$ter++;
			if((@splitalignes[$ter-1] eq "G") or (@splitalignes[$ter-1] eq "Z")){#is a gap or a mr?
				print salida "$ter	N/A	N/A	N/A	N/A\n";
				if(@splitalignes[$ter-1] eq "Z"){$Sres=<Sres>;}#is mr read a line in frustration file
						}
			else{	#is a aminoacid
				$Sres=<Sres>; #read a line i frustration file
				chomp $Sres;
				my @splitterSres=split " ",$Sres;
				if(@splitterSres[0] != @splitalignes[$ter-1]){ # check the numeration
						while(){
							$Sres=<Sres>;
							chomp $Sres;
							@splitterSres=split " ",$Sres;
							if((@splitterSres[0] == @splitalignes[$ter-1]) or (@splitterSres[0] eq "")){
									last;	
								}
						}
				}
				print salida "$ter	@splitterSres[0]	@splitterSres[3]	@splitterSres[7]	";		
				if(@splitterSres[7]>0.55){print salida "MIN\n";}
				else{
					if(@splitterSres[7]>-1){print salida "NEU\n";}
					else{print salida "MAX\n";}
					}
				}
			}
	}
	close(sal);	
	}
close(align);
close(Sres);
