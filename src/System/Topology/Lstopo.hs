module System.Topology.Lstopo (
    getCurrentMachine
) where

import System.Exit
import System.FilePath
import System.IO.Temp
import System.Process

import System.Topology.HwlocXML
import System.Topology.Types

-- | Invokes @lstopo@ to generate a 'Machine' representing the current system.
getCurrentMachine :: IO Machine
getCurrentMachine = 
    withSystemTempDirectory "topo." $ \dir -> do
      let topoFile = dir </> "topo.xml"
      code <- system $ unwords ["lstopo", topoFile]
      case code of
        ExitSuccess -> readLstopoXML topoFile
        ExitFailure err -> error ("lstopo returned non-zero code: " ++ show err)