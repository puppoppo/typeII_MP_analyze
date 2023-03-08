
open(fasta, "FT269.fas");
open(WRITE,">FT269start.csv");

my %amino_acid_values = (
	A => 1.8,
	C => 2.5,
	D => -3.5,
	E => -3.5,
	F => 2.8,
	G => -0.4,
	H => -3.2,
	I => 4.5,
	K => -3.9,
	L => 3.8,
	M => 1.9,
	N => -3.5,
	P => -1.6,
	Q => -3.5,
	R => -4.5,
	S => -0.8,
	T => -0.7,
	V => 4.2,
	W => -0.9,
	Y => -1.3
);

$, = ",";
$\ = "\n";
$A=-0.49;

while(<fasta>){
	chomp;

	if($_ =~ /^>/){
		$temp = substr($_,0,100);
	}
	else{
		$SEQUENCE=substr($_,0,10000);
		@sq=split(//,$SEQUENCE);
		@sqn=();

		for (my $i=0;$i<@sq;$i++) {
			if (exists $amino_acid_values{$sq[$i]}) {
				$sqn[$i] = $amino_acid_values{$sq[$i]};
			} else {
				die "Error: unknown amino acid $sq[$i] in sequence $swissid at position $i\n";
			}
		}

		$max = 0;
		@hydra = ();

		for($i=0;$i<@sq;$i++){
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

		for($N=2;$N<=5;$N++){
			for($O=2;$O<=5;$O++){

				@hy_N=();
				@hy_O=();
				@hy_deff=();
				$defmax=0;
				$Nend=0;
				$Ostart=0;

				if($max-20>0){
					$start=$max-20;
				}
				else{
					$start=0;
				}

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

				if($max-15-$N+1>0){
					$start=$max-15-$N+1;
				}else{
					$start=0;
				}
				$end=$max-5-$N+1;
				$defmax=$start;

				for($i=$start;$i<=$end;$i++){
					$hy_deff[$i] = -$hy_N[$i]+$hy_O[$i+$N];
					if($hy_deff[$i]>$hy_deff[$defmax]){
						$defmax=$i;
					}
				}

				$Nend=$defmax+$N-1;
				$Ostart=$defmax+$N;

				$TMRstart=$Ostart+1;

				@sq=split(//,$SEQUENCE);
				printf WRITE $temp.",".$TMRstart.",". $N .",".$O.",";

				printf WRITE "\n";

			}
		}




	}
}
print chr(7);	#終了時に音が鳴ります
