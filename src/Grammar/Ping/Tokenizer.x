{
module Grammar.Ping.Tokenizer where

import Data.List

}

%wrapper "basic"

$pairSym = [=]
$colon = [:]
$whitespace = [\n\t\ ]
@label = [^$whitespace$pairSym$colon]+
$numeric = [0-9]
@numFloat = $numeric+\.$numeric+
@numInt = $numeric+

tokens :-
    $whitespace+ { const Blank }
    $pairSym+ { const PairSym }
    @numFloat { NumFloat . read }
    @numInt { NumInt . read }
    $colon { const Colon }
    "64 bytes from" { const LabelReply }
    "icmp_seq" { const LabelSeq }
    "ttl" { const LabelTTL }
    "time" { const LabelTime }
    "ms" { const TimeMS }
    @label { Label }

{

data Vocabulary = Blank
                | Label String
                | LabelReply
                | LabelSeq
                | LabelTTL
                | LabelTime
                | NumInt Int
                | NumFloat Float
                | PairSym
                | Reply
                | Colon
                | TimeMS
    deriving Show

}
