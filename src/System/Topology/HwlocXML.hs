module System.Topology.HwlocXML (
  readLstopoXML
) where

import Control.Applicative

import System.Topology.Types

import Text.XML.Light

parseMachine :: Element -> Machine
parseMachine = Machine . map parseCore . findChildCores

parseCore :: Element -> Core
parseCore e | isCore e = Core { coreIndex = parseIndex e
                              , childPUs  = parsePU <$> findChildPUs e
                              }
            | otherwise = error "parseCore found non-core"

parseIndex :: Element -> Int
parseIndex e = read i :: Int
  where i = case findAttr (unqual "os_index") e of
              Just str -> str
              Nothing  -> error "Core/PU without os_index"

parsePU :: Element -> PU
parsePU e | isPU e    = PU { puIndex = parseIndex e }
          | otherwise = error "parsePU found non-PU"

isType :: String -> Element -> Bool
isType ty e = findAttr (unqual "type") e == Just ty

isCore :: Element -> Bool
isCore = isType "Core"

findChildCores :: Element -> [Element]
findChildCores topo = filterElements isCore topo

isPU :: Element -> Bool
isPU = isType "PU"

findChildPUs :: Element -> [Element]
findChildPUs core = filterElements isPU core

readLstopoXML :: FilePath -> IO Machine
readLstopoXML file = do
  mroot <- parseXMLDoc <$> readFile file
  let root = case mroot of
               Just e -> e
               Nothing -> (error "Could not parse lstopo output as valid XML")
  return $ maybe (error "Could not find Machine information from lstopo output")
                 parseMachine
                 (filterElement (isType "Machine") root)
                 