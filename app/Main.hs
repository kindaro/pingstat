module Main where

import GHC.IO.Handle
import System.IO.Error
import System.Process
import Control.Exception

main :: IO ()
main = do
        (_, Just hout, _, _) <- createProcess
            (proc "ping" [target, "-c", show (60)])
            { std_out = CreatePipe }
        printLoop hout

        where
        printLoop handle =
            try (putStrLn =<< hGetLine handle)
            >>= either
                    (const $ return () :: IOException -> IO ())
                    (const $ printLoop handle)

target :: String
target = "192.168.0.1"

