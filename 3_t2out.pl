
open(SWISS, "typeII.dat");
open(WRITE,">typeII_exclusion.dat");

$, = ",";
$\ = "\n";
$U=0;	#配列にU,Xが含まれているかフラグ化
@all=(0);

while(<SWISS>){
	chomp;

	$all[$j]=substr($_,0,1000);
	$j+=1;

	if($_ =~ /^ID   /){
		$swissid = substr($_,5,12);
		$swissid =~ s/\s//g;
	}
	 elsif($_ =~ /^DE/){
		if($_ =~ /^DE   RecName: Full=/){
			$swissde .= substr($_,19,100);
		}
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
	elsif($_ =~ /^CC   -!-|CC   ---/){
		$suswitch = 0;
	}
	elsif($_ =~ /^CC       / && $suswitch == 1){
		$swisssu .= substr($_,9,100);
	}
	elsif($_ =~/^FT   TRANSMEM/){	#出力はしてないけどTMR残基を格納しています
		$ftnumber++;
		$TMR = substr($_,21,100);
		@TMRregion = split(/\.\./, $TMR);
		$TMRstart = int($TMRregion[0]);
		$TMRend =  int($TMRregion[1]);
		$TMRregion = (0);
		$ftswitch = 1;
	}
	elsif($_ =~ /^FT       / && $ftswitch>=1 && $ftswitch < 3 ){	#FT TRANSMEM行の後ろ2行をfteviに格納
		$ftevi .= substr($_,21,100);
		$ftswitch ++;
	}
	elsif($_ =~/^FT   INTRAMEM/){
		$frag=1;
	}
	elsif($_ =~ /^     /){	#配列にU,Xが含まれているかフラグ化
		$swisssq .= substr($_,5,100);
		$swisssq =~ s/\s//g;
		if($_ =~/U|X/){
			$U=1;
		}
	}

	elsif($_ =~ /^\/\//){

		if($swissoc =~ /Mammalia/ && $frag == 0 && $ftnumber == 1 && $U==0 ){
			if($swisssu =~ /type II |typeII /){

				@sq=split(//,$swisssq);

				for($i=0;$i<@sq;$i++){
					if($sq[$i] =~ /B|J|O|U|X|Z/){
						printf "error" . $swissid ."," . $i. "\n";
					}
				}

				@su=split(/\.|\;/,$swisssu);

				for($i=0;$i<@su;$i++){
					if($su[$i] =~ /Note/){
						$note=1;
					}
					if($note==0 && $su[$i] =~ /type II |typeII /){
						if($su[$i] =~ /ECO:0000269/){$t2eco=269;}
						elsif($su[$i] =~ /ECO:0000303/){$t2eco=303;}
						elsif($su[$i] =~ /ECO:0000305/){$t2eco=305;}
						elsif($su[$i] =~ /ECO:0000250/){$t2eco=250;}
						elsif($su[$i] =~ /ECO:0000255/){$t2eco=255;}
						elsif($su[$i] =~ /ECO:0000256/){$t2eco=256;}
						elsif($su[$i] =~ /ECO:0000259/){$t2eco=259;}
						elsif($su[$i] =~ /ECO:0000312/){$t2eco=312;}
						elsif($su[$i] =~ /ECO:0000313/){$t2eco=313;}
						elsif($su[$i] =~ /ECO:0000244/){$t2eco=244;}
						elsif($su[$i] =~ /ECO:0000213/){$t2eco=213;}
						else{$t2eco=1;
							if($ftevi =~ /ECO:0000269/){$t2eco=269;}
							elsif($ftevi =~ /ECO:0000303/){$t2eco=303;}
							elsif($ftevi =~ /ECO:0000305/){$t2eco=305;}
							elsif($ftevi =~ /ECO:0000250/){$t2eco=250;}
							elsif($ftevi =~ /ECO:0000255/){$t2eco=255;}
							elsif($ftevi =~ /ECO:0000256/){$t2eco=256;}
							elsif($ftevi =~ /ECO:0000259/){$t2eco=259;}
							elsif($ftevi =~ /ECO:0000312/){$t2eco=312;}
							elsif($ftevi =~ /ECO:0000313/){$t2eco=313;}
							elsif($ftevi =~ /ECO:0000244/){$t2eco=244;}
							elsif($ftevi =~ /ECO:0000213/){$t2eco=213;}
						}
					}
				}

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
						printf "error" . $swissid . $i. "\n";
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

				$boader=0;
				$NG=0;

				$boader=$hydra[$max]*0.9;	#ピークの90％（要検討）をボーダーとする
				for($i=0;$i<@sq;$i++){
					if($hydra[$i]>$boader){
						if($i<$max-20 || $i>$max+20){
							$NG=1;
						}
					}
				}
				$max=$max+1;
				if($TMRstart!=0 && $TMRend!=0){
					if($TMRstart > $max || $TMRend < $max){
						$NG=1;
					}
				}

				if($NG==0){
					for($i=0;$i<@all;$i++){
						printf WRITE $all[$i]."\n";
					}
				}
			}
		}
		$swissid = "";
		$swissde = "";
		$frag = 0;
		$swissoc = "";
		$suswitch = 0;
		$swisssu = "";
		$swisssq = "";
		@sq = (0);
		$U=0;
		$ftnumber=0;
		@su=(0);
		$t2eco=0;
		$TMRstart=0;
		$TMRend=0;
		$j=0;
		@all=(0);
	}
}

print chr(7);	#終了時に音が鳴ります
