
open(fasta, "FT269_fusion.fas");
open(WRITE,">FT269_pro_end.csv");

$, = ",";
$\ = "\n";
$A=-0.49;
$M=0;


while(<fasta>){
	chomp;

	if($_ =~ /^>/){
		$temp = substr($_,0,100);
	}
	else{
		$SEQUENCE=substr($_,0,10000);
		@sq=split(//,$SEQUENCE);
		@sqn=();

		for($i=0;$i<@sq;$i++){
			if($sq[$i] =~ /A/){
				$sqn[$i] = 1.8;
			}
			elsif($sq[$i] =~ /C/){
				$sqn[$i]=2.5;
			}
			elsif($sq[$i] =~ /D/){
				$sqn[$i]=-3.5;
			}
			elsif($sq[$i] =~ /E/){
				$sqn[$i]=-3.5;
			}
			elsif($sq[$i] =~ /F/){
				$sqn[$i]=2.8;
			}
			elsif($sq[$i] =~ /G/){
				$sqn[$i] = -0.4;
			}
			elsif($sq[$i] =~ /H/){
				$sqn[$i]=-3.2;
			}
			elsif($sq[$i] =~ /I/){
				$sqn[$i]=4.5;
			}
			elsif($sq[$i] =~ /K/){
				$sqn[$i]=-3.9;
			}
			elsif($sq[$i] =~ /L/){
				$sqn[$i]=3.8;
			}
			elsif($sq[$i] =~ /M/){
				$sqn[$i]=1.9;
			}
			elsif($sq[$i] =~ /N/){
				$sqn[$i]=-3.5;
			}
			elsif($sq[$i] =~ /P/){
				$sqn[$i]=-1.6;
			}
			elsif($sq[$i] =~ /Q/){
				$sqn[$i]=-3.5;
			}
			elsif($sq[$i] =~ /R/){
				$sqn[$i]=-4.5;
			}
			elsif($sq[$i] =~ /S/){
				$sqn[$i]=-0.8;
			}
			elsif($sq[$i] =~ /T/){
				$sqn[$i]=-0.7;
			}
			elsif($sq[$i] =~ /V/){
				$sqn[$i]=4.2;
			}
			elsif($sq[$i] =~ /W/){
				$sqn[$i]=-0.9;
			}
			elsif($sq[$i] =~ /Y/){
				$sqn[$i]=-1.3;
			}
			else{
				printf "error" . $temp . $i. "\n";
			}
		}

		printf WRITE $temp."\n";



		for($N=2;$N<=5;$N++){
			for($O=2;$O<=5;$O++){
				@hydra=();
				$max=0;

				for($i=0;$i<@sqn;$i++){
					for($j=-7;$j<=7;$j++){
						if($i+$j < 0){$hydra[$i]+= $A;} #無いところを＄A=-0.49(全アミノ酸の平均値)で置き換え
						elsif($i+$j >= 0){$hydra[$i]+= $sqn[$i+$j];}
					}
					if($hydra[$max]<$hydra[$i]){
						$max=$i;
					}
				}

				if($max-20>0){
					$start=$max-20;
				}
				else{
					$start=0;
				}


				my @hy_N=();
				my @hy_M=();
				my @hy_deff=();
				my $defmax=0;
				$Nend=0;
				$Ostart=0;

				$defmax=$start;

				for($i=$start;$i<=$start+25;$i++){
					for($j=0;$j<$N;$j++){
						if($i+$j < 0){$hy_N[$i]+= $A;} #無いところを＄A=-0.49で置き換え
						elsif($i+$j >= 0){$hy_N[$i]+= $sqn[$i+$j];}
					}
					$hy_N[$i]=$hy_N[$i]/$N;

					for($j=0;$j<$O;$j++){
						if($i+$j < 0){$hy_O[$i]+= $A;} #無いところを＄A=-0.49で置き換え
						elsif($i+$j >= 0){$hy_O[$i]+= $sqn[$i+$j];}
					}
					$hy_O[$i]=$hy_O[$i]/$O;
				}

				for($i=$start;$i<=$start+25-$N-$M;$i++){
					$hy_deff[$i] = $hy_N[$i]-$hy_O[$i+$N+$M];
					if($hy_deff[$i]>$hy_deff[$defmax]){
						$defmax=$i;
					}
				}

				$Nend=$defmax+$N-1;
				$Ostart=$defmax+$N+$M;

				printf WRITE $Nend.",".$Ostart.",".$N.$M.$O.",";

				for($i=$Nend-15;$i<=$Ostart+15;$i++){
					if($i<=0 || $i>=@sq){
						printf WRITE "X,";
					}
					else{
						printf WRITE $sq[$i].",";
					}
				}
				printf WRITE "\n";
			}
		}

		printf WRITE "\n";

	}
}
print chr(7);	#終了時に音が鳴ります
