{-# LANGUAGE
    LambdaCase
  #-}

module Main where

import              Control.Arrow
import              Control.Exception
import              Control.Monad.Writer
import              Data.Tuple.Select       (sel2)
import              Data.Maybe              (fromJust, catMaybes)
import              GHC.IO.Handle
import              Grammar.Ping.Tokenizer
import              Grammar.Ping.Grammatizer
import              System.Environment
import              System.IO
import              System.IO.Error
import              System.Process

main :: IO ()
main = do
        hSetBuffering stdout NoBuffering
        createPingProcess
        >>= readLoop
        >>= (catMaybes >>> fmap show >>> sequence_.fmap putStrLn)

createPingProcess = (fromJust . sel2) <$> createProcess
    (proc "ping" [target, "-c", show 3]) { std_out = CreatePipe }

readLoop :: Handle -> IO [Maybe Sentence]
readLoop handle =
        hGetContents handle >>= return . fmap (grammatize . alexScanTokens) . lines

target :: String
target = "8.8.4.4"

