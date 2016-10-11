{
module Grammar.Ping.Grammatizer where

import Grammar.Ping.Tokenizer
}

%name happyGrammatize

%tokentype { Vocabulary }
%error { parseError }

{-
    [ LabelReply
    , Blank
    , Label "8.8.4.4"
    , Colon
    , Blank
    , LabelSeq
    , PairSym
    , NumInt 2
    , Blank
    , LabelTTL
    , PairSym
    , NumInt 52
    , Blank
    , LabelTime
    , PairSym
    , NumInt 702
    , Blank
    , Label "ms"
    ]
    -}

%token
    Blank { Blank }
    Label { Label $$ }
    LabelReply { LabelReply }
    LabelSeq { LabelSeq }
    LabelTTL { LabelTTL }
    LabelTime { LabelTime }
    NumInt { NumInt $$ }
    NumFloat { NumFloat $$ }
    PairSym { PairSym }
    Reply { Reply }
    Colon { Colon }
    TimeMS { TimeMS }

%monad {Maybe} {(>>=)} {return}

%%

ReplyLine : Header Target Seq TTL Time { ReplyLine { from = $2, seqn = $3, ttl = $4, time = $5 } }

Header : LabelReply Blank { () }

Target : Label Colon Blank { $1 }

Seq : LabelSeq PairSym NumInt Blank { $3 }

TTL : LabelTTL PairSym NumInt Blank { $3 }

Time : LabelTime PairSym NumInt Blank TimeUnit { ($3, $5) }

TimeUnit : TimeMS { MS }

{

parseError = return (Nothing)

data Sentence   = ReplyLine
                    { from :: String
                    , seqn :: Int
                    , ttl :: Int
                    , time :: (Int, TimeUnit)
                    }
                deriving Show

data TimeUnit = MS
    deriving Show

grammatize = happyGrammatize

}

