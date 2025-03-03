module Eval ( evalExpr ) where
import Data.Either
import Parse ( Statement(..), Expr(..), parse )
import Map ( Map(..), empty, insert, remove )

-- Evaluate an expression. Throws if unused identifier is dereferenced
evalExpr :: Map String Double -> Expr -> Double
evalExpr m (Add a b) = evalExpr m a +  evalExpr m b
evalExpr m (Sub a b) = evalExpr m a -  evalExpr m b
evalExpr m (Mul a b) = evalExpr m a *  evalExpr m b
evalExpr m (Div a b) = evalExpr m a /  evalExpr m b
evalExpr m (Pow a b) = evalExpr m a ** evalExpr m b
evalExpr m (Val v) = v
evalExpr m (Var  id) = case lookup id m of 
                        Nothing -> error ("Use of undefined variable " ++ id)
                        Just v  -> v
