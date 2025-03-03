module Map ( Map, empty, insert, remove ) where
import Data.List( delete )

-- Simple (and rather unperformant) map implementation
-- to avoid having to use external dependencies. Good enough for
-- our purposes

type Map k v = [(k, v)];

empty :: Map k v
empty = [] :: [(k, v)]

remove :: (Eq k) => k -> Map k v -> Map k v
remove key = filter (\(k, v) -> not $ key == k)

insert :: (Eq k) => (k, v) -> Map k v -> Map k v
insert pair map = case lookup key map of
                    Nothing -> pair : map
                    Just _  -> insert pair (remove key map)
                    where key = fst pair

-- ... and use lookup from Prelude for lookup
