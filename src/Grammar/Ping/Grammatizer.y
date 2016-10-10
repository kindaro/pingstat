{
module Grammar.Ping.Grammatizer where
}

%name grammatize

%tokentype { Vocabulary }
%error { parseError }

%token
    blank { Blank }
    label { Label $$ }
    numInt { NumInt $$ }
    numFloat {NumFloat $$ }
    pairSym { PairSym }

%%

{
parseError :: [Token] -> a
parseError _ = error "Parse error"
}

