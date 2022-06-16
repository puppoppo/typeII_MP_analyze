
open(fasta, "ppm_98.fas");
open(WRITE,">ppm_98_TMRstart.fas");

$, = ",";
$\ = "\n";
$A=-0.49;

while(<fasta>){
	chomp;

	if($_ =~ /^>/){
		$temp = substr($_,0,100);
		printf WRITE $temp."\n";
	}
	elsif($_ =~ /^M/){
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
		@hy_sum = (0);
		@hy_deff = (0);

		for($i=0;$i<@sq;$i++){
			for($j=-7;$j<=7;$j++){
				if($i+$j < 0){$hydra[$i]+= $A;} #無いところを＄A=0で置き換え
				elsif($i+$j >= 0){$hydra[$i]+= $sq[$i+$j];}
			}
			if($hydra[$max]<$hydra[$i]){
				$max=$i;
			}
		}

		if($max-15>0){
			$start=$max-15;
		}
		else{
			$start=0;
		}

		$defmax=$start;

		for($i=$start;$i<=$start+10;$i++){
			for($j=-1;$j<=0;$j++){
				if($i+$j < 0){$hy_sum[$i]+= $A;} #無いところを＄A=0で置き換え
				elsif($i+$j >= 0){$hy_sum[$i]+= $sq[$i+$j];}
			}
			if($i>=$start+2){
				$hy_deff[$i]=$hy_sum[$i]-$hy_sum[$i-2];
				if($hy_deff[$i]>$hy_deff[$defmax]){
					$defmax=$i;
				}
			}
		}

		@sq=split(//,$SEQUENCE);;
		# printf WRITE $defmax.",".$max."\n";

		for($i=$defmax-25;$i<=$defmax+25;$i++){
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
