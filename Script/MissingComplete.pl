use strict;

open(align,"@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign.fasta");
open(sal,">@ARGV[0]/OutPutFiles@ARGV[1]/ListaPDBC.txt");

my %hash = ("CYS" => "C", "ASP"=>"D", "SER"=>"S"
,"GLN"=>"Q","LYS"=>"K","ILE"=>"I","PRO"=>"P",
"THR"=>"T","PHE"=>"F","ASN"=>"N","GLY"=>"G","HIS"=>"H","LEU"=>"L","ARG"=>"R",
"TRP"=>"W","ALA"=>"A","VAL"=>"V","GLU"=>"E","TYR"=>"Y","MET"=>"M");

my $pdb;
my $ch;
my $pdbch;
my $comienzo;


while(my $alin=<align>){
	chomp $alin;
	my $cline=0;
	my $long=0;
	my @sp;
	my $ba=0;
	my $ta;
	my @splitter= split "",$alin;
	if (@splitter[0]eq">"){
		print sal "@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6]\n";
		$pdb="@splitter[1]@splitter[2]@splitter[3]@splitter[4]";
		$ch="@splitter[6]";
		$pdbch="@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6]";
		print corregido ">$pdbch\n";
		my @splig= split "_",$alin;
		my $tc=@splig;
		my @com;
		my $count=0;
		if($tc==2){
			open(busca,"@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/$pdb.pdb");
			while(my $busca=<busca>){
				my @busca= split " ", $busca;
				my @busca2= split "", $busca;
				if((@busca[0] eq "REMARK")and(@busca[1]==465)and(@busca[3] eq $ch)and($count==0)){
					@com[0]=@busca[4];
					$count++;
					}
				if(@busca[0] eq "ATOM"){
					@com[1]="@busca2[22]@busca2[23]@busca2[24]@busca2[25]";
					if(@com[1]<@com[0]){
						$comienzo=@com[1];
						}
					else{
						$comienzo=@com[0];
						}
					last;
				}
			}			
			close(busca);
			}
		else{
			$comienzo=@splig[2];
			}
		open (SresSal,">@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/$pdbch.B99990001.pdb.done/FrustrationData/$pdb.pdb_singleresidue");
		}
	else{
		if($long==0){
			$long=@splitter;
			$ta=@splitter;	
			}
		open (Sres,"@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/$pdbch.B99990001.pdb.done/FrustrationData/$pdb.B99990001.pdb_singleresidue");
		my $Sres=<Sres>;
		print SresSal "$Sres";
		$Sres=<Sres>;
		my @spremark;	
		my @residuo;
		my $c=0;
		my @splires= split " ", $Sres;
		open(pdb,"@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/$pdb.pdb");	
		my $in=0;
		my $nind=0;
		while(my $pdb=<pdb>){
			my @splpdb= split " ", $pdb;
			my @splpdb2= split "", $pdb;
			if((@splpdb[0] eq "REMARK")and(@splpdb[1]==465)and(@splpdb[3] eq $ch)and(@splpdb[4]>=$comienzo)){
				if((@splpdb[0] eq @splires[2]) and (@splpdb[4]<0)){
						}					
				else{		
					if(@splpdb[4]<0){
						@spremark[$c]=$c+1;
						if($nind==0){
							$nind=@splpdb[4]*(-1)+1;
								}
						@residuo[$c]=$hash{@splpdb[2]};
							}	
					else{
						if(@splpdb[4]==0){
							if($c==0){
							@spremark[$c]=$c;}
							else{
								@spremark[$c]=$c+1;
								}
							@residuo[$c]=$hash{@splpdb[2]};
							$in=1;
							}
						else{	
							if($in==1){
								@spremark[$c]=@splpdb[4]+$nind;
								@residuo[$c]=$hash{@splpdb[2]};
								}
							else{
								@spremark[$c]=@splpdb[4];
								@residuo[$c]=$hash{@splpdb[2]};
								}
							}
						}
					$c++;
					}
				}
		}
		if(@spremark[0] eq ""){
			$cline=1;}
		else{
			if(($c>0)and($ba>@spremark[0])and($ba>$comienzo)){
				$cline=@spremark[0];
				}
			else{	
				if($comienzo<0){$cline=1;}			
				else{$cline=$comienzo;}
			}
		}
		close(pdb);
		$c=0;
		my $sum=$cline;
		while($cline<$long+$sum){
			if($cline==@spremark[$c]){
				print SresSal " Missing Atom @residuo[$c]\n";
				$c++;
				}	
			else{
				print SresSal "$Sres";
				$Sres=<Sres>;	
				}
				$cline++;	
			}
		open (SresSal,"@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/$pdbch.B99990001.pdb.done/FrustrationData/$pdb.pdb_singleresidue");
		my $indice=1;
		my $cont=0;
		$c=0;
		my $SresSal=<SresSal>;
		while($SresSal=<SresSal>){
			chomp $SresSal;
			my @spSresSal= split " ", $SresSal;
			while(@splitter[$cont] eq "-"){$cont++;
				}
			if((@splitter[$cont] eq @spSresSal[2]) and (@spSresSal[0] eq "Missing")){
				@spremark[$c]=$indice;
				$c++;
				}
			$cont++;
			$indice++;
			}
		close(SresSal);	
	}	
}
close(Sres);
close(SresSal);
close(corregido);
close(align);
