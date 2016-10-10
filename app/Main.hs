{-# LANGUAGE
    LambdaCase
  #-}

module Main where

import              Control.Exception
import              Control.Monad.Writer
import              Data.Tuple.Select       (sel2)
import              Data.Maybe              (fromJust)
import              GHC.IO.Handle
import              Grammar.Ping.Tokenizer
-- import              Grammar.Ping.Grammatizer
import              System.Environment
import              System.IO
import              System.IO.Error
import              System.Process

main :: IO ()
main = do
        hSetBuffering stdout NoBuffering
        >> getArgs >>= \case
            ["lines"] -> do
                createPingProcess >>= readLoop >>= sequence_.fmap (\x -> putStrLn x >> hFlush stdout)

            -- ["labels"] -> do
            --     Just hout <- createPingProcess
            --     readLoop hout >>= putStrLn . length


createPingProcess = (fromJust . sel2) <$> createProcess
    (proc "ping" [target, "-c", show 3]) { std_out = CreatePipe }

readLoop :: Handle -> IO [String]
readLoop handle =
    hSetBuffering handle NoBuffering >>
    hIsEOF handle >>= \case
        True -> return []
        False ->
            (liftM2 (:)) 
                ((try (hGetLine handle) :: IO (Either IOException String))
                    >>=     (either
                                (const $ return "Error!")
                                (return . show . alexScanTokens)
                            ))
                (readLoop handle)

copeWithError :: (Exception e, Show a) => Either e a -> String
copeWithError = either (const "Error!") (show)

target :: String
target = "8.8.4.4"

