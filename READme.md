# README
修士論文の本文で用いたソースコードを載せています。特にAAgraphなどのコードは参考になるかもしれません。使用言語はperlとpython(jupyter notebook)です。
修論の本文で登場した順番に記載しています。

## 0_t2all.pl
uniprotのバッチファイルから、「哺乳類」「Ⅱ型1回膜貫通タンパク質」「合成後断片化されない(されるとわかっていない)」「アミノ酸配列に"U","X"を含まない」タンパク質の記述を"uniiprot形式ですべて"出力します。

## 1_FTeco_count
該当タンパク質のFT行におけるECOコードを出力します。

## 2_hypeak_ft.pl
uniprot記載情報と独自に推定したTMR中心を比較して、記載されたTMR内に中心がある場合は$score=1として出力します。

## 3_t2out.pl
該当タンパク質からいくつかのタンパク質を除外します。
TMR箇所にuniprotと独自の推定で食い違いがあるタンパク質と、有力なTMR候補を持ったタンパク質を除外しています。

## 3a_dat_purepm.pl
uniprot形式のバッチファイルから、「Ⅱ型1回膜貫通タンパク質だと十分確からしい」「実験的確証のもと細胞膜に局在する」「細胞膜以外への局在は記載されていない(局在すると明らかにされていない)」の条件を満たすタンパク質のfastaファイルを出力します。

## 3b_dat_npm.pl
uniprot形式のバッチファイルから、「Ⅱ型1回膜貫通タンパク質だと十分確からしい」「細胞膜への局在は記載されていない(局在すると明らかにされていない)」の条件を満たすタンパク質のfastaファイルを出力します。

## 3c_FT269.pl
バッチファイルから「TMR情報に実験的確証がある」タンパク質のfastaファイルを出力します。

## 3d_slash_count.pl
バッチファイルの"//"を数えて出力します。

## 4_TMRcenter.pl
fastaファイルからTMR中心を推定し、中心から前後25残基、合計51残基のアミノ酸を出力します。配列外および開始コドンのメチオニンは"X"として出力します。

## 4a_hydr_graph.ipynb
アミノ酸配列を入力すると疎水性値の移動平均プロットを出力します。

## 4b_X.ipynb
fastaファイルからアミノ酸Xの出現傾向を出力します。

## 5_AAgraph_3win.ipynb
データセット間におけるAAindex指標の有意差を出力します。周辺1残基を含めた解析です。

## 6a_FT269_hydr_start.pl
FT269データセットにおいて移動平均幅n,m=2~5それぞれでTMR開始残基を求めた結果を出力します。出力する残基は開始コドンを1残基目として数えたものです。

## 6b_FT269_hydr_end.pl
FT269データセットにおいて移動平均幅n,m=2~5それぞれでTMR終了残基を求めた結果を出力します。出力する残基は開始コドンを1残基目として数えたものです。

## 7a_hydr_TMRstart.pl
fastaファイルからn,m=2でTMR開始残基を予測し、その前後25残基を出力します。

## 7b_hydr_TMRend.pl
fastaファイルからn,m=2でTMR終了残基を予測し、その前後25残基を出力します。

## 7c_hydr_TMRlen.pl
fastaファイルからn,m=2でTMR終了残基を予測し、TMR残基の長さを出力します。

## 8_AAgraph_1win.ipynb
データセット間におけるAAindex指標の有意差を出力します。

## 9a_amph_TMRstart.pl
fastaファイルから、両親媒性を用いた独自アラインメントによってTMR開始残基の周辺配列を出力します。

## 9b_amph_TMRend.pl
fastaファイルから、両親媒性を用いた独自アラインメントによってTMR開始残基の周辺配列を出力します。

## 9c_amph_start_uni_compare.pl
独自アラインメントを用いて求めたTMR開始残基とuniprot記載情報を出力します。

## 9d_amph_end_uni_compare.pl
独自アラインメントを用いて求めたTMR終了残基とuniprot記載情報を出力します。
