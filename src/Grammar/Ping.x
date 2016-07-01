{
module Grammar.Ping where

import Data.List

}

%wrapper "basic"

$pairSym = [=]
$whitespace = [\n\t\ ]
@label = [^$whitespace$pairSym]+
$numeric = [0-9]
@numFloat = $numeric+\.$numeric+
@numInt = $numeric+

tokens :-
    $whitespace+ { const Blank }
    $pairSym+ { const PairSym }
    @numFloat { NumFloat . read }
    @numInt { NumInt . read }
    @label { Label }

{

data Grammar = Blank
             | Label String
             | NumInt Int
             | NumFloat Float
             | PairSym
    deriving Show

}
