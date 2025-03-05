module Parse ( Statement(..), Expr(..), parse ) where

import Prelude hiding ( const )
import Text.Parsec hiding ( parse )
import Text.Parsec.Expr
import Text.Parsec.Token
import Text.Parsec.Language
import Text.Parsec.String ( Parser )

data Statement = Question String String | Equation String Expr | 
                 Result String Expr | Info String deriving Show;

data Expr = Add Expr Expr | Sub Expr Expr | Mul Expr Expr |
            Div Expr Expr | Pow Expr Expr | 
            Val Double  | Var String deriving Show;

def :: LanguageDef String
def = emptyDef{ commentStart = ""
              , commentEnd = ""
              , commentLine = "#"
              , identStart = letter
              , identLetter = alphaNum <|> char '_' <|> char '\''
              , opStart  = oneOf "+-*^"
              , opLetter = oneOf "+-*^"
              , reservedOpNames = ["+", "-", "*", "/", "^" ]
              , reservedNames = ["info", "get", "put"]
              }

TokenParser{ parens = m_parens
           , identifier = m_identifier
           , reservedOp = m_reservedOp
           , reserved = m_reserved
           , semiSep1 = m_semiSep1
           , whiteSpace = m_whiteSpace
           , symbol = m_symbol
           , semi = m_semi
           , naturalOrFloat = m_naturalOrFloat
           , stringLiteral  = m_stringLiteral
           } = makeTokenParser def

var  = do name <- m_identifier
          return (Var name)

litr = do val <- m_naturalOrFloat
          return (Val (case val of
                              Left  x -> fromIntegral x :: Double
                              Right x -> x))

expr = buildExpressionParser table term <?> "expression"

term = m_parens expr <|> litr <|> var <?> "expression"

table = [ 
          [Infix (m_reservedOp "^" >> return (Pow)) AssocRight]
        , [Infix (m_reservedOp "*" >> return (Mul)) AssocLeft
        ,  Infix (m_reservedOp "/" >> return (Div)) AssocLeft]
        , [Infix (m_reservedOp "+" >> return (Add)) AssocLeft
        ,  Infix (m_reservedOp "-" >> return (Sub)) AssocLeft]
        ]

ques = do m_reserved "get"
          text <- m_stringLiteral
          name <- m_identifier
          return (Question text name)
equa = do iden <- m_identifier
          m_symbol "="
          exp  <- expr
          return (Equation iden exp)
resu = do m_reserved "put"
          test <- m_stringLiteral
          exp  <- expr
          return (Result test exp)
info = do m_reserved "info"
          strs <- many1 m_stringLiteral
          return (Info (foldr (++) "" strs))

prog = do m_whiteSpace
          stmts <- sepEndBy1 (ques <|> equa <|> resu <|> info) m_semi
          eof
          return stmts

parse = runParser prog "" ""
