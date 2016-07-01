{
module Grammar.Ping where

import Data.List

}

%wrapper "basic"

$pairSym = [=]
$whitespace = [\n\t\ ]
$char = [~$whitespace]

tokens :-
    $whitespace+ { const Blank }
    $char+ {
            ( \x -> ( maybe (Word x) (Pair . (\(p1,p2) -> (p1, tail p2))) ) $
              (( findIndex (== '=') x)
               >>= Just . (flip splitAt) x) )
        }

{

data Grammar = Blank
             | Word String
             | Pair (String, String)
    deriving Show

}
