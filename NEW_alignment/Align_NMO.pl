
open(fasta, "FT269.fas");
open(WRITE,">ali_test313.fas");

$, = ",";
$\ = "\n";
$A=-0.49;
$N=3;
$M=1;
$O=3;

while(<fasta>){
	chomp;

	if($_ =~ /^>/){
		$temp = substr($_,0,100);
		printf WRITE $temp."\n";
	}
	elsif($_ =~ /^X/){
		$SEQUENCE=substr($_,0,10000);
		@sq=split(//,$SEQUENCE);

		for($i=0;$i<@sq;$i++){
			if($sq[$i] =~ /A/){
				$sq[$i] = 1.8;
			}
			elsif($sq[$i] =~ /C/){
				$sq[$i]=2.5;
			}
			elsif($sq[$i] =~ /D/){
				$sq[$i]=-3.5;
			}
			elsif($sq[$i] =~ /E/){
				$sq[$i]=-3.5;
			}
			elsif($sq[$i] =~ /F/){
				$sq[$i]=2.8;
			}
			elsif($sq[$i] =~ /G/){
				$sq[$i] = -0.4;
			}
			elsif($sq[$i] =~ /H/){
				$sq[$i]=-3.2;
			}
			elsif($sq[$i] =~ /I/){
				$sq[$i]=4.5;
			}
			elsif($sq[$i] =~ /K/){
				$sq[$i]=-3.9;
			}
			elsif($sq[$i] =~ /L/){
				$sq[$i]=3.8;
			}
			elsif($sq[$i] =~ /M/){
				$sq[$i]=1.9;
			}
			elsif($sq[$i] =~ /N/){
				$sq[$i]=-3.5;
			}
			elsif($sq[$i] =~ /P/){
				$sq[$i]=-1.6;
			}
			elsif($sq[$i] =~ /Q/){
				$sq[$i]=-3.5;
			}
			elsif($sq[$i] =~ /R/){
				$sq[$i]=-4.5;
			}
			elsif($sq[$i] =~ /S/){
				$sq[$i]=-0.8;
			}
			elsif($sq[$i] =~ /T/){
				$sq[$i]=-0.7;
			}
			elsif($sq[$i] =~ /V/){
				$sq[$i]=4.2;
			}
			elsif($sq[$i] =~ /W/){
				$sq[$i]=-0.9;
			}
			elsif($sq[$i] =~ /Y/){
				$sq[$i]=-1.3;
			}
			else{
				printf "error" . $temp . $i. "\n";
			}
		}

		$max = 0;
		@hydra = (0);
		@hy_N = (0);
		@hy_M = (0);
		@hy_deff = (0);

		for($i=0;$i<@sq;$i++){
			for($j=-7;$j<=7;$j++){
				if($i+$j < 0){$hydra[$i]+= $A;} #無いところを＄A=-0.49(全アミノ酸の平均値)で置き換え
				elsif($i+$j >= 0){$hydra[$i]+= $sq[$i+$j];}
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

		$defmax=$start;

		for($i=$start;$i<=$start+25;$i++){
			for($j=0;$j<$N;$j++){
				if($i+$j < 0){$hy_N[$i]+= $A;} #無いところを＄A=-0.49で置き換え
				elsif($i+$j >= 0){$hy_N[$i]+= $sq[$i+$j];}
			}
			$hy_N[$i]=$hy_N[$i]/$N;

			for($j=0;$j<$O;$j++){
				if($i+$j < 0){$hy_O[$i]+= $A;} #無いところを＄A=-0.49で置き換え
				elsif($i+$j >= 0){$hy_O[$i]+= $sq[$i+$j];}
			}
			$hy_O[$i]=$hy_O[$i]/$O;
		}

		for($i=$start;$i<=$start+25-$N-$M;$i++){
			$hy_deff[$i] = -$hy_N[$i]+$hy_O[$i+$N+$O];
			if($hy_deff[$i]>$hy_deff[$defmax]){
				$defmax=$i;
			}
		}

		$Nend=$defmax+$N;
		$Ostart=$defmax+$N+$O+1;

		@sq=split(//,$SEQUENCE);;
		printf WRITE $Nend.",". $Ostart .",".$max."\n";

		for($i=$Nend-15;$i<=$Ostart+15;$i++){
			if($i<=0 || $i>=@sq){
				printf WRITE "X";
			}
			else{
				printf WRITE $sq[$i];
			}
		}

		printf WRITE "\n";

	}
}
print chr(7);	#終了時に音が鳴ります
