
open(SWISS, "typeII.dat");
open(WRITE,">2_hypeak_ft.csv");

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
$U=0;


while(<SWISS>){
	chomp;

	if($_ =~ /^ID   /){
		$swissid = substr($_,5,12);
		$swissid =~ s/\s//g;
	}
	 elsif($_ =~ /^DE/){
		if($_ =~ /Fragment/){
			$frag = 1;
		}
	}
	elsif($_ =~ /^OC   /){
		$swissoc .= substr($_,5,100);
	}
	elsif($_ =~ /^CC   -!- SUBCELLULAR LOCATION/){
		$suswitch = 1;
		$swisssu .= substr($_,30,100);
	}
	elsif($_ =~ /SUBCELLULAR/){
		$suswitch = 1;
		$swisssu = substr($_,30,100);
	}
	elsif($_ =~ /^CC   -!-|CC   ---/){
		$suswitch = 0;
	}
	elsif($_ =~ /^CC       / && $suswitch == 1){
		$swisssu .= substr($_,9,100);
	}
	elsif($_ =~/^FT   TRANSMEM/){
		$ftnumber++;
		$TMR = substr($_,21,100);
		@TMRregion = split(/\.\./, $TMR);
		$TMRstart = int($TMRregion[0]);
		$TMRend =  int($TMRregion[1]);
		$TMRregion = (0);
		$ftswitch = 1;
	}
	elsif($_ =~ /^FT       / && $ftswitch>=1 && $ftswitch < 3 ){
		$ftevi .= substr($_,21,100);
		$ftswitch ++;
	}
	elsif($_ =~ /^     /){
		$swisssq .= substr($_,5,100);
		$swisssq =~ s/\s//g;
		if($_ =~/U/ || $_ =~/X/){
			$U=1;
		}
	}

	elsif($_ =~ /^\/\//){

		if($ftevi =~ /ECO:0000269/){$FTeco=269;}
		elsif($ftevi =~ /ECO:0000303/){$FTeco=303;}
		elsif($ftevi =~ /ECO:0000305/){$FTeco=305;}
		elsif($ftevi =~ /ECO:0000250/){$FTeco=250;}
		elsif($ftevi =~ /ECO:0000255/){$FTeco=255;}
		elsif($ftevi =~ /ECO:0000256/){$FTeco=256;}
		elsif($ftevi =~ /ECO:0000259/){$FTeco=259;}
		elsif($ftevi =~ /ECO:0000312/){$FTeco=312;}
		elsif($ftevi =~ /ECO:0000313/){$FTeco=313;}
		elsif($ftevi =~ /ECO:0000244/){$FTeco=244;}
		elsif($ftevi =~ /ECO:0000213/){$FTeco=213;}

		if($swissoc =~ /Mammalia/ && $frag == 0 && $ftnumber == 1   && $U==0 ){
			if($swisssu =~ /type II |typeII /){

				@sq=split(//,$swisssq);

				for (my $i=0;$i<@sq;$i++) {
					if (exists $amino_acid_values{$sq[$i]}) {
						$sq[$i] = $amino_acid_values{$sq[$i]};
					} else {
						die "Error: unknown amino acid $sq[$i] in sequence $swissid at position $i\n";
					}
				}

				$start = 0;
				$end = @sq;
				$max = $start;

				@hydra = (0);

				for($i=$start;$i<=$end;$i++){
					for($j=-7;$j<=7;$j++){
						if($i+$j < 0){$hydra[$i]+= $A;} #無いところを＄A=0で置き換え
						elsif($i+$j >= 0){$hydra[$i]+= $sq[$i+$j];}
					}
					if($hydra[$max]<$hydra[$i]){
						$max=$i;
					}
				}

				$max=$max+1;	#プログラム上の残基数からuniprot上の残基数に変換

				$score = 0;
				if($TMRstart <= $max && $max <= $TMRend ){
					$score = 1;
				}
				if(1){
					$length = $TMRend - $TMRstart + 1;
					printf WRITE ">" . $swissid . "," . $score . "," . $TMRstart . "," . $TMRend . "," . $length . "," . $max . "," . $FTeco . "\n";
					printf WRITE $swisssq . "\n" ;
				}
			}
		}
		$swissid = "";
		$swissde = "";
		$frag = 0;
		$swissoc = "";
		$suswitch = 0;
		$swisssu = "";
		$ftnumber = 0;
		$TMR = "";
		$ftevi = "";
		$swisssq = "";
		$FTeco=0;
		$N=0;
		@sq = (0);
		$start =0;
		$end = 0;
		$length = 0;
		$ftswitch = 0;
		$U=0;
	}
}
