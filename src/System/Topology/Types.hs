module System.Topology.Types (
    Machine(..)
  , Core(..)
  , PU(..)
) where

-- | Represents a single machine. This is the root of the topology for
-- the purposes of this library.
data Machine = Machine { cores :: [Core] }
               deriving (Eq, Ord, Show)

-- | Represents a single core, /not/ a single socket. However, this
-- may contain multiple 'PU's in the presence of, e.g.,
-- Hyperthreading.
data Core = Core { coreIndex :: Int
                 , childPUs  :: [PU]
                 }
            deriving (Eq, Ord, Show)

-- | Represents a single processing unit, and contains the OS-assigned
-- index corresponding to it.
data PU = PU { puIndex :: Int }
          deriving (Eq, Ord, Show)
