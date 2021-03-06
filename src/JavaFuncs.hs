-- The goal of this is to convert Java method declarations to Haskell ones
-- This is built for converting CodingBat problems
-- Also it DOES NOT DO ERROR HANDLING
-- If your method would not compile in real life, it will either not compile here or it will become a mess
-- A java method needs to be in this format:
-- returnType funcName(DataType1 arg1, DataType2 arg2)
{-#LANGUAGE LambdaCase#-}

module Src.JavaFuncs
    ( DataType
    , mkType
    , mkContainer
    , dataTypeToHaskell
    , dataTypeToJava
    , javaToDataType

    , Function (funcName,retType,arguments)
    , mkFunction
    , funcToHaskell
    , funcToJava
    , javaToFunc
    , javaToHaskell
    , stripJava
    , formatArgs
    , javaCallToHaskell
    ) where

import Control.Arrow ((***),first)
import Data.Char (toUpper,isAlphaNum)
import Data.List (intercalate)
import Data.List.Split (splitOn)
import Text.Printf

import Text.Regex (mkRegexWithOpts,subRegex)
import Text.Regex.PCRE ((=~))

-- utility functions for splitting declarations

-- distinguishes a container from the rest of the string
-- returns (containerString, restOfString)
containContainer :: Int -> String -> (String,String)
containContainer _ [] = ([],[])
containContainer 0 (' ':xs) = ([],xs)
containContainer carrots ('<':xs) = (('<' :) *** id) $ containContainer (carrots + 1) xs
containContainer carrots ('>':xs) = (('>' :) *** id) $ containContainer (carrots - 1) xs
containContainer carrots (x:xs) = ((x :) *** id) $ containContainer carrots xs

-- Handles complex containers like Map<String, Map<Integer,String>>
typeSplitter :: Int -> String -> String -> [String]
typeSplitter _ current [] = [current]
typeSplitter 0 current (',':' ':xs) = current : typeSplitter 0 "" xs -- splitting with space
typeSplitter 0 current (',':xs) = current : typeSplitter 0 "" xs -- splitting without space
typeSplitter carrots current ('<':xs) = typeSplitter (carrots + 1) (current ++ "<") xs
typeSplitter carrots current ('>':xs) = typeSplitter (carrots - 1) (current ++ ">") xs
typeSplitter carrots current (x:xs) = typeSplitter carrots (current ++ [x]) xs


data DataType = Type String
              | Container String [DataType]
                deriving (Eq,Show)

mkType :: String -> DataType
mkType "" = Type ""
mkType (x:xs) = Type $ toUpper x : xs

mkContainer :: String -> [DataType] -> DataType
mkContainer s@(_:_) dts = Container s dts -- Making sure Container name is at least one letter long

typeToHaskell :: String -> String
typeToHaskell = \case
    ""        -> ""
    "Void"    -> "IO ()"
    "Boolean" -> "Bool"
    (x : xs)  -> toUpper x : xs -- All Haskell types need to start with a capital letter

containerToHaskell :: String -> [DataType] -> String
containerToHaskell str dts = case (str, dts) of
    ("Array",[dt]) -> "[" ++ (dataTypeToHaskell dt) ++ "]"
    ("List" ,[dt]) -> "[" ++ (dataTypeToHaskell dt) ++ "]"
    ("Map"  ,dts)  -> containerToHaskell "Map.Map" dts
    (str    ,dts)  -> str ++ " " ++ unwords (map eval dts) where
        -- Handles nested continers
        eval c@(Container typ _)
            | typ /= "Array" && typ /= "List" = "(" ++ dataTypeToHaskell c ++ ")"
            | otherwise = dataTypeToHaskell c
        eval dt = dataTypeToHaskell dt

dataTypeToHaskell :: DataType -> String
dataTypeToHaskell (Type str) = typeToHaskell str
dataTypeToHaskell (Container str dts) = containerToHaskell str dts

-- Not necessary to this project. Should delete?
dataTypeToJava :: DataType -> String
dataTypeToJava (Type t) = t
dataTypeToJava (Container "Array" [dt]) = dataTypeToJava dt ++ "[]"
dataTypeToJava (Container t dts) = t ++ "<" ++ intercalate ", " (map dataTypeToJava dts) ++ ">"

javaToDataType :: String -> DataType
javaToDataType str
    | null container        = mkType name
    | head container == '[' = mkContainer "Array" [javaToDataType $ name ++ drop 2 container]
    | otherwise             = mkContainer name (map javaToDataType $ typeSplitter 0 "" (init $ tail container))
    where (name,container) = break (`elem` "[<") str

data Function = Function { funcName :: String
                         , retType :: DataType
                         , arguments :: [(DataType,String)]
                         } deriving (Eq, Show)

mkFunction :: String -> DataType -> [(DataType, String)] -> Function
mkFunction fn@(_:_) rt args | all (\x -> isAlphaNum x || x `elem` "'_") fn = Function fn rt args
-- making sure funcName is at least one letter long and limits its charset to
-- a-zA-Z'_
-- it's not the strictest error checking but for this project it's more than it needs

-- creates a Haskell function declaration
funcToHaskell :: Function -> String
funcToHaskell (Function fn rt args) = printf "%s :: %s\n%s %s = undefined" fn arrows fn argnames where
    arrows = intercalate " -> "
           $ filter (not . null)
           $ map (dataTypeToHaskell . fst) args ++ [dataTypeToHaskell rt]
    argnames = unwords $ map snd args

-- creates a Java function declaration
-- not really necessary for this project but I like the symmetry
funcToJava :: Function -> String
funcToJava f = printf "%s %s(%s)" (dataTypeToJava $ retType f) (funcName f) args' where
    args' = intercalate ", " $ map (\(dt,s) -> unwords [dataTypeToJava dt,s]) $ arguments f

javaToFunc :: String -> Function
javaToFunc funcstr = mkFunction fn (javaToDataType rt) args where
    -- distinguishes containers in a string
    (rt,funcstr') = containContainer 0 funcstr
    (fn,args') = break (== '(') funcstr'
    args = map (first javaToDataType . containContainer 0) $ typeSplitter 0 "" $ init $ tail args'

javaToHaskell :: String -> String
javaToHaskell = funcToHaskell . javaToFunc . stripJava

-- strips the "public static final protected oblong juice" prefixes and the "{ " suffix
-- from method declarations
stripJava :: String -> String
stripJava funcstr = fix body ++ ")" where
    body = subRegex (mkRegexWithOpts ") ?\\{.*" False False) funcstr "" -- removes end
    fix s = let (prefix,suffix) = containContainer 0 s
        -- using PCRE because Text.Regex doesn't work here?
        in if (prefix =~ "^\\S+\\(" :: Bool) || (suffix =~ "^\\S+\\(" :: Bool)
            then unwords [prefix,suffix]
        else fix suffix


-- formats the arguments of a Java method into the Haskell argument format
-- e.g., "[1,2,3], 1, {\"a\": \"b\"}, \"hi\"" -> "[1,2,3] 1 Map.fromList [(\"a\",\"b\")]) \"hi\""
formatArgs :: String -> String
formatArgs "" = ""
formatArgs args = unwords $ map formatEdgeCases $ go 0 0 [] $ args where
    go _ _ current [] = [current]
    go quotes braces current (x:xs)
        | x `elem` "{([" && even quotes = go quotes (braces + 1) (current ++ [x]) xs
        | x `elem` "})]" && even quotes = go quotes (braces - 1) (current ++ [x]) xs
        | x == '"' && even quotes       = go (quotes + 1) braces (current ++ [x]) xs
        | x == '"' && odd quotes        = go (quotes - 1) braces (current ++ [x]) xs
        | x == ','
        , quotes == 0
        , braces == 0                   = current : go 0 0 "" xs
        | x == ' ' && quotes == 0       = go quotes braces current xs
        | otherwise                     = go quotes braces (current ++ [x]) xs

    formatEdgeCases "{}" = "Map.empty"
    formatEdgeCases ('{':xs) = "(Map.fromList ["
                          ++ intercalate ","
                                (map ((\[x,y] -> '(' : formatArgs x ++ "," ++ formatArgs y ++ ")") . splitOn ":")
                                    $ go 0 0 "" $ init xs)
                          ++ "])"
    formatEdgeCases ('-':xs) = "(-" ++ xs ++ ")" -- for negative numbers
    formatEdgeCases "false" = "False"
    formatEdgeCases "true" = "True"
    formatEdgeCases xs = xs

-- converts a Java method call to Haskell
javaCallToHaskell :: String -> String
javaCallToHaskell = unwords
                  . (\(func,args) -> filter (not . null) [func,formatArgs $ tail args])
                  . break (== '(')
                  . toLastParen where
    toLastParen s = take (go 0 0 s) s where
        go lastParen _ [] = lastParen
        go _ idx (')':xs) = go idx (idx + 1) xs
        go lastParen idx (_:xs) = go lastParen (idx + 1) xs