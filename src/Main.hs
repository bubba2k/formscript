module Main where
import Parse ( Statement(..), parse )
import Eval  ( evalExpr )
import Map   ( Map, empty, insert, remove )
import System.Environment
import System.Exit
import System.IO

putStrFlush :: String -> IO ()
putStrFlush str = putStr str >> hFlush stdout

promptVal :: String -> IO Double
promptVal prompt = do putStrFlush ("?- " ++ prompt ++ ": ")
                      val <- readLn :: IO Double
                      return val

evalStat map (Question prompt iden) = do val <- promptVal prompt
                                         return (insert (iden, val) map)
evalStat map (Equation iden expr) = do return (insert (iden, val) map)
                                         where val = evalExpr map expr
evalStat map (Result text expr) = do putStrFlush (":- " ++ text ++ ": ")
                                     hFlush stdout
                                     putStrLn $ show (evalExpr map expr)
                                     return map
evalStat map (Info text) = putStrLn text >> return map

evalProg :: Map String Double -> [Statement] -> IO ()
evalProg map [] = putStr ""
evalProg map (st:xs) = do map' <- evalStat map st
                          evalProg map' xs


parseArgs [] = do putStrLn "Please supply a single input file."
                  exitWith (ExitFailure 1)
parseArgs [arg] = readFile arg

-- Keep the predefined constants in this map...
-- Note: It is technically possible to overwrite these during
-- runtime
initialmap = [ ("PI", 3.14159265359), ("E", 2.7182) ]

runSource source = case parse source of
                    Left err   -> putStrLn $ show err
                    Right prog -> evalProg initialmap prog

main :: IO ()
main = getArgs >>= parseArgs >>= runSource
